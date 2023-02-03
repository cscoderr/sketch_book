import 'dart:ui';

import 'package:sketch_book/presentation/home/models/sketch_book_type.dart';

class SketchBook {
  SketchBook({
    required this.id,
    required this.offsets,
    required this.color,
    required this.strokeWidth,
    required this.sketchType,
  });

  SketchBook copyWith({
    String? id,
    List<Offset>? offsets,
    Color? color,
    double? strokeWidth,
    SketchBookType? sketchType,
  }) {
    return SketchBook(
      id: id ?? this.id,
      offsets: offsets ?? this.offsets,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      sketchType: sketchType ?? this.sketchType,
    );
  }

  final String id;
  final List<Offset> offsets;
  final Color color;
  final double strokeWidth;
  final SketchBookType sketchType;
}
