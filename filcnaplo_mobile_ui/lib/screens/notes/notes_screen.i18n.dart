import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "notes": "Notes",
          "empty": "You don't have any notes",
          "todo": "Tasks",
          "homework": "Homework",
        },
        "hu_hu": {
          "notes": "Füzet",
          "empty": "Nincsenek jegyzeteid",
          "todo": "Feladatok",
          "homework": "Házi feladat",
        },
        "de_de": {
          "notes": "Broschüre",
          "empty": "Sie haben keine Notizen",
          "todo": "Aufgaben",
          "homework": "Hausaufgaben",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
