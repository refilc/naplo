import 'package:filcnaplo/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';

class AppTheme {
  // Dev note: All of these could be constant variables, but this is better for
  //           development (you don't have to hot-restart)

  static const String _fontFamily = "Montserrat";

  static Color? _paletteAccentLight(CorePalette? palette) => palette != null ? Color(palette.primary.get(70)) : null;
  static Color? _paletteHighlightLight(CorePalette? palette) => palette != null ? Color(palette.neutral.get(100)) : null;
  static Color? _paletteBackgroundLight(CorePalette? palette) => palette != null ? Color(palette.neutral.get(95)) : null;

  static Color? _paletteAccentDark(CorePalette? palette) => palette != null ? Color(palette.primary.get(80)) : null;
  static Color? _paletteBackgroundDark(CorePalette? palette) => palette != null ? Color(palette.neutralVariant.get(10)) : null;
  static Color? _paletteHighlightDark(CorePalette? palette) => palette != null ? Color(palette.neutralVariant.get(20)) : null;

  // Light Theme
  static ThemeData lightTheme(BuildContext context, {CorePalette? palette}) {
    var lightColors = LightAppColors();
    AccentColor accentColor = Provider.of<SettingsProvider>(context, listen: false).accentColor;
    Color accent = accentColorMap[accentColor] ?? const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentLight(palette)!;
    } else {
      palette = null;
    }

    return ThemeData(
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: _paletteBackgroundLight(palette) ?? lightColors.background,
      backgroundColor: _paletteHighlightLight(palette) ?? lightColors.highlight,
      primaryColor: lightColors.filc,
      dividerColor: const Color(0x00000000),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: accent,
        backgroundColor: _paletteBackgroundLight(palette) ?? lightColors.background,
        brightness: Brightness.light,
        cardColor: _paletteHighlightLight(palette) ?? lightColors.highlight,
        errorColor: lightColors.red,
        primaryColorDark: lightColors.filc,
        primarySwatch: Colors.teal,
      ),
      shadowColor: lightColors.shadow,
      appBarTheme: AppBarTheme(backgroundColor: _paletteBackgroundLight(palette) ?? lightColors.background),
      indicatorColor: accent,
      iconTheme: IconThemeData(color: lightColors.text.withOpacity(.75)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: accent.withOpacity(accentColor == AccentColor.adaptive ? 0.4 : 0.8),
        iconTheme: MaterialStateProperty.all(IconThemeData(color: lightColors.text)),
        backgroundColor: _paletteHighlightLight(palette) ?? lightColors.highlight,
        labelTextStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: lightColors.text.withOpacity(0.8),
        )),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 76.0,
      ),
      sliderTheme: SliderThemeData(
        inactiveTrackColor: accent.withOpacity(.3),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
      expansionTileTheme: ExpansionTileThemeData(iconColor: accent),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context, {CorePalette? palette}) {
    var darkColors = DarkAppColors();
    AccentColor accentColor = Provider.of<SettingsProvider>(context, listen: false).accentColor;
    Color accent = accentColorMap[accentColor] ?? const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentDark(palette)!;
    } else {
      palette = null;
    }

    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: _paletteBackgroundDark(palette) ?? darkColors.background,
      backgroundColor: _paletteHighlightDark(palette) ?? darkColors.highlight,
      primaryColor: darkColors.filc,
      dividerColor: const Color(0x00000000),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: accent,
        backgroundColor: _paletteBackgroundDark(palette) ?? darkColors.background,
        brightness: Brightness.dark,
        cardColor: _paletteHighlightDark(palette) ?? darkColors.highlight,
        errorColor: darkColors.red,
        primaryColorDark: darkColors.filc,
        primarySwatch: Colors.teal,
      ),
      shadowColor: darkColors.shadow,
      appBarTheme: AppBarTheme(backgroundColor: _paletteBackgroundDark(palette) ?? darkColors.background),
      indicatorColor: accent,
      iconTheme: IconThemeData(color: darkColors.text.withOpacity(.75)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: accent.withOpacity(accentColor == AccentColor.adaptive ? 0.4 : 0.8),
        iconTheme: MaterialStateProperty.all(IconThemeData(color: darkColors.text)),
        backgroundColor: _paletteHighlightDark(palette) ?? darkColors.highlight,
        labelTextStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: darkColors.text.withOpacity(0.8),
        )),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 76.0,
      ),
      sliderTheme: SliderThemeData(
        inactiveTrackColor: accent.withOpacity(.3),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
      expansionTileTheme: ExpansionTileThemeData(iconColor: accent),
    );
  }
}

class AppColors {
  static ThemeAppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? LightAppColors() : DarkAppColors();
  }
}

enum AccentColor { filc, blue, green, lime, yellow, orange, red, pink, purple, adaptive }

Map<AccentColor, Color> accentColorMap = {
  AccentColor.filc: const Color(0xff20AC9B),
  AccentColor.blue: Colors.blue.shade300,
  AccentColor.green: Colors.green.shade400,
  AccentColor.lime: Colors.lightGreen.shade400,
  AccentColor.yellow: Colors.orange.shade300,
  AccentColor.orange: Colors.deepOrange.shade300,
  AccentColor.red: Colors.red.shade300,
  AccentColor.pink: Colors.pink.shade300,
  AccentColor.purple: Colors.purple.shade300,
  AccentColor.adaptive: const Color(0xff20AC9B),
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
