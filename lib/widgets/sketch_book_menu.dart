import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sketch_book/extensions/helper_ex.dart';
import 'package:sketch_book/models/sketch_book_type.dart';

class SketchBookMenu extends StatelessWidget {
  const SketchBookMenu({super.key, required this.onMenuSelected});

  final Function(double, SketchBookType?) onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            context.showToast('Redo');
          },
          icon: const Icon(
            FontAwesomeIcons.redo,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            context.showToast('Undo');
          },
          icon: const Icon(
            FontAwesomeIcons.undo,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () {
            onMenuSelected.call(20, SketchBookType.pencil);
            context.showToast('Brush selected');
          },
          icon: const Icon(
            FontAwesomeIcons.pen,
            size: 30,
          ),
        ),
        _brushSizeButton(context),
        IconButton(
          onPressed: () {
            context.showToast('Eraser selected');
            onMenuSelected.call(20, SketchBookType.eraser);
          },
          icon: const Icon(
            FontAwesomeIcons.eraser,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.trash,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget _brushSizeButton(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: PopupMenuButton(
        onSelected: (value) => onMenuSelected.call(value.toDouble(), null),
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 10,
              child: Text('10'),
            ),
            const PopupMenuItem(
              value: 20,
              child: Text('20'),
            ),
            const PopupMenuItem(
              value: 30,
              child: Text('30'),
            ),
            const PopupMenuItem(
              value: 40,
              child: Text('40'),
            ),
            const PopupMenuItem(
              value: 50,
              child: Text('50'),
            ),
          ];
        },
        child: const Icon(
          FontAwesomeIcons.listUl,
          size: 25,
        ),
      ),
    );
  }
}
