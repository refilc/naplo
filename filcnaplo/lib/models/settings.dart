import 'dart:convert';
import 'dart:developer';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/config.dart';
import 'package:filcnaplo/models/icon_pack.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo/theme/colors/dark_mobile.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum Pages { home, grades, timetable, messages, absences }

enum UpdateChannel { stable, beta, dev }

enum VibrationStrength { off, light, medium, strong }

class SettingsProvider extends ChangeNotifier {
  final DatabaseProvider? _database;

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
  String _seenNews;
  bool _notificationsEnabled;
  bool _notificationsGradesEnabled;
  bool _notificationsAbsencesEnabled;
  bool _notificationsMessagesEnabled;
  bool _notificationsLessonsEnabled;
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
  bool _gradeOpeningFun;
  IconPack _iconPack;
  Color _customAccentColor;
  Color _customBackgroundColor;
  Color _customHighlightColor;
  Color _customIconColor;
  bool _shadowEffect;
  List<String> _premiumScopes;
  String _premiumAccessToken;
  String _premiumLogin;
  String _lastAccountId;
  bool _renamedSubjectsEnabled;
  bool _renamedSubjectsItalics;
  bool _renamedTeachersEnabled;
  bool _renamedTeachersItalics;
  Color _liveActivityColor;
  String _welcomeMessage;

  SettingsProvider({
    DatabaseProvider? database,
    required String language,
    required Pages startPage,
    required int rounding,
    required ThemeMode theme,
    required AccentColor accentColor,
    required List<Color> gradeColors,
    required bool newsEnabled,
    required String seenNews,
    required bool notificationsEnabled,
    required bool notificationsGradesEnabled,
    required bool notificationsAbsencesEnabled,
    required bool notificationsMessagesEnabled,
    required bool notificationsLessonsEnabled,
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
    required bool gradeOpeningFun,
    required IconPack iconPack,
    required Color customAccentColor,
    required Color customBackgroundColor,
    required Color customHighlightColor,
    required Color customIconColor,
    required bool shadowEffect,
    required List<String> premiumScopes,
    required String premiumAccessToken,
    required String premiumLogin,
    required String lastAccountId,
    required bool renameSubjectsEnabled,
    required bool renameSubjectsItalics,
    required bool renameTeachersEnabled,
    required bool renameTeachersItalics,
    required Color liveActivityColor,
    required String welcomeMessage,
  })  : _database = database,
        _language = language,
        _startPage = startPage,
        _rounding = rounding,
        _theme = theme,
        _accentColor = accentColor,
        _gradeColors = gradeColors,
        _newsEnabled = newsEnabled,
        _seenNews = seenNews,
        _notificationsEnabled = notificationsEnabled,
        _notificationsGradesEnabled = notificationsGradesEnabled,
        _notificationsAbsencesEnabled = notificationsAbsencesEnabled,
        _notificationsMessagesEnabled = notificationsMessagesEnabled,
        _notificationsLessonsEnabled = notificationsLessonsEnabled,
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
        _bellDelay = bellDelay,
        _gradeOpeningFun = gradeOpeningFun,
        _iconPack = iconPack,
        _customAccentColor = customAccentColor,
        _customBackgroundColor = customBackgroundColor,
        _customHighlightColor = customHighlightColor,
        _customIconColor = customIconColor,
        _shadowEffect = shadowEffect,
        _premiumScopes = premiumScopes,
        _premiumAccessToken = premiumAccessToken,
        _premiumLogin = premiumLogin,
        _lastAccountId = lastAccountId,
        _renamedSubjectsEnabled = renameSubjectsEnabled,
        _renamedSubjectsItalics = renameSubjectsItalics,
        _renamedTeachersEnabled = renameTeachersEnabled,
        _renamedTeachersItalics = renameTeachersItalics,
        _liveActivityColor = liveActivityColor,
        _welcomeMessage = welcomeMessage;

