import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/accent.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/theme/colors/utils.dart';
import 'package:refilc/theme/observer.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dev note: All of these could be constant variables, but this is better for
  //           development (you don't have to hot-restart)

  static const String _defaultFontFamily = "Montserrat";

  static Color? _paletteAccentLight(CorePalette? palette) =>
      palette != null ? Color(palette.primary.get(70)) : null;
  static Color? _paletteHighlightLight(CorePalette? palette) =>
      palette != null ? Color(palette.neutral.get(100)) : null;
  static Color? _paletteBackgroundLight(CorePalette? palette) =>
      palette != null ? Color(palette.neutral.get(95)) : null;
  static Color? _paletteTextLight(CorePalette? palette) =>
      palette != null ? Color(palette.neutral.get(10)) : null;

  static Color? _paletteAccentDark(CorePalette? palette) =>
      palette != null ? Color(palette.primary.get(80)) : null;
  static Color? _paletteBackgroundDark(CorePalette? palette) =>
      palette != null ? Color(palette.neutralVariant.get(10)) : null;
  static Color? _paletteHighlightDark(CorePalette? palette) =>
      palette != null ? Color(palette.neutralVariant.get(20)) : null;
  static Color? _paletteTextDark(CorePalette? palette) =>
      palette != null ? Color(palette.neutralVariant.get(100)) : null;

  static Map<String, TextTheme?> googleFontsMap = {
    "Merienda": GoogleFonts.meriendaTextTheme(),
    "M PLUS Code Latin": GoogleFonts.mPlusCodeLatinTextTheme(),
    "Figtree": GoogleFonts.figtreeTextTheme(),
    "Fira Code": GoogleFonts.firaCodeTextTheme(),
    "Vollkorn": GoogleFonts.vollkornTextTheme(),
  };

  // Light Theme
  static ThemeData lightTheme(BuildContext context, {CorePalette? palette}) {
    var lightColors = AppColors.fromBrightness(Brightness.light);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    AccentColor accentColor = settings.accentColor;
    final customAccentColor =
        accentColor == AccentColor.custom ? settings.customAccentColor : null;
    Color accent = customAccentColor ??
        accentColorMap[accentColor] ??
        const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentLight(palette)!;
    } else {
      palette = null;
    }

    Color backgroundColor = (accentColor == AccentColor.custom
            ? settings.customBackgroundColor
            : _paletteBackgroundLight(palette)) ??
        lightColors.background;
    Color highlightColor = (accentColor == AccentColor.custom
            ? settings.customHighlightColor
            : _paletteHighlightLight(palette)) ??
        lightColors.highlight;
    // Color textColor = (accentColor == AccentColor.custom
    //          ? settings.customTextColor
    //          : _paletteTextLight(palette)) ??
    //     lightColors.text;
    Color textColor = lightColors.text;

    Color newSecondary = (accentColor == AccentColor.adaptive ||
                accentColor == AccentColor.custom ||
                accentColor == AccentColor.ogfilc) ||
            !settings.newColors
        ? accent
        : ColorsUtils().darken(accent, amount: 0.4);
    // Color newScaffoldBg = ColorsUtils().lighten(accent, amount: 0.4);
    Color newTertiary = (accentColor == AccentColor.adaptive ||
                accentColor == AccentColor.custom ||
                accentColor == AccentColor.ogfilc) ||
            !settings.newColors
        ? accent
        : ColorsUtils().darken(accent, amount: 0.5);

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: _defaultFontFamily,
      textTheme:
          googleFontsMap[settings.fontFamily]?.apply(bodyColor: textColor) ??
              const TextTheme().apply(bodyColor: textColor),
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: lightColors.filc,
      dividerColor: const Color(0x00000000),
      colorScheme: ColorScheme(
        primary: accent,
        onPrimary:
            (accent.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        secondary: newSecondary,
        onSecondary: (newSecondary.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white)
            .withOpacity(.9),
        tertiary: newTertiary,
        onTertiary:
            (newTertiary.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        background: highlightColor,
        onBackground: Colors.black.withOpacity(.9),
        brightness: Brightness.light,
        error: lightColors.red,
        onError: Colors.white.withOpacity(.9),
        surface: highlightColor,
        onSurface: Colors.black.withOpacity(.9),
      ),
      shadowColor: lightColors.shadow.withOpacity(.5),
      appBarTheme: AppBarTheme(backgroundColor: backgroundColor),
      indicatorColor: accent,
      iconTheme: IconThemeData(color: lightColors.text.withOpacity(.75)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor:
            accent.withOpacity(accentColor == AccentColor.adaptive ? 0.4 : 0.8),
        iconTheme:
            MaterialStateProperty.all(IconThemeData(color: lightColors.text)),
        backgroundColor: highlightColor,
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
      cardColor: highlightColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Provider.of<ThemeModeObserver>(context, listen: false)
                .updateNavbarColor
            ? backgroundColor
            : null,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context, {CorePalette? palette}) {
    var darkColors = AppColors.fromBrightness(Brightness.dark);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    AccentColor accentColor = settings.accentColor;
    final customAccentColor =
        accentColor == AccentColor.custom ? settings.customAccentColor : null;
    Color accent = customAccentColor ??
        accentColorMap[accentColor] ??
        const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentDark(palette)!;
    } else {
      palette = null;
    }

    Color backgroundColor = (accentColor == AccentColor.custom
            ? settings.customBackgroundColor
            : _paletteBackgroundDark(palette)) ??
        darkColors.background;
    Color highlightColor = (accentColor == AccentColor.custom
            ? settings.customHighlightColor
            : _paletteHighlightDark(palette)) ??
        darkColors.highlight;
    // Color textColor = (accentColor == AccentColor.custom
    //         ? settings.customTextColor
    //         : _paletteTextDark(palette)) ??
    //     darkColors.text;
    Color textColor = darkColors.text;

    Color newSecondary = (accentColor == AccentColor.adaptive ||
                accentColor == AccentColor.custom ||
                accentColor == AccentColor.ogfilc) ||
            !settings.newColors
        ? accent
        : ColorsUtils().lighten(accent, amount: 0.1);
    // Color newScaffoldBg = ColorsUtils().lighten(accent, amount: 0.4);
    Color newTertiary = (accentColor == AccentColor.adaptive ||
                accentColor == AccentColor.custom ||
                accentColor == AccentColor.ogfilc) ||
            !settings.newColors
        ? accent
        : ColorsUtils().lighten(accent, amount: 0.4);

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: _defaultFontFamily,
      textTheme:
          googleFontsMap[settings.fontFamily]?.apply(bodyColor: textColor),
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: darkColors.filc,
      dividerColor: const Color(0x00000000),
      colorScheme: ColorScheme(
        primary: accent,
        onPrimary:
            (accent.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        secondary: newSecondary,
        onSecondary: (newSecondary.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white)
            .withOpacity(.9),
        tertiary: newTertiary,
        onTertiary:
            (newTertiary.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        background: highlightColor,
        onBackground: Colors.white.withOpacity(.9),
        brightness: Brightness.dark,
        error: darkColors.red,
        onError: Colors.black.withOpacity(.9),
        surface: highlightColor,
        onSurface: Colors.white.withOpacity(.9),
      ),
      shadowColor: highlightColor.withOpacity(.5), //darkColors.shadow,
      appBarTheme: AppBarTheme(backgroundColor: backgroundColor),
      indicatorColor: accent,
      iconTheme: IconThemeData(color: darkColors.text.withOpacity(.75)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor:
            accent.withOpacity(accentColor == AccentColor.adaptive ? 0.4 : 0.8),
        iconTheme:
            MaterialStateProperty.all(IconThemeData(color: darkColors.text)),
        backgroundColor: highlightColor,
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
      cardColor: highlightColor,
      chipTheme: ChipThemeData(
        backgroundColor: accent.withOpacity(.2),
        elevation: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Provider.of<ThemeModeObserver>(context, listen: false)
                .updateNavbarColor
            ? backgroundColor
            : null,
      ),
    );
  }
}
