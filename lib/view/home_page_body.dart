import 'package:flutter/material.dart';
import 'package:sketch_book/models/sketch_book.dart';
import 'package:sketch_book/widgets/widgets.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
    required this.sketches,
    required this.onStart,
    required this.onUpdate,
    required this.onEnd,
  });

  final List<SketchBook> sketches;
  final ValueChanged<DragStartDetails> onStart;
  final ValueChanged<DragUpdateDetails> onUpdate;
  final ValueChanged<DragEndDetails> onEnd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRect(
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
              // Positioned(
              //   top: 0,
              //   right: 20,
              //   left: 20,
              //   bottom: 0,
              //   child: Image.network(
              //     'https://img.freepik.com/premium-vector/hand-painted-background-violet-orange-colours_23-2148427578.jpg',
              //     fit: BoxFit.scaleDown,
              //   ),
              // ),
              Positioned.fill(
                child: CustomPaint(
                  painter: SketchBookPainter(
                    sketches: sketches,
                  ),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
