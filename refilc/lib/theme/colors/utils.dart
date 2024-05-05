import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/settings.dart';

class ColorsUtils {
  Color darken(Color color, {double amount = .1}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten(Color color, {double amount = .1}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Color fade(BuildContext context, Color color,
      {double darkenAmount = .1, double lightenAmount = .1}) {
    ThemeMode themeMode =
        Provider.of<SettingsProvider>(context, listen: false).theme;
    if (themeMode == ThemeMode.system) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return lighten(color, amount: lightenAmount);
      } else {
        return darken(color, amount: darkenAmount);
      }
    } else if (themeMode == ThemeMode.dark) {
      return lighten(color, amount: lightenAmount);
    } else {
      return darken(color, amount: darkenAmount);
    }
  }
}
