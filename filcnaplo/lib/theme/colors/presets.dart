import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:flutter/material.dart';

// enum PresetColorTheme {
//   filc,
//   blue,
//   green,
//   lime,
//   yellow,
//   orange,
//   red,
//   pink,
//   purple,
//   none,
//   ogfilc,
//   adaptive,
//   custom,
// }

enum ColorType {
  title,
  background,
  primary,
  secondary,
  accent,
}

class PresetTheme {
  Color title;
  Color subtitle;
  Color background;
  Color primary;
  Color secondary;
  Color accent;

  PresetTheme({
    required this.title,
    required this.subtitle,
    required this.background,
    required this.primary,
    required this.secondary,
    required this.accent,
  });
}

Map<AccentColor, PresetTheme> lightPresetsMap = {
  AccentColor.filc: PresetTheme(
    title: const Color(0xFF0A1C41),
    subtitle: const Color(0xFF011234),
    background: const Color(0xFFEFF4FE),
    primary: const Color(0xFF243F76),
    secondary: const Color(0xFFAFC1E4),
    accent: const Color(0xFF3D7BF4),
  ),
  AccentColor.ogfilc: PresetTheme(
    title: const Color(0xFF0A4135),
    subtitle: const Color(0xFF000000),
    background: const Color(0xFFEFF4FE),
    primary: const Color(0xFF247665),
    secondary: const Color(0xFFAFE4D9),
    accent: const Color(0xFF247665),
  ),
};

Map<AccentColor, PresetTheme> darkPresetsMap = {
  AccentColor.filc: PresetTheme(
    title: const Color(0xFFD4DAE7),
    subtitle: const Color(0xFFD4DAE7),
    background: const Color(0xFF0F131D),
    primary: const Color(0xFF243F76),
    secondary: const Color(0xFFAFC1E4),
    accent: const Color(0xFF3D7BF4),
  ),
  AccentColor.ogfilc: PresetTheme(
    title: const Color(0xFFD4E7D7),
    subtitle: const Color(0xFFFFFFFF),
    background: const Color(0xFF0F1D10),
    primary: const Color(0xFF247665),
    secondary: const Color(0xFFAFE4D9),
    accent: const Color(0xFF247665),
  ),
};
