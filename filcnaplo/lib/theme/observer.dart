import 'package:flutter/material.dart';

class ThemeModeObserver extends ChangeNotifier {
  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  ThemeModeObserver({ThemeMode initialTheme = ThemeMode.system}) : _themeMode = initialTheme;

  void changeTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
