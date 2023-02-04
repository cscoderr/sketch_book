import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SketchBookAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SketchBookAppBar({
    super.key,
    required this.onSave,
    required this.onSelectImage,
  });

  final VoidCallback onSave;
  final VoidCallback onSelectImage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        'Sketch Book',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(),
      ),
      actions: [
        IconButton(
          onPressed: () => onSelectImage.call(),
          icon: const Icon(
            FontAwesomeIcons.image,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () => onSave.call(),
          icon: const Icon(
            FontAwesomeIcons.solidFloppyDisk,
            size: 25,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
