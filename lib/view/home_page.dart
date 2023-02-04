import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sketch_book/extensions/helper_ex.dart';
import 'package:sketch_book/models/sketch_book.dart';
import 'package:sketch_book/models/sketch_book_type.dart';
import 'package:sketch_book/view/home_page_body.dart';
import 'package:sketch_book/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<SketchBook> sketches;
  late List<SketchBook> undoSketches;
  late List<SketchBook> redoSketches;
  late Color selectedColor;
  int selectedColorIndex = 0;
  SketchBook? selectedSketch;
  late SketchBookType sketchType;
  late double strokeWidth;
  XFile? selectedImage;
  late ScreenshotController screenshotController;

  @override
  void initState() {
    super.initState();
    sketches = [];
    undoSketches = [];
    redoSketches = [];
    screenshotController = ScreenshotController();
    sketchType = SketchBookType.pencil;
    selectedColor = Colors.primaries[0];
    strokeWidth = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SketchBookAppBar(
        onSave: () => _onSave(context),
        onSelectImage: _onSelectImage,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 10,
        ),
        child: Column(
          children: [
            HomePageBody(
              image: selectedImage,
              screenshotController: screenshotController,
              sketches: sketches,
              onStart: _onStart,
              onUpdate: _onUpdate,
              onEnd: _onEnd,
            ),
            const SizedBox(
              height: 20,
            ),
            ColorPickerList(
              currentIndex: selectedColorIndex,
              selectedColor: selectedColor,
              onColorChanged: (color, index, type) {
                setState(() {
                  selectedColor = color;
                  selectedColorIndex = index;
                  sketchType = type;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SketchBookMenu(
              onUndo: () {
                if (sketches.isNotEmpty) {
                  setState(() {
                    final sketch = sketches.removeLast();
                    undoSketches.add(sketch);
                  });
                }
              },
              onRedo: () {
                if (undoSketches.isNotEmpty) {
                  setState(() {
                    final sketch = undoSketches.removeLast();
                    sketches.add(sketch);
                  });
                }
              },
              onDelete: () {
                setState(() {
                  sketches.clear();
                  selectedSketch = null;
                });
                context.showToast('Sketches cleared');
              },
              onMenuSelected: (value, type) {
                setState(() {
                  if (sketchType != SketchBookType.eraser) {
                    strokeWidth = value ?? strokeWidth;
                  }
                  sketchType = type ?? sketchType;
                  selectedColor = Colors.primaries[selectedColorIndex];
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void _onSelectImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  void _onSave(BuildContext context) {
    screenshotController.capture().then((image) async {
      String fileName = "sketchbook_${DateTime.now().microsecondsSinceEpoch}";
      if (image != null) {
        await ImageGallerySaver.saveImage(
          image,
          name: fileName,
          isReturnImagePathOfIOS: true,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image saved to gallery'),
            ),
          );
        }
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void _onStart(DragStartDetails details) {
    setState(
      () {
        selectedSketch = SketchBook(
          id: const Uuid().v4(),
          color: sketchType == SketchBookType.eraser
              ? Colors.white
              : selectedColor,
          offsets: [details.localPosition],
          strokeWidth: sketchType == SketchBookType.eraser ? 40 : strokeWidth,
          sketchType: sketchType,
        );
        sketches.add(selectedSketch!);
      },
    );
  }

  void _onEnd(DragEndDetails details) {
    setState(
      () {
        selectedSketch = null;
      },
    );
  }

  void _onUpdate(DragUpdateDetails details) {
    setState(
      () {
        selectedSketch?.offsets.add(details.localPosition);
        final sketch =
            sketches.firstWhere((element) => element.id == selectedSketch?.id);
        sketches[sketches.indexOf(sketch)] =
            sketch.copyWith(offsets: selectedSketch!.offsets);
      },
    );
  }
}
