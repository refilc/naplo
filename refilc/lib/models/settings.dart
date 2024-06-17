import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/config.dart';
import 'package:refilc/models/icon_pack.dart';
import 'package:refilc/theme/colors/accent.dart';
import 'package:refilc/theme/colors/dark_mobile.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../api/providers/live_card_provider.dart';

enum Pages { home, grades, timetable, notes, absences }

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
  Color _customTextColor;
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
  String _appIcon;
  // current theme
  String _currentThemeId;
  String _currentThemeDisplayName;
  String _currentThemeCreator;
  // pinned settings
  String _pinSetGeneral;
  String _pinSetPersonalize;
  String _pinSetNotify;
  String _pinSetExtras;
  // more
  bool _showBreaks;
  String _fontFamily;
  bool _titleOnlyFont;
  String _plusSessionId;
  String _calSyncRoomLocation;
  bool _calSyncShowExams;
  bool _calSyncShowTeacher;
  bool _calSyncRenamed;
  String _calendarId;
  bool _navShadow;
  bool _newColors;
  bool _uwuMode;
  bool _newPopups;
  List<String> _unseenNewFeatures;
  // quick settings
  bool _qTimetableLessonNum;
  bool _qTimetableSubTiles;
  bool _qSubjectsSubTiles;

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
    required Color customTextColor,
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
    required String appIcon,
    required String currentThemeId,
    required String currentThemeDisplayName,
    required String currentThemeCreator,
    required bool showBreaks,
    required String pinSetGeneral,
    required String pinSetPersonalize,
    required String pinSetNotify,
    required String pinSetExtras,
    required String fontFamily,
    required bool titleOnlyFont,
    required String plusSessionId,
    required String calSyncRoomLocation,
    required bool calSyncShowExams,
    required bool calSyncShowTeacher,
    required bool calSyncRenamed,
    required String calendarId,
    required bool navShadow,
    required bool newColors,
    required bool uwuMode,
    required bool newPopups,
    required List<String> unseenNewFeatures,
    required bool qTimetableLessonNum,
    required bool qTimetableSubTiles,
    required bool qSubjectsSubTiles,
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
        _customTextColor = customTextColor,
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
        _welcomeMessage = welcomeMessage,
        _appIcon = appIcon,
        _currentThemeId = currentThemeId,
        _currentThemeDisplayName = currentThemeDisplayName,
        _currentThemeCreator = currentThemeCreator,
        _showBreaks = showBreaks,
        _pinSetGeneral = pinSetGeneral,
        _pinSetPersonalize = pinSetPersonalize,
        _pinSetNotify = pinSetNotify,
        _pinSetExtras = pinSetExtras,
        _fontFamily = fontFamily,
        _titleOnlyFont = titleOnlyFont,
        _plusSessionId = plusSessionId,
        _calSyncRoomLocation = calSyncRoomLocation,
        _calSyncShowExams = calSyncShowExams,
        _calSyncShowTeacher = calSyncShowTeacher,
        _calSyncRenamed = calSyncRenamed,
        _calendarId = calendarId,
        _navShadow = navShadow,
        _newColors = newColors,
        _uwuMode = uwuMode,
        _newPopups = newPopups,
        _unseenNewFeatures = unseenNewFeatures,
        _qTimetableLessonNum = qTimetableLessonNum,
        _qTimetableSubTiles = qTimetableSubTiles,
        _qSubjectsSubTiles = qSubjectsSubTiles;

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
      customTextColor: Color(map["custom_text_color"]),
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
      appIcon: map["app_icon"],
      currentThemeId: map['current_theme_id'],
      currentThemeDisplayName: map['current_theme_display_name'],
      currentThemeCreator: map['current_theme_creator'],
      showBreaks: map['show_breaks'] == 1,
      pinSetGeneral: map['general_s_pin'],
      pinSetPersonalize: map['personalize_s_pin'],
      pinSetNotify: map['notify_s_pin'],
      pinSetExtras: map['extras_s_pin'],
      fontFamily: map['font_family'],
      titleOnlyFont: map['title_only_font'] == 1,
      plusSessionId: map['plus_session_id'],
      calSyncRoomLocation: map['cal_sync_room_location'],
      calSyncShowExams: map['cal_sync_show_exams'] == 1,
      calSyncShowTeacher: map['cal_sync_show_teacher'] == 1,
      calSyncRenamed: map['cal_sync_renamed'] == 1,
      calendarId: map['calendar_id'],
      navShadow: map['nav_shadow'] == 1,
      newColors: map['new_colors'] == 1,
      uwuMode: map['uwu_mode'] == 1,
      newPopups: map['new_popups'] == 1,
      unseenNewFeatures: jsonDecode(map["unseen_new_features"]).cast<String>(),
      qTimetableLessonNum: map['q_timetable_lesson_num'] == 1,
      qTimetableSubTiles: map['q_timetable_sub_tiles'] == 1,
      qSubjectsSubTiles: map['q_subjects_sub_tiles'] == 1,
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
      "custom_text_color": _customTextColor.value,
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
      "app_icon": _appIcon,
      "current_theme_id": _currentThemeId,
      "current_theme_display_name": _currentThemeDisplayName,
      "current_theme_creator": _currentThemeCreator,
      "show_breaks": _showBreaks ? 1 : 0,
      "general_s_pin": _pinSetGeneral,
      "personalize_s_pin": _pinSetPersonalize,
      "notify_s_pin": _pinSetNotify,
      "extras_s_pin": _pinSetExtras,
      "font_family": _fontFamily,
      "title_only_font": _titleOnlyFont ? 1 : 0,
      "plus_session_id": _plusSessionId,
      "cal_sync_room_location": _calSyncRoomLocation,
      "cal_sync_show_exams": _calSyncShowExams ? 1 : 0,
      "cal_sync_show_teacher": _calSyncShowTeacher ? 1 : 0,
      "cal_sync_renamed": _calSyncRenamed ? 1 : 0,
      "calendar_id": _calendarId,
      "nav_shadow": _navShadow ? 1 : 0,
      "new_colors": _newColors ? 1 : 0,
      "uwu_mode": _uwuMode ? 1 : 0,
      "new_popups": _newPopups ? 1 : 0,
      "unseen_new_features": jsonEncode(_unseenNewFeatures),
      "q_timetable_lesson_num": _qTimetableLessonNum ? 1 : 0,
      "q_timetable_sub_tiles": _qTimetableSubTiles ? 1 : 0,
      "q_subjects_sub_tiles": _qSubjectsSubTiles ? 1 : 0,
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
      gradeOpeningFun: false,
      iconPack: IconPack.cupertino,
      customAccentColor: const Color(0xff3D7BF4),
      customBackgroundColor: const Color(0xff000000),
      customHighlightColor: const Color(0xff222222),
      customIconColor: const Color(0x00000000),
      customTextColor: const Color(0x00000000),
      shadowEffect: true,
      premiumScopes: [],
      premiumAccessToken: "",
      premiumLogin: "",
      lastAccountId: "",
      renameSubjectsEnabled: false,
      renameSubjectsItalics: false,
      renameTeachersEnabled: false,
      renameTeachersItalics: false,
      liveActivityColor: const Color(0xFF676767),
      welcomeMessage: '',
      appIcon: 'refilc_default',
      currentThemeId: '',
      currentThemeDisplayName: '',
      currentThemeCreator: 'reFilc',
      showBreaks: true,
      pinSetGeneral: '',
      pinSetPersonalize: '',
      pinSetNotify: '',
      pinSetExtras: '',
      fontFamily: '',
      titleOnlyFont: false,
      plusSessionId: '',
      calSyncRoomLocation: 'location',
      calSyncShowExams: true,
      calSyncShowTeacher: true,
      calSyncRenamed: false,
      calendarId: '',
      navShadow: true,
      newColors: true,
      uwuMode: false,
      newPopups: true,
      unseenNewFeatures: ['grade_exporting'],
      qTimetableLessonNum: true,
      qTimetableSubTiles: true,
      qSubjectsSubTiles: true,
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
  Color? get customTextColor => _customTextColor;
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
  String get appIcon => _appIcon;
  String get currentThemeId => _currentThemeId;
  String get currentThemeDisplayName => _currentThemeDisplayName;
  String get currentThemeCreator => _currentThemeCreator;
  bool get showBreaks => _showBreaks;
  String get fontFamily => _fontFamily;
  bool get titleOnlyFont => _titleOnlyFont;
  String get plusSessionId => _plusSessionId;
  String get calSyncRoomLocation => _calSyncRoomLocation;
  bool get calSyncShowExams => _calSyncShowExams;
  bool get calSyncShowTeacher => _calSyncShowTeacher;
  bool get calSyncRenamed => _calSyncRenamed;
  String get calendarId => _calendarId;
  bool get navShadow => _navShadow;
  bool get newColors => _newColors;
  bool get uwuMode => _uwuMode;
  bool get newPopups => _newPopups;
  List<String> get unseenNewFeatures => _unseenNewFeatures;
  bool get qTimetableLessonNum => _qTimetableLessonNum;
  bool get qTimetableSubTiles => _qTimetableSubTiles;
  bool get qSubjectsSubTiles => _qSubjectsSubTiles;

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
    Color? customTextColor,
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
    String? appIcon,
    String? currentThemeId,
    String? currentThemeDisplayName,
    String? currentThemeCreator,
    bool? showBreaks,
    String? fontFamily,
    bool? titleOnlyFont,
    String? plusSessionId,
    String? calSyncRoomLocation,
    bool? calSyncShowExams,
    bool? calSyncShowTeacher,
    bool? calSyncRenamed,
    String? calendarId,
    bool? navShadow,
    bool? newColors,
    bool? uwuMode,
    bool? newPopups,
    List<String>? unseenNewFeatures,
    bool? qTimetableLessonNum,
    bool? qTimetableSubTiles,
    bool? qSubjectsSubTiles,
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
      if (Platform.isIOS) {
        LiveCardProvider.hasActivitySettingsChanged = true;
      }
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
    if (customTextColor != null && customTextColor != _customTextColor) {
      _customTextColor = customTextColor;
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
    if (appIcon != null && appIcon != _appIcon) {
      _appIcon = appIcon;
    }
    if (currentThemeId != null && currentThemeId != _currentThemeId) {
      _currentThemeId = currentThemeId;
    }
    if (currentThemeDisplayName != null &&
        currentThemeDisplayName != _currentThemeDisplayName) {
      _currentThemeDisplayName = currentThemeDisplayName;
    }
    if (currentThemeCreator != null &&
        currentThemeCreator != _currentThemeCreator) {
      _currentThemeCreator = currentThemeCreator;
    }
    if (showBreaks != null && showBreaks != _showBreaks) {
      _showBreaks = showBreaks;
    }
    if (fontFamily != null && fontFamily != _fontFamily) {
      _fontFamily = fontFamily;
    }
    if (titleOnlyFont != null && titleOnlyFont != _titleOnlyFont) {
      _titleOnlyFont = titleOnlyFont;
    }
    if (plusSessionId != null && plusSessionId != _plusSessionId) {
      _plusSessionId = plusSessionId;
    }
    if (calSyncRoomLocation != null &&
        calSyncRoomLocation != _calSyncRoomLocation) {
      _calSyncRoomLocation = calSyncRoomLocation;
    }
    if (calSyncShowExams != null && calSyncShowExams != _calSyncShowExams) {
      _calSyncShowExams = calSyncShowExams;
    }
    if (calSyncShowTeacher != null &&
        calSyncShowTeacher != _calSyncShowTeacher) {
      _calSyncShowTeacher = calSyncShowTeacher;
    }
    if (calSyncRenamed != null && calSyncRenamed != _calSyncRenamed) {
      _calSyncRenamed = calSyncRenamed;
    }
    if (calendarId != null && calendarId != _calendarId) {
      _calendarId = calendarId;
    }
    if (navShadow != null && navShadow != _navShadow) {
      _navShadow = navShadow;
    }
    if (newColors != null && newColors != _newColors) {
      _newColors = newColors;
    }
    if (uwuMode != null && uwuMode != _uwuMode) {
      _uwuMode = uwuMode;
    }
    if (newPopups != null && newPopups != _newPopups) {
      _newPopups = newPopups;
    }
    if (unseenNewFeatures != null && unseenNewFeatures != _unseenNewFeatures) {
      _unseenNewFeatures = unseenNewFeatures;
    }
    if (qTimetableLessonNum != null &&
        qTimetableLessonNum != _qTimetableLessonNum) {
      _qTimetableLessonNum = qTimetableLessonNum;
    }
    if (qTimetableSubTiles != null &&
        qTimetableSubTiles != _qTimetableSubTiles) {
      _qTimetableSubTiles = qTimetableSubTiles;
    }
    if (qSubjectsSubTiles != null && qSubjectsSubTiles != _qSubjectsSubTiles) {
      _qSubjectsSubTiles = qSubjectsSubTiles;
    }
    // store or not
    if (store) await _database?.store.storeSettings(this);
    notifyListeners();
  }

  void exportJson() {
    String sets = json.encode(toMap());
    Clipboard.setData(ClipboardData(text: sets));
  }
}
