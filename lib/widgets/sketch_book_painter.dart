import 'package:flutter/material.dart';
import 'package:sketch_book/models/sketch_book.dart';

class SketchBookPainter extends CustomPainter {
  SketchBookPainter({
    required this.sketches,
  });
  final List<SketchBook> sketches;
  @override
  void paint(Canvas canvas, Size size) {
    for (var sketch in sketches) {
      final paint = Paint()
        ..color = sketch.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        // ..shader = shader
        ..strokeWidth = sketch.strokeWidth;
      final path = Path();
      path.moveTo(sketch.offsets[0].dx, sketch.offsets[0].dy);
      for (var i = 0; i < sketch.offsets.length; i++) {
        if (i + 1 < sketch.offsets.length) {
          final offset1 = sketch.offsets[i];
          final offset2 = sketch.offsets[i + 1];
          path.quadraticBezierTo(
            offset1.dx,
            offset1.dy,
            offset2.dx,
            offset2.dy,
          );
        }
      }
      canvas.clipRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(8, 35, size.width - 16, size.height - 45),
          const Radius.circular(15),
        ),
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SketchBookPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(SketchBookPainter oldDelegate) => false;
}