  factory SettingsProvider.fromMap(Map map,
      {required DatabaseProvider database}) {
    Map<String, Object?>? configMap;

    try {
      configMap = jsonDecode(map["config"] ?? "{}");
    } catch (e) {
      log("[ERROR] SettingsProvider.fromMap: $e");
    }

    return SettingsProvider(
      database: database,
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
      seenNews: map["seen_news"],
      notificationsEnabled: map["notifications"] == 1,
      notificationsGradesEnabled: map["notifications_grades"] == 1,
      notificationsAbsencesEnabled: map["notifications_absences"] == 1,
      notificationsMessagesEnabled: map["notifications_messages"] == 1,
      notificationsLessonsEnabled: map["notifications_lessons"] == 1,
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
      gradeOpeningFun: map["grade_opening_fun"] == 1,
      iconPack: Map.fromEntries(
          IconPack.values.map((e) => MapEntry(e.name, e)))[map["icon_pack"]]!,
      customAccentColor: Color(map["custom_accent_color"]),
      customBackgroundColor: Color(map["custom_background_color"]),
      customHighlightColor: Color(map["custom_highlight_color"]),
      customIconColor: Color(map["custom_icon_color"]),
      shadowEffect: map["shadow_effect"] == 1,
      premiumScopes: jsonDecode(map["premium_scopes"]).cast<String>(),
      premiumAccessToken: map["premium_token"],
      premiumLogin: map["premium_login"],
      lastAccountId: map["last_account_id"],
      renameSubjectsEnabled: map["renamed_subjects_enabled"] == 1,
      renameSubjectsItalics: map["renamed_subjects_italics"] == 1,
      renameTeachersEnabled: map["renamed_teachers_enabled"] == 1,
      renameTeachersItalics: map["renamed_teachers_italics"] == 1,
      liveActivityColor: Color(map["live_activity_color"]),
      welcomeMessage: map["welcome_message"],
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
      "seen_news": _seenNews,
      "notifications": _notificationsEnabled ? 1 : 0,
      "notifications_grades": _notificationsGradesEnabled ? 1 : 0,
      "notifications_absences": _notificationsAbsencesEnabled ? 1 : 0,
      "notifications_messages": _notificationsMessagesEnabled ? 1 : 0,
      "notifications_lessons": _notificationsLessonsEnabled ? 1 : 0,
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
      "grade_opening_fun": _gradeOpeningFun ? 1 : 0,
      "icon_pack": _iconPack.name,
      "custom_accent_color": _customAccentColor.value,
      "custom_background_color": _customBackgroundColor.value,
      "custom_highlight_color": _customHighlightColor.value,
      "custom_icon_color": _customIconColor.value,
      "shadow_effect": _shadowEffect ? 1 : 0,
      "premium_scopes": jsonEncode(_premiumScopes),
      "premium_token": _premiumAccessToken,
      "premium_login": _premiumLogin,
      "last_account_id": _lastAccountId,
      "renamed_subjects_enabled": _renamedSubjectsEnabled ? 1 : 0,
      "renamed_subjects_italics": _renamedSubjectsItalics ? 1 : 0,
      "renamed_teachers_enabled": _renamedTeachersEnabled ? 1 : 0,
      "renamed_teachers_italics": _renamedTeachersItalics ? 1 : 0,
      "live_activity_color": _liveActivityColor.value,
      "welcome_message": _welcomeMessage,
    };
  }

