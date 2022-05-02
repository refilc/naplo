import 'dart:convert';
import 'dart:developer';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/config.dart';
import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum Pages { home, grades, timetable, messages, absences }

enum UpdateChannel { stable, beta, dev }

enum VibrationStrength { off, light, medium, strong }

class SettingsProvider extends ChangeNotifier {
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
  VibrationStrength _vibrate;
  bool _abWeeks;
  bool _swapABweeks;
  UpdateChannel _updateChannel;
  Config _config;
  String _xFilcId;
  bool _graphClassAvg;
  bool _goodStudent;
  bool _presentationMode;
  bool _bellDelayEnabled;
  int _bellDelay;

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
    required VibrationStrength vibrate,
    required bool abWeeks,
    required bool swapABweeks,
    required UpdateChannel updateChannel,
    required Config config,
    required String xFilcId,
    required bool graphClassAvg,
    required bool goodStudent,
    required bool presentationMode,
    required bool bellDelayEnabled,
    required int bellDelay,
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
        _abWeeks = abWeeks,
        _swapABweeks = swapABweeks,
        _updateChannel = updateChannel,
        _config = config,
        _xFilcId = xFilcId,
        _graphClassAvg = graphClassAvg,
        _goodStudent = goodStudent,
        _presentationMode = presentationMode,
        _bellDelayEnabled = bellDelayEnabled,
        _bellDelay = bellDelay;

  factory SettingsProvider.fromMap(Map map) {
    Map<String, Object?>? configMap;

    try {
      configMap = jsonDecode(map["config"] ?? "{}");
    } catch (e) {
      log("[ERROR] SettingsProvider.fromMap: $e");
    }

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
      newsEnabled: map["news"] == 1,
      newsState: map["news_state"],
      notificationsEnabled: map["notifications"] == 1,
      notificationsBitfield: map["notifications_bitfield"],
      notificationPollInterval: map["notification_poll_interval"],
      developerMode: map["developer_mode"] == 1,
      vibrate: VibrationStrength.values[map["vibration_strength"]],
      abWeeks: map["ab_weeks"] == 1,
      swapABweeks: map["swap_ab_weeks"] == 1,
      updateChannel: UpdateChannel.values[map["update_channel"]],
      config: Config.fromJson(configMap ?? {}),
      xFilcId: map["x_filc_id"],
      graphClassAvg: map["graph_class_avg"] == 1,
      goodStudent: false,
      presentationMode: map["presentation_mode"] == 1,
      bellDelayEnabled: map["bell_delay_enabled"] == 1,
      bellDelay: map["bell_delay"],
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
      "vibration_strength": _vibrate.index,
      "ab_weeks": _abWeeks ? 1 : 0,
      "swap_ab_weeks": _swapABweeks ? 1 : 0,
      "notification_poll_interval": _notificationPollInterval,
      "config": jsonEncode(config.json),
      "x_filc_id": _xFilcId,
      "graph_class_avg": _graphClassAvg ? 1 : 0,
      "presentation_mode": _presentationMode ? 1 : 0,
      "bell_delay_enabled": _bellDelayEnabled ? 1 : 0,
      "bell_delay": _bellDelay,
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
      vibrate: VibrationStrength.medium,
      abWeeks: false,
      swapABweeks: false,
      updateChannel: UpdateChannel.stable,
      config: Config.fromJson({}),
      xFilcId: const Uuid().v4(),
      graphClassAvg: false,
      goodStudent: false,
      presentationMode: false,
      bellDelayEnabled: false,
      bellDelay: 0,
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
  VibrationStrength get vibrate => _vibrate;
  bool get abWeeks => _abWeeks;
  bool get swapABweeks => _swapABweeks;
  UpdateChannel get updateChannel => _updateChannel;
  Config get config => _config;
  String get xFilcId => _xFilcId;
  bool get graphClassAvg => _graphClassAvg;
  bool get goodStudent => _goodStudent;
  bool get presentationMode => _presentationMode;
  bool get bellDelayEnabled => _bellDelayEnabled;
  int get bellDelay => _bellDelay;

  Future<void> update(
    BuildContext context, {
    DatabaseProvider? database,
    bool store = true,
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
    VibrationStrength? vibrate,
    bool? abWeeks,
    bool? swapABweeks,
    UpdateChannel? updateChannel,
    Config? config,
    String? xFilcId,
    bool? graphClassAvg,
    bool? goodStudent,
    bool? presentationMode,
    bool? bellDelayEnabled,
    int? bellDelay,
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
    if (notificationPollInterval != null && notificationPollInterval != _notificationPollInterval) {
      _notificationPollInterval = notificationPollInterval;
    }
    if (vibrate != null && vibrate != _vibrate) _vibrate = vibrate;
    if (abWeeks != null && abWeeks != _abWeeks) _abWeeks = abWeeks;
    if (swapABweeks != null && swapABweeks != _swapABweeks) _swapABweeks = swapABweeks;
    if (updateChannel != null && updateChannel != _updateChannel) _updateChannel = updateChannel;
    if (config != null && config != _config) _config = config;
    if (xFilcId != null && xFilcId != _xFilcId) _xFilcId = xFilcId;
    if (graphClassAvg != null && graphClassAvg != _graphClassAvg) _graphClassAvg = graphClassAvg;
    if (goodStudent != null) _goodStudent = goodStudent;
    if (presentationMode != null && presentationMode != _presentationMode) _presentationMode = presentationMode;
    if (bellDelay != null && bellDelay != _bellDelay) _bellDelay = bellDelay;
    if (bellDelayEnabled != null && bellDelayEnabled != _bellDelayEnabled) _bellDelayEnabled = bellDelayEnabled;

    database ??= Provider.of<DatabaseProvider>(context, listen: false);
    if (store) await database.store.storeSettings(this);
    notifyListeners();
  }
}
