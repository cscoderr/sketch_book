import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
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
  late Color selectedColor;
  int selectedColorIndex = 0;
  SketchBook? selectedSketch;
  late SketchBookType sketchType;
  late double strokeWidth;
  Uint8List? _imageFile;
  late ScreenshotController screenshotController;

  @override
  void initState() {
    super.initState();
    sketches = [];
    screenshotController = ScreenshotController();
    sketchType = SketchBookType.pencil;
    selectedColor = Colors.primaries[0];
    strokeWidth = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SketchBookAppBar(
        onSave: _onSave,
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
              onMenuSelected: (value, type) {
                setState(() {
                  strokeWidth = value;
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

  void _onSelectImage() {}

  void _onSave() {
    screenshotController.capture().then((image) {
      print("capture");
      _imageFile = image;
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
          strokeWidth: strokeWidth,
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
