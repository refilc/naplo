import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "home": "Home",
          "grades": "Grades",
          "timetable": "Timetable",
          "messages": "Messages",
          "absences": "Absences",
        },
        "hu_hu": {
          "home": "Kezdőlap",
          "grades": "Jegyek",
          "timetable": "Órarend",
          "messages": "Üzenetek",
          "absences": "Hiányok",
        },
        "de_de": {
          "home": "Zuhause",
          "grades": "Noten",
          "timetable": "Zeitplan",
          "messages": "Mitteilungen",
          "absences": "Fehlen",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
