import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:sketch_book/models/sketch_book.dart';
import 'package:sketch_book/models/sketch_book_type.dart';

class SketchBookPainter extends CustomPainter {
  SketchBookPainter({
    required this.sketches,
  });
  final List<SketchBook> sketches;
  @override
  void paint(Canvas canvas, Size size) {
    for (var sketch in sketches) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        // ..shader = shader
        ..strokeWidth = sketch.strokeWidth;

      if (sketch.sketchType == SketchBookType.shader) {
        final shader = const LinearGradient(
          colors: Colors.primaries,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
        paint.shader = shader;
      } else {
        paint.color = sketch.color;
      }
      final path = Path();
      Path dottedPath = Path();
      path.moveTo(sketch.offsets[0].dx, sketch.offsets[0].dy);
      for (var i = 0; i < sketch.offsets.length; i++) {
        if (i + 1 < sketch.offsets.length) {
          final offset1 = sketch.offsets[i];
          final offset2 = sketch.offsets[i + 1];
          if (sketch.sketchType == SketchBookType.dashed) {
            paint.strokeCap = StrokeCap.round;
            path.quadraticBezierTo(
              offset1.dx,
              offset1.dy,
              offset2.dx,
              offset2.dy,
            );
            dottedPath = dashPath(path,
                dashArray: CircularIntervalList(
                  <double>[10, sketch.strokeWidth],
                ));
          } else {
            path.quadraticBezierTo(
              offset1.dx,
              offset1.dy,
              offset2.dx,
              offset2.dy,
            );
          }
        }
      }
      canvas.clipRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(8, 35, size.width - 16, size.height - 45),
          const Radius.circular(15),
        ),
      );
      if (sketch.sketchType == SketchBookType.dashed) {
        canvas.drawPath(dottedPath, paint);
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SketchBookPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(SketchBookPainter oldDelegate) => false;
}
