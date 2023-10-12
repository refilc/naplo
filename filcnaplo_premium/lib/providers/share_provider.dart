import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/shared_theme.dart';
// import 'package:filcnaplo/models/shared_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ShareProvider extends ChangeNotifier {
  final UserProvider _user;

  ShareProvider({
    required UserProvider user,
  }) : _user = user;

  // Future<void> shareTheme({required SharedTheme theme}) async {

  // }

  // themes
  Future<SharedTheme> shareCurrentTheme(BuildContext context,
      {bool isPublic = false,
      bool shareNick = true,
      required SharedGradeColors gradeColors}) async {
    final SettingsProvider settings =
        Provider.of<SettingsProvider>(context, listen: false);

    Map themeJson = {
      'public_id': const Uuid().v4(),
      'is_public': isPublic,
      'nickname': shareNick ? _user.nickname : 'Anonymous',
      'background_color': (settings.customBackgroundColor ??
              SettingsProvider.defaultSettings().customBackgroundColor)
          ?.value,
      'panels_color': (settings.customHighlightColor ??
              SettingsProvider.defaultSettings().customHighlightColor)
          ?.value,
      'accent_color': (settings.customAccentColor ??
                  SettingsProvider.defaultSettings().customAccentColor)
              ?.value ??
          const Color(0xFF3D7BF4).value,
      'icon_color': (settings.customIconColor ??
                  SettingsProvider.defaultSettings().customIconColor)
              ?.value ??
          const Color(0x00000000).value,
      'shadow_effect': settings.shadowEffect,
    };

    SharedTheme theme = SharedTheme.fromJson(themeJson, gradeColors);
    FilcAPI.addSharedTheme(theme);

    return theme;
  }

  Future<SharedTheme?> getThemeById(BuildContext context,
      {required String id}) async {
    Map? themeJson = await FilcAPI.getSharedTheme(id);

    if (themeJson != null) {
      Map? gradeColorsJson =
          await FilcAPI.getSharedGradeColors(themeJson['grade_colors_id']);

      if (gradeColorsJson != null) {
        SharedTheme theme = SharedTheme.fromJson(
            themeJson, SharedGradeColors.fromJson(gradeColorsJson));
        return theme;
      }
    }

    return null;
  }

  // grade colors
  Future<SharedGradeColors> shareCurrentGradeColors(
    BuildContext context, {
    bool isPublic = false,
    bool shareNick = true,
  }) async {
    final SettingsProvider settings =
        Provider.of<SettingsProvider>(context, listen: false);

    Map gradeColorsJson = {
      'public_id': const Uuid().v4(),
      'is_public': isPublic,
      'nickname': shareNick ? _user.nickname : 'Anonymous',
      'five_color': settings.gradeColors[4].value,
      'four_color': settings.gradeColors[3].value,
      'three_color': settings.gradeColors[2].value,
      'two_color': settings.gradeColors[1].value,
      'one_color': settings.gradeColors[0].value,
    };

    SharedGradeColors gradeColors = SharedGradeColors.fromJson(gradeColorsJson);
    FilcAPI.addSharedGradeColors(gradeColors);

    return gradeColors;
  }

  Future<SharedGradeColors?> getGradeColorsById(BuildContext context,
      {required String id}) async {
    Map? gradeColorsJson = await FilcAPI.getSharedGradeColors(id);

    if (gradeColorsJson != null) {
      SharedGradeColors gradeColors =
          SharedGradeColors.fromJson(gradeColorsJson);
      return gradeColors;
    }

    return null;
  }
}
