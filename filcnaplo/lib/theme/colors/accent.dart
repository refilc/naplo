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
  adaptive,
  custom
}

Map<AccentColor, Color> accentColorMap = {
  AccentColor.filc: Color.fromARGB(255, 61, 123, 244),
  AccentColor.blue: Colors.blue.shade300,
  AccentColor.green: Colors.green.shade400,
  AccentColor.lime: Colors.lightGreen.shade400,
  AccentColor.yellow: Colors.orange.shade300,
  AccentColor.orange: Colors.deepOrange.shade300,
  AccentColor.red: Colors.red.shade300,
  AccentColor.pink: Colors.pink.shade300,
  AccentColor.purple: Colors.purple.shade300,
  AccentColor.adaptive: const Color(0xff3d7bf4),
  AccentColor.custom: const Color(0xff3d7bf4),
};
