// FROM: https://pub.dev/packages/flutter_colorpicker
// FROM: https://pub.dev/packages/flutter_colorpicker
// FROM: https://pub.dev/packages/flutter_colorpicker
// FROM: https://pub.dev/packages/flutter_colorpicker

/// Blocky Color Picker

library block_colorpicker;

import 'package:flutter/material.dart';
import 'package:refilc/theme/colors/accent.dart';
import 'utils.dart';

/// Child widget for layout builder.
typedef PickerItem = Widget Function(Color color);

/// Customize the layout.
typedef PickerLayoutBuilder = Widget Function(
    BuildContext context, List<Color> colors, PickerItem child);

/// Customize the item shape.
typedef PickerItemBuilder = Widget Function(
    Color color, bool isCurrentColor, void Function() changeColor);

// Provide a list of colors for block color picker.
// const List<Color> _defaultColors = [
//   Colors.red,
//   Colors.pink,
//   Colors.purple,
//   Colors.deepPurple,
//   Colors.indigo,
//   Colors.blue,
//   Colors.lightBlue,
//   Colors.cyan,
//   Colors.teal,
//   Colors.green,
//   Colors.lightGreen,
//   Colors.lime,
//   Colors.yellow,
//   Colors.amber,
//   Colors.orange,
//   Colors.deepOrange,
//   Colors.brown,
//   Colors.grey,
//   Colors.blueGrey,
//   Colors.black,
// ];

// Provide a layout for [BlockPicker].
Widget _defaultLayoutBuilder(
    BuildContext context, List<Color> colors, PickerItem child) {
  Orientation orientation = MediaQuery.of(context).orientation;

  return SizedBox(
    width: 300,
    height: orientation == Orientation.portrait ? 360 : 200,
    child: GridView.count(
      crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [for (Color color in colors) child(color)],
    ),
  );
}

// Provide a shape for [BlockPicker].
Widget _defaultItemBuilder(
    Color color, bool isCurrentColor, void Function() changeColor) {
  return Container(
    margin: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(
            color: color.withOpacity(0.8),
            offset: const Offset(1, 2),
            blurRadius: 5)
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: changeColor,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 210),
          opacity: isCurrentColor ? 1 : 0,
          child: Icon(Icons.done,
              color: useWhiteForeground(color) ? Colors.white : Colors.black),
        ),
      ),
    ),
  );
}

// The blocky color picker you can alter the layout and shape.
class BlockPicker extends StatefulWidget {
  BlockPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.useInShowDialog = true,
    this.layoutBuilder = _defaultLayoutBuilder,
    this.itemBuilder = _defaultItemBuilder,
  });

  final Color? pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors = accentColorMap.values.toList();
  final bool useInShowDialog;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _BlockPickerState();
}

class _BlockPickerState extends State<BlockPicker> {
  Color? _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
      (Color color) => widget.itemBuilder(
        color,
        (_currentColor != null &&
                (widget.useInShowDialog ? true : widget.pickerColor != null))
            ? (_currentColor?.value == color.value) &&
                (widget.useInShowDialog
                    ? true
                    : widget.pickerColor?.value == color.value)
            : false,
        () => changeColor(color),
      ),
    );
  }
}
