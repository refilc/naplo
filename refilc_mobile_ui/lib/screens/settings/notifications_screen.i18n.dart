import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "notifications_screen": "Notifications",
          "grades": "Grades",
          "absences": "Absences",
          "messages": "Messages",
          "lessons": "Lessons",
          "set_all_as_unseen": "Set all as unseen",
          
        },
        "hu_hu": {
          "notifications_screen": "Értesítések",
          "grades": "Jegyek",
          "absences": "Hiányzások",
          "messages": "Üzenetek",
          "lessons": "Órák",
          "set_all_as_unseen": "Összes kategória beállítása olvasatlannak",
        },
        "de_de": {
          "notifications_screen": "Mitteilung",
          "grades": "Noten",
          "absences": "Fehlen",
          "messages": "Nachrichten",
          "lessons": "Unterricht",
          "set_all_as_unseen": "Alle als ungelesen einstellen",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
