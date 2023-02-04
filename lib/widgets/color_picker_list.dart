import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sketch_book/app/view/app.dart';
import 'package:sketch_book/models/sketch_book_type.dart';

class ColorPickerList extends StatelessWidget {
  const ColorPickerList({
    super.key,
    required this.selectedColor,
    required this.currentIndex,
    required this.onColorChanged,
  });

  final Color selectedColor;
  final int currentIndex;
  final Function(Color, int, SketchBookType) onColorChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () => _colorPickerDialog(context),
              child: Image.asset(
                'assets/images/palette.png',
                height: 45,
                width: 45,
              ),
            );
          }
          final colorIndex = index - 1;
          return InkResponse(
            onTap: () => onColorChanged.call(
              Colors.primaries[colorIndex],
              colorIndex,
              SketchBookType.pencil,
            ),
            child: ValueListenableBuilder(
              valueListenable: themeMode,
              builder: (context, mode, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: currentIndex == colorIndex ? 60 : 45,
                  width: currentIndex == colorIndex ? 60 : 45,
                  decoration: BoxDecoration(
                    color: Colors.primaries[colorIndex],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          mode == ThemeMode.dark ? Colors.white : Colors.black,
                      width: currentIndex == colorIndex ? 4 : 2,
                    ),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: Colors.primaries.length + 1,
      ),
    );
  }

  void _colorPickerDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) => onColorChanged.call(
                color,
                currentIndex,
                SketchBookType.pencil,
              ),
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.9,
              enableAlpha: true,
              labelTypes: const [ColorLabelType.rgb],
              displayThumbColor: true,
              paletteType: PaletteType.hueWheel,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              hexInputBar: false,
            ),
          ),
        );
      },
    );
  }
}
