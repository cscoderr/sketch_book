import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sketch_book/models/sketch_book.dart';
import 'package:sketch_book/widgets/widgets.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
    this.image,
    required this.screenshotController,
    required this.sketches,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
  });

  final ScreenshotController screenshotController;
  final XFile? image;
  final List<SketchBook> sketches;
  final ValueChanged<DragStartDetails> onStart;
  final ValueChanged<DragUpdateDetails> onUpdate;
  final ValueChanged<DragEndDetails> onEnd;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: GestureDetector(
        onPanStart: onStart,
        onPanUpdate: onUpdate,
        onPanEnd: onEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/sketchbook_bg.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fill(
              child: Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: [
                    if (image != null)
                      Positioned(
                        top: 50,
                        right: 20,
                        left: 20,
                        bottom: 30,
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.fill,
                        ),
                      ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SketchBookPainter(
                          sketches: sketches,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
