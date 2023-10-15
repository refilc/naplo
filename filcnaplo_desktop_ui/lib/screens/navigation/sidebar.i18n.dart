import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Home": "Home",
          "Grades": "Grades",
          "Timetable": "Timetable",
          "Messages": "Messages",
          "Absences": "Absences",
          "Settings": "Settings",
          "adduser": "Add user",
          "logout": "Log out",
        },
        "hu_hu": {
          "Home": "Kezdőlap",
          "Grades": "Jegyek",
          "Timetable": "Órarend",
          "Messages": "Üzenetek",
          "Absences": "Hiányzások",
          "Settings": "Beállítások",
          "adduser": "Fiók hozzáadása",
          "logout": "Kilépés",
        },
        "de_de": {
          "Home": "Zuhause",
          "Grades": "Noten",
          "Timetable": "Zeitplan",
          "Messages": "Mitteilungen",
          "Absences": "Fehlen",
          "Settings": "Einstellungen",
          "adduser": "Benutzer hinzufügen",
          "logout": "Abmelden",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
