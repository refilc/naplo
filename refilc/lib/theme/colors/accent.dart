import 'package:flutter/material.dart';

enum AccentColor {
  filc,
  blue,
  green,
  lime,
  yellow,
  orange,
  red,
  pink,
  purple,
  none,
  ogfilc,
  adaptive,
  custom
}

Map<AccentColor, Color> accentColorMap = {
  AccentColor.filc: const Color(0xFF3D7BF4),
  AccentColor.blue: Colors.blue.shade300,
  AccentColor.green: Colors.green.shade400,
  AccentColor.lime: Colors.lightGreen.shade400,
  AccentColor.yellow: Colors.orange.shade300,
  AccentColor.orange: Colors.deepOrange.shade300,
  AccentColor.red: Colors.red.shade300,
  AccentColor.pink: Colors.pink.shade300,
  AccentColor.purple: Colors.purple.shade300,
  //AccentColor.none: Colors.black,
  AccentColor.ogfilc: const Color(0xff20AC9B),
  AccentColor.adaptive: const Color(0xFF3D7BF4),
  AccentColor.custom: const Color(0xFF3D7BF4),
};
