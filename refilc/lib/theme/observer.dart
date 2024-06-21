import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shake_flutter/models/shake_theme.dart';
import 'package:shake_flutter/shake_flutter.dart';

Future<bool?> updateWidget() async {
  try {
    return HomeWidget.updateWidget(name: 'widget_timetable.WidgetTimetable');
  } on PlatformException catch (exception) {
    if (kDebugMode) {
      print('Error Updating Widget After changeTheme. $exception');
    }
  }
  return false;
}

class ThemeModeObserver extends ChangeNotifier {
  ThemeMode _themeMode;
  bool _updateNavbarColor;
  ThemeMode get themeMode => _themeMode;
  bool get updateNavbarColor => _updateNavbarColor;

  ThemeModeObserver(
      {ThemeMode initialTheme = ThemeMode.system,
      bool updateNavbarColor = true})
      : _themeMode = initialTheme,
        _updateNavbarColor = updateNavbarColor;

  void changeTheme(ThemeMode mode, {bool updateNavbarColor = true}) {
    _themeMode = mode;
    _updateNavbarColor = updateNavbarColor;
    if (Platform.isAndroid) updateWidget();
    notifyListeners();

    // change shake theme as well
    ShakeTheme darkTheme = ShakeTheme();
    darkTheme.accentColor = "#FFFFFF";
    ShakeTheme lightTheme = ShakeTheme();
    lightTheme.accentColor = "#000000";
    Shake.setShakeTheme(mode == ThemeMode.dark ? darkTheme : lightTheme);
  }
}
