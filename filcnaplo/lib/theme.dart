import 'package:filcnaplo/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTheme {
  // Dev note: All of these could be constant variables, but this is better for
  //           development (you don't have to hot-restart)

  static const String _fontFamily = "Montserrat";

  // Light Theme
  static ThemeData lightTheme(BuildContext context) {
    var lightColors = LightAppColors();
    Color accent = accentColorMap[Provider.of<SettingsProvider>(context, listen: false).accentColor] ?? Color(0);
    return ThemeData(
        brightness: Brightness.light,
        fontFamily: _fontFamily,
        scaffoldBackgroundColor: lightColors.background,
        backgroundColor: lightColors.highlight,
        primaryColor: lightColors.filc,
        dividerColor: Color(0),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: accent,
          backgroundColor: lightColors.background,
          brightness: Brightness.light,
          cardColor: lightColors.highlight,
          errorColor: lightColors.red,
          primaryColorDark: lightColors.filc,
          primarySwatch: Colors.teal,
        ),
        shadowColor: lightColors.shadow,
        appBarTheme: AppBarTheme(backgroundColor: lightColors.background),
        indicatorColor: accent,
        iconTheme: IconThemeData(color: lightColors.text.withOpacity(.75)));
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    var darkColors = DarkAppColors();
    Color accent = accentColorMap[Provider.of<SettingsProvider>(context, listen: false).accentColor] ?? Color(0);
    return ThemeData(
        brightness: Brightness.dark,
        fontFamily: _fontFamily,
        scaffoldBackgroundColor: darkColors.background,
        backgroundColor: darkColors.highlight,
        primaryColor: darkColors.filc,
        dividerColor: Color(0),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: accent,
          backgroundColor: darkColors.background,
          brightness: Brightness.dark,
          cardColor: darkColors.highlight,
          errorColor: darkColors.red,
          primaryColorDark: darkColors.filc,
          primarySwatch: Colors.teal,
        ),
        shadowColor: darkColors.shadow,
        appBarTheme: AppBarTheme(backgroundColor: darkColors.background),
        indicatorColor: accent,
        iconTheme: IconThemeData(color: darkColors.text.withOpacity(.75)));
  }
}

class AppColors {
  static ThemeAppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? LightAppColors() : DarkAppColors();
  }
}

enum AccentColor { filc, blue, green, lime, yellow, orange, red, pink, purple }

Map<AccentColor, Color> accentColorMap = {
  AccentColor.filc: Color(0xff20AC9B),
  AccentColor.blue: Colors.blue.shade300,
  AccentColor.green: Colors.green.shade300,
  AccentColor.lime: Colors.lime.shade300,
  AccentColor.yellow: Colors.yellow.shade300,
  AccentColor.orange: Colors.deepOrange.shade300,
  AccentColor.red: Colors.red.shade300,
  AccentColor.pink: Colors.pink.shade300,
  AccentColor.purple: Colors.purple.shade300,
};

abstract class ThemeAppColors {
  final Color shadow = Color(0);
  final Color text = Color(0);
  final Color background = Color(0);
  final Color highlight = Color(0);
  final Color red = Color(0);
  final Color orange = Color(0);
  final Color yellow = Color(0);
  final Color green = Color(0);
  final Color filc = Color(0);
  final Color teal = Color(0);
  final Color blue = Color(0);
  final Color indigo = Color(0);
  final Color purple = Color(0);
  final Color pink = Color(0);
}

class LightAppColors implements ThemeAppColors {
  final shadow = Color(0xffE8E8E8);
  final text = Colors.black;
  final background = Color(0xffF4F9FF);
  final highlight = Color(0xffFFFFFF);
  final red = Color(0xffFF3B30);
  final orange = Color(0xffFF9500);
  final yellow = Color(0xffFFCC00);
  final green = Color(0xff34C759);
  final filc = Color(0xff247665);
  final teal = Color(0xff5AC8FA);
  final blue = Color(0xff007AFF);
  final indigo = Color(0xff5856D6);
  final purple = Color(0xffAF52DE);
  final pink = Color(0xffFF2D55);
}

class DarkAppColors implements ThemeAppColors {
  final shadow = Color(0);
  final text = Colors.white;
  final background = Color(0xff000000);
  final highlight = Color(0xff141516);
  final red = Color(0xffFF453A);
  final orange = Color(0xffFF9F0A);
  final yellow = Color(0xffFFD60A);
  final green = Color(0xff32D74B);
  final filc = Color(0xff29826F);
  final teal = Color(0xff64D2FF);
  final blue = Color(0xff0A84FF);
  final indigo = Color(0xff5E5CE6);
  final purple = Color(0xffBF5AF2);
  final pink = Color(0xffFF375F);
}

class ThemeModeObserver extends ChangeNotifier {
  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  ThemeModeObserver({ThemeMode initialTheme = ThemeMode.system}) : _themeMode = initialTheme;

  void changeTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
