import 'dart:convert';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/config.dart';
import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

enum Pages { home, grades, timetable, messages, absences }
enum UpdateChannel { stable, beta, dev }
enum VibrationStrength { light, medium, strong }

class SettingsProvider extends ChangeNotifier {
  PackageInfo? _packageInfo;

  // en_en, hu_hu, de_de
  String _language;
  Pages _startPage;
  // divide by 10
  int _rounding;
  ThemeMode _theme;
  AccentColor _accentColor;
  // zero is one, ...
  List<Color> _gradeColors;
  bool _newsEnabled;
  int _newsState;
  bool _notificationsEnabled;
  /*
  notificationsBitfield values:

  1 << 0 current lesson
  1 << 1 newsletter
  1 << 2 grades
  1 << 3 notes and events
  1 << 4 inbox messages
  1 << 5 substituted lessons and cancelled lessons
  1 << 6 absences and misses
  1 << 7 exams and homework
  */
  int _notificationsBitfield;
  // minutes: times 15
  int _notificationPollInterval;
  bool _developerMode;
  bool _vibrate;
  VibrationStrength _vibrationStrength;
  bool _ABweeks;
  bool _swapABweeks;
  UpdateChannel _updateChannel;
  Config _config;

  SettingsProvider({
    required String language,
    required Pages startPage,
    required int rounding,
    required ThemeMode theme,
    required AccentColor accentColor,
    required List<Color> gradeColors,
    required bool newsEnabled,
    required int newsState,
    required bool notificationsEnabled,
    required int notificationsBitfield,
    required bool developerMode,
    required int notificationPollInterval,
    required bool vibrate,
    required VibrationStrength vibrationStrength,
    required bool ABweeks,
    required bool swapABweeks,
    required UpdateChannel updateChannel,
    required Config config,
  })  : _language = language,
        _startPage = startPage,
        _rounding = rounding,
        _theme = theme,
        _accentColor = accentColor,
        _gradeColors = gradeColors,
        _newsEnabled = newsEnabled,
        _newsState = newsState,
        _notificationsEnabled = notificationsEnabled,
        _notificationsBitfield = notificationsBitfield,
        _developerMode = developerMode,
        _notificationPollInterval = notificationPollInterval,
        _vibrate = vibrate,
        _vibrationStrength = vibrationStrength,
        _ABweeks = ABweeks,
        _swapABweeks = swapABweeks,
        _updateChannel = updateChannel,
        _config = config {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _packageInfo = packageInfo;
    });
  }

  factory SettingsProvider.fromMap(Map map) {
    return SettingsProvider(
      language: map["language"],
      startPage: Pages.values[map["start_page"]],
      rounding: map["rounding"],
      theme: ThemeMode.values[map["theme"]],
      accentColor: AccentColor.values[map["accent_color"]],
      gradeColors: [
        Color(map["grade_color1"]),
        Color(map["grade_color2"]),
        Color(map["grade_color3"]),
        Color(map["grade_color4"]),
        Color(map["grade_color5"]),
      ],
      newsEnabled: map["news"] == 1 ? true : false,
      newsState: map["news_state"],
      notificationsEnabled: map["notifications"] == 1 ? true : false,
      notificationsBitfield: map["notifications_bitfield"],
      notificationPollInterval: map["notification_poll_interval"],
      developerMode: map["developer_mode"] == 1 ? true : false,
      vibrate: map["vibrate"] == 1 ? true : false,
      vibrationStrength: VibrationStrength.values[map["vibration_strength"]],
      ABweeks: map["ab_weeks"] == 1 ? true : false,
      swapABweeks: map["swap_ab_weeks"] == 1 ? true : false,
      updateChannel: UpdateChannel.values[map["update_channel"]],
      config: Config.fromJson(jsonDecode(map["config"] ?? "{}")),
    );
  }

  Map<String, Object?> toMap() {
    return {
      "language": _language,
      "start_page": _startPage.index,
      "rounding": _rounding,
      "theme": _theme.index,
      "accent_color": _accentColor.index,
      "news": _newsEnabled ? 1 : 0,
      "news_state": _newsState,
      "notifications": _notificationsEnabled ? 1 : 0,
      "notifications_bitfield": _notificationsBitfield,
      "developer_mode": _developerMode ? 1 : 0,
      "grade_color1": _gradeColors[0].value,
      "grade_color2": _gradeColors[1].value,
      "grade_color3": _gradeColors[2].value,
      "grade_color4": _gradeColors[3].value,
      "grade_color5": _gradeColors[4].value,
      "update_channel": _updateChannel.index,
      "vibrate": _vibrate ? 1 : 0,
      "vibration_strength": _vibrationStrength.index,
      "ab_weeks": _ABweeks ? 1 : 0,
      "swap_ab_weeks": _swapABweeks ? 1 : 0,
      "notification_poll_interval": _notificationPollInterval,
      "config": jsonEncode(config.json),
    };
  }

  factory SettingsProvider.defaultSettings() {
    return SettingsProvider(
      language: "hu",
      startPage: Pages.home,
      rounding: 5,
      theme: ThemeMode.system,
      accentColor: AccentColor.filc,
      gradeColors: [
        DarkAppColors().red,
        DarkAppColors().orange,
        DarkAppColors().yellow,
        DarkAppColors().green,
        DarkAppColors().filc,
      ],
      newsEnabled: true,
      newsState: -1,
      notificationsEnabled: true,
      notificationsBitfield: 255,
      developerMode: false,
      notificationPollInterval: 1,
      vibrate: true,
      vibrationStrength: VibrationStrength.medium,
      ABweeks: false,
      swapABweeks: false,
      updateChannel: UpdateChannel.stable,
      config: Config.fromJson({}),
    );
  }

  // Getters
  String get language => _language;
  Pages get startPage => _startPage;
  int get rounding => _rounding;
  ThemeMode get theme => _theme;
  AccentColor get accentColor => _accentColor;
  List<Color> get gradeColors => _gradeColors;
  bool get newsEnabled => _newsEnabled;
  int get newsState => _newsState;
  bool get notificationsEnabled => _notificationsEnabled;
  int get notificationsBitfield => _notificationsBitfield;
  bool get developerMode => _developerMode;
  int get notificationPollInterval => _notificationPollInterval;
  bool get vibrate => _vibrate;
  VibrationStrength get vibrationStrength => _vibrationStrength;
  bool get ABweeks => _ABweeks;
  bool get swapABweeks => _swapABweeks;
  UpdateChannel get updateChannel => _updateChannel;
  PackageInfo? get packageInfo => _packageInfo;
  Config get config => _config;

  Future<void> update(
    BuildContext context, {
    DatabaseProvider? database,
    String? language,
    Pages? startPage,
    int? rounding,
    ThemeMode? theme,
    AccentColor? accentColor,
    List<Color>? gradeColors,
    bool? newsEnabled,
    int? newsState,
    bool? notificationsEnabled,
    int? notificationsBitfield,
    bool? developerMode,
    int? notificationPollInterval,
    bool? vibrate,
    VibrationStrength? vibrationStrength,
    bool? ABweeks,
    bool? swapABweeks,
    UpdateChannel? updateChannel,
    Config? config,
  }) async {
    if (language != null && language != _language) _language = language;
    if (startPage != null && startPage != _startPage) _startPage = startPage;
    if (rounding != null && rounding != _rounding) _rounding = rounding;
    if (theme != null && theme != _theme) _theme = theme;
    if (accentColor != null && accentColor != _accentColor) _accentColor = accentColor;
    if (gradeColors != null && gradeColors != _gradeColors) _gradeColors = gradeColors;
    if (newsEnabled != null && newsEnabled != _newsEnabled) _newsEnabled = newsEnabled;
    if (newsState != null && newsState != _newsState) _newsState = newsState;
    if (notificationsEnabled != null && notificationsEnabled != _notificationsEnabled) _notificationsEnabled = notificationsEnabled;
    if (notificationsBitfield != null && notificationsBitfield != _notificationsBitfield) _notificationsBitfield = notificationsBitfield;
    if (developerMode != null && developerMode != _developerMode) _developerMode = developerMode;
    if (notificationPollInterval != null && notificationPollInterval != _notificationPollInterval)
      _notificationPollInterval = notificationPollInterval;
    if (vibrate != null && vibrate != _vibrate) _vibrate = vibrate;
    if (vibrationStrength != null && vibrationStrength != _vibrationStrength) _vibrationStrength = vibrationStrength;
    if (ABweeks != null && ABweeks != _ABweeks) _ABweeks = ABweeks;
    if (swapABweeks != null && swapABweeks != _swapABweeks) _swapABweeks = swapABweeks;
    if (updateChannel != null && updateChannel != _updateChannel) _updateChannel = updateChannel;
    if (config != null && config != _config) _config = config;

    if (database == null) database = Provider.of<DatabaseProvider>(context, listen: false);
    await database.store.storeSettings(this);
    notifyListeners();
  }
}
