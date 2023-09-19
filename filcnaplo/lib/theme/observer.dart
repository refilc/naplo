import 'package:flutter/material.dart';

class ThemeModeObserver extends ChangeNotifier {
  ThemeMode _themeMode;
  bool _updateNavbarColor;
  ThemeMode get themeMode => _themeMode;
  bool get updateNavbarColor => _updateNavbarColor;

  ThemeModeObserver({ThemeMode initialTheme = ThemeMode.system, bool updateNavbarColor = true})
      : _themeMode = initialTheme,
        _updateNavbarColor = updateNavbarColor;

  void changeTheme(ThemeMode mode, {bool updateNavbarColor = true}) {
    _themeMode = mode;
    _updateNavbarColor = updateNavbarColor;
    notifyListeners();
  }
}
