import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sketch_book/app/view/app.dart';
import 'package:sketch_book/extensions/helper_ex.dart';
import 'package:sketch_book/models/sketch_book_type.dart';

class SketchBookMenu extends StatelessWidget {
  const SketchBookMenu({
    super.key,
    required this.onMenuSelected,
    required this.onDelete,
    required this.onUndo,
    required this.onRedo,
  });

  final Function(double?, SketchBookType?) onMenuSelected;
  final VoidCallback onDelete;
  final VoidCallback onUndo;
  final VoidCallback onRedo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: onRedo,
          icon: const Icon(
            FontAwesomeIcons.redo,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: onUndo,
          icon: const Icon(
            FontAwesomeIcons.undo,
            size: 25,
          ),
        ),
        _brushTypeButton(context),
        _brushSizeButton(context),
        IconButton(
          onPressed: () {
            context.showToast('Eraser selected');
            onMenuSelected.call(null, SketchBookType.eraser);
          },
          icon: const Icon(
            FontAwesomeIcons.eraser,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(
            FontAwesomeIcons.trash,
            size: 25,
          ),
        ),
        Tooltip(
          message: 'Theme',
          child: ValueListenableBuilder(
            valueListenable: themeMode,
            builder: (context, mode, child) {
              return Switch.adaptive(
                value: mode == ThemeMode.dark,
                onChanged: (value) {
                  themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _brushTypeButton(BuildContext context) {
    return InkResponse(
      child: PopupMenuButton(
        onSelected: (value) => onMenuSelected.call(null, value),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: SketchBookType.pencil,
              child: Text(
                'Normal Brush',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            PopupMenuItem(
              value: SketchBookType.shader,
              child: Text(
                'Rainbow Brush',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            PopupMenuItem(
              value: SketchBookType.dashed,
              child: Text(
                'Dash Brush',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ];
        },
        child: const Icon(
          FontAwesomeIcons.pen,
          size: 30,
        ),
      ),
    );
  }

  Widget _brushSizeButton(BuildContext context) {
    return InkResponse(
      child: PopupMenuButton(
        onSelected: (value) => onMenuSelected.call(value.toDouble(), null),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 10,
              child: Text(
                '10',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            PopupMenuItem(
              value: 20,
              child: Text(
                '20',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            PopupMenuItem(
              value: 30,
              child: Text(
                '30',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            PopupMenuItem(
              value: 40,
              child: Text(
                '40',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            PopupMenuItem(
              value: 50,
              child: Text(
                '50',
                style: Theme.of(context).textTheme.labelLarge,
              ),
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
