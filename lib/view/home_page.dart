import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    sketches = [];
    sketchType = SketchBookType.pencil;
    selectedColor = Colors.primaries[0];
    strokeWidth = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SketchBookAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SafeArea(
          child: Column(
            children: [
              HomePageBody(
                sketches: sketches,
                onStart: _onStart,
                onUpdate: _onUpdate,
                onEnd: _onEnd,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  ColorPickerList(
                    currentIndex: selectedColorIndex,
                    selectedColor: selectedColor,
                    onColorChanged: (color, index) {
                      setState(() {
                        selectedColor = color;
                        selectedColorIndex = index;
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
                        sketchType = type;
                        selectedColor = Colors.primaries[selectedColorIndex];
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onStart(DragStartDetails details) {
    setState(
      () {
        selectedSketch = SketchBook(
          id: const Uuid().v4(),
          color: selectedColor,
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
