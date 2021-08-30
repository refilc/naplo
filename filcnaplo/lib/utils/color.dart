import 'package:flutter/material.dart';

class ColorUtils {
  static Color stringToColor(String str) {
    int hash = 0;
    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }

    return HSLColor.fromAHSL(1, hash % 360, .8, .75).toColor();
  }

  static Color foregroundColor(Color color) => color.computeLuminance() >= .5 ? Colors.black : Colors.white;
}