  factory SettingsProvider.defaultSettings({DatabaseProvider? database}) {
    return SettingsProvider(
      database: database,
      language: "hu",
      startPage: Pages.home,
      rounding: 5,
      theme: ThemeMode.system,
      accentColor: AccentColor.filc,
      gradeColors: [
        DarkMobileAppColors().gradeOne,
        DarkMobileAppColors().gradeTwo,
        DarkMobileAppColors().gradeThree,
        DarkMobileAppColors().gradeFour,
        DarkMobileAppColors().gradeFive,
      ],
      newsEnabled: true,
      seenNews: '',
      notificationsEnabled: true,
      notificationsGradesEnabled: true,
      notificationsAbsencesEnabled: true,
      notificationsMessagesEnabled: true,
      notificationsLessonsEnabled: true,
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
      gradeOpeningFun: true,
      iconPack: IconPack.cupertino,
      customAccentColor: const Color(0xff3D7BF4),
      customBackgroundColor: const Color(0xff000000),
      customHighlightColor: const Color(0xff222222),
      customIconColor: const Color(0x00000000),
      shadowEffect: true,
      premiumScopes: [PremiumScopes.all],
      premiumAccessToken: "igen",
      premiumLogin: "igen",
      lastAccountId: "",
      renameSubjectsEnabled: false,
      renameSubjectsItalics: false,
      renameTeachersEnabled: false,
      renameTeachersItalics: false,
      liveActivityColor: const Color(0xFF676767),
      welcomeMessage: '',
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
  List<String> get seenNews => _seenNews.split(',');
  bool get notificationsEnabled => _notificationsEnabled;
  bool get notificationsGradesEnabled => _notificationsGradesEnabled;
  bool get notificationsAbsencesEnabled => _notificationsAbsencesEnabled;
  bool get notificationsMessagesEnabled => _notificationsMessagesEnabled;
  bool get notificationsLessonsEnabled => _notificationsLessonsEnabled;
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
  bool get gradeOpeningFun => _gradeOpeningFun;
  IconPack get iconPack => _iconPack;
  Color? get customAccentColor =>
      _customAccentColor == accentColorMap[AccentColor.custom]
          ? null
          : _customAccentColor;
  Color? get customBackgroundColor => _customBackgroundColor;
  Color? get customHighlightColor => _customHighlightColor;
  Color? get customIconColor => _customIconColor;
  bool get shadowEffect => _shadowEffect;
  List<String> get premiumScopes => _premiumScopes;
  String get premiumAccessToken => _premiumAccessToken;
  String get premiumLogin => _premiumLogin;
  String get lastAccountId => _lastAccountId;
  bool get renamedSubjectsEnabled => _renamedSubjectsEnabled;
  bool get renamedSubjectsItalics => _renamedSubjectsItalics;
  bool get renamedTeachersEnabled => _renamedTeachersEnabled;
  bool get renamedTeachersItalics => _renamedTeachersItalics;
  Color get liveActivityColor => _liveActivityColor;
  String get welcomeMessage => _welcomeMessage;

  Future<void> update({
    bool store = true,
    String? language,
    Pages? startPage,
    int? rounding,
    ThemeMode? theme,
    AccentColor? accentColor,
    List<Color>? gradeColors,
    bool? newsEnabled,
    String? seenNewsId,
    bool? notificationsEnabled,
    bool? notificationsGradesEnabled,
    bool? notificationsAbsencesEnabled,
    bool? notificationsMessagesEnabled,
    bool? notificationsLessonsEnabled,
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
    bool? gradeOpeningFun,
    IconPack? iconPack,
    Color? customAccentColor,
    Color? customBackgroundColor,
    Color? customHighlightColor,
    Color? customIconColor,
    bool? shadowEffect,
    List<String>? premiumScopes,
    String? premiumAccessToken,
    String? premiumLogin,
    String? lastAccountId,
    bool? renamedSubjectsEnabled,
    bool? renamedSubjectsItalics,
    bool? renamedTeachersEnabled,
    bool? renamedTeachersItalics,
    Color? liveActivityColor,
    String? welcomeMessage,
  }) async {
    if (language != null && language != _language) _language = language;
    if (startPage != null && startPage != _startPage) _startPage = startPage;
    if (rounding != null && rounding != _rounding) _rounding = rounding;
    if (theme != null && theme != _theme) _theme = theme;
    if (accentColor != null && accentColor != _accentColor) {
      _accentColor = accentColor;
    }
    if (gradeColors != null && gradeColors != _gradeColors) {
      _gradeColors = gradeColors;
    }
    if (newsEnabled != null && newsEnabled != _newsEnabled) {
      _newsEnabled = newsEnabled;
    }
    if (seenNewsId != null && !_seenNews.split(',').contains(seenNewsId)) {
      var tempList = _seenNews.split(',');
      tempList.add(seenNewsId);
      _seenNews = tempList.join(',');
    }
    if (notificationsEnabled != null &&
        notificationsEnabled != _notificationsEnabled) {
      _notificationsEnabled = notificationsEnabled;
    }
    if (notificationsGradesEnabled != null &&
        notificationsGradesEnabled != _notificationsGradesEnabled) {
      _notificationsGradesEnabled = notificationsGradesEnabled;
    }
    if (notificationsAbsencesEnabled != null &&
        notificationsAbsencesEnabled != _notificationsAbsencesEnabled) {
      _notificationsAbsencesEnabled = notificationsAbsencesEnabled;
    }
    if (notificationsMessagesEnabled != null &&
        notificationsMessagesEnabled != _notificationsMessagesEnabled) {
      _notificationsMessagesEnabled = notificationsMessagesEnabled;
    }
    if (notificationsLessonsEnabled != null &&
        notificationsLessonsEnabled != _notificationsLessonsEnabled) {
      _notificationsLessonsEnabled = notificationsLessonsEnabled;
    }
    if (notificationsBitfield != null &&
        notificationsBitfield != _notificationsBitfield) {
      _notificationsBitfield = notificationsBitfield;
    }
    if (developerMode != null && developerMode != _developerMode) {
      _developerMode = developerMode;
    }
    if (notificationPollInterval != null &&
        notificationPollInterval != _notificationPollInterval) {
      _notificationPollInterval = notificationPollInterval;
    }
    if (vibrate != null && vibrate != _vibrate) _vibrate = vibrate;
    if (abWeeks != null && abWeeks != _abWeeks) _abWeeks = abWeeks;
    if (swapABweeks != null && swapABweeks != _swapABweeks) {
      _swapABweeks = swapABweeks;
    }
    if (updateChannel != null && updateChannel != _updateChannel) {
      _updateChannel = updateChannel;
    }
    if (config != null && config != _config) _config = config;
    if (xFilcId != null && xFilcId != _xFilcId) _xFilcId = xFilcId;
    if (graphClassAvg != null && graphClassAvg != _graphClassAvg) {
      _graphClassAvg = graphClassAvg;
    }
    if (goodStudent != null) _goodStudent = goodStudent;
    if (presentationMode != null && presentationMode != _presentationMode) {
      _presentationMode = presentationMode;
    }
    if (bellDelay != null && bellDelay != _bellDelay) _bellDelay = bellDelay;
    if (bellDelayEnabled != null && bellDelayEnabled != _bellDelayEnabled) {
      _bellDelayEnabled = bellDelayEnabled;
    }
    if (gradeOpeningFun != null && gradeOpeningFun != _gradeOpeningFun) {
      _gradeOpeningFun = gradeOpeningFun;
    }
    if (iconPack != null && iconPack != _iconPack) _iconPack = iconPack;
    if (customAccentColor != null && customAccentColor != _customAccentColor) {
      _customAccentColor = customAccentColor;
    }
    if (customBackgroundColor != null &&
        customBackgroundColor != _customBackgroundColor) {
      _customBackgroundColor = customBackgroundColor;
    }
    if (customHighlightColor != null &&
        customHighlightColor != _customHighlightColor) {
      _customHighlightColor = customHighlightColor;
    }
    if (customIconColor != null && customIconColor != _customIconColor) {
      _customIconColor = customIconColor;
    }
    if (shadowEffect != null && shadowEffect != _shadowEffect) {
      _shadowEffect = shadowEffect;
    }
    if (premiumScopes != null && premiumScopes != _premiumScopes) {
      _premiumScopes = premiumScopes;
    }
    if (premiumAccessToken != null &&
        premiumAccessToken != _premiumAccessToken) {
      _premiumAccessToken = premiumAccessToken;
    }
    if (premiumLogin != null && premiumLogin != _premiumLogin) {
      _premiumLogin = premiumLogin;
    }
    if (lastAccountId != null && lastAccountId != _lastAccountId) {
      _lastAccountId = lastAccountId;
    }
    if (renamedSubjectsEnabled != null &&
        renamedSubjectsEnabled != _renamedSubjectsEnabled) {
      _renamedSubjectsEnabled = renamedSubjectsEnabled;
    }
    if (renamedSubjectsItalics != null &&
        renamedSubjectsItalics != _renamedSubjectsItalics) {
      _renamedSubjectsItalics = renamedSubjectsItalics;
    }
    if (renamedTeachersEnabled != null &&
        renamedTeachersEnabled != _renamedTeachersEnabled) {
      _renamedTeachersEnabled = renamedTeachersEnabled;
    }
    if (renamedTeachersItalics != null &&
        renamedTeachersItalics != _renamedTeachersItalics) {
      _renamedTeachersItalics = renamedTeachersItalics;
    }
    if (liveActivityColor != null && liveActivityColor != _liveActivityColor) {
      _liveActivityColor = liveActivityColor;
    }
    if (welcomeMessage != null && welcomeMessage != _welcomeMessage) {
      _welcomeMessage = welcomeMessage;
    }
    if (store) await _database?.store.storeSettings(this);
    notifyListeners();
  }
}
