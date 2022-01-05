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
    Color accent = accentColorMap[Provider.of<SettingsProvider>(context, listen: false).accentColor] ?? const Color(0x00000000);
    return ThemeData(
        brightness: Brightness.light,
        fontFamily: _fontFamily,
        scaffoldBackgroundColor: lightColors.background,
        backgroundColor: lightColors.highlight,
        primaryColor: lightColors.filc,
        dividerColor: const Color(0x00000000),
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
    Color accent = accentColorMap[Provider.of<SettingsProvider>(context, listen: false).accentColor] ?? const Color(0x00000000);
    return ThemeData(
        brightness: Brightness.dark,
        fontFamily: _fontFamily,
        scaffoldBackgroundColor: darkColors.background,
        backgroundColor: darkColors.highlight,
        primaryColor: darkColors.filc,
        dividerColor: const Color(0x00000000),
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
  AccentColor.filc: const Color(0xff20AC9B),
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
  final Color shadow = const Color(0x00000000);
  final Color text = const Color(0x00000000);
  final Color background = const Color(0x00000000);
  final Color highlight = const Color(0x00000000);
  final Color red = const Color(0x00000000);
  final Color orange = const Color(0x00000000);
  final Color yellow = const Color(0x00000000);
  final Color green = const Color(0x00000000);
  final Color filc = const Color(0x00000000);
  final Color teal = const Color(0x00000000);
  final Color blue = const Color(0x00000000);
  final Color indigo = const Color(0x00000000);
  final Color purple = const Color(0x00000000);
  final Color pink = const Color(0x00000000);
}

class LightAppColors implements ThemeAppColors {
  @override
  final shadow = const Color(0xffE8E8E8);
  @override
  final text = Colors.black;
  @override
  final background = const Color(0xffF4F9FF);
  @override
  final highlight = const Color(0xffFFFFFF);
  @override
  final red = const Color(0xffFF3B30);
  @override
  final orange = const Color(0xffFF9500);
  @override
  final yellow = const Color(0xffFFCC00);
  @override
  final green = const Color(0xff34C759);
  @override
  final filc = const Color(0xff247665);
  @override
  final teal = const Color(0xff5AC8FA);
  @override
  final blue = const Color(0xff007AFF);
  @override
  final indigo = const Color(0xff5856D6);
  @override
  final purple = const Color(0xffAF52DE);
  @override
  final pink = const Color(0xffFF2D55);
}

class DarkAppColors implements ThemeAppColors {
  @override
  final shadow = const Color(0x00000000);
  @override
  final text = Colors.white;
  @override
  final background = const Color(0xff000000);
  @override
  final highlight = const Color(0xff141516);
  @override
  final red = const Color(0xffFF453A);
  @override
  final orange = const Color(0xffFF9F0A);
  @override
  final yellow = const Color(0xffFFD60A);
  @override
  final green = const Color(0xff32D74B);
  @override
  final filc = const Color(0xff29826F);
  @override
  final teal = const Color(0xff64D2FF);
  @override
  final blue = const Color(0xff0A84FF);
  @override
  final indigo = const Color(0xff5E5CE6);
  @override
  final purple = const Color(0xffBF5AF2);
  @override
  final pink = const Color(0xffFF375F);
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
