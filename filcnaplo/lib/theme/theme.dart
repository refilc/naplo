import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
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
    var lightColors = AppColors.fromBrightness(Brightness.light);
    AccentColor accentColor = Provider.of<SettingsProvider>(context, listen: false).accentColor;
    Color accent = accentColorMap[accentColor] ?? const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentLight(palette)!;
    } else {
      palette = null;
    }

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: false,
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
    var darkColors = AppColors.fromBrightness(Brightness.dark);
    AccentColor accentColor = Provider.of<SettingsProvider>(context, listen: false).accentColor;
    Color accent = accentColorMap[accentColor] ?? const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentDark(palette)!;
    } else {
      palette = null;
    }

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: false,
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
