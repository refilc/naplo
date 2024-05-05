import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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

  ThemeModeObserver({ThemeMode initialTheme = ThemeMode.system, bool updateNavbarColor = true})
      : _themeMode = initialTheme,
        _updateNavbarColor = updateNavbarColor;

  void changeTheme(ThemeMode mode, {bool updateNavbarColor = true}) {
    _themeMode = mode;
    _updateNavbarColor = updateNavbarColor;
    if (Platform.isAndroid) updateWidget();
    notifyListeners();
  }
}
