import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "empty": "Free period",
          "cancelled": "Cancelled",
          "substitution": "Substituted",
          "absence": "You were absent on this lesson",
          "exam": "Exam"
        },
        "hu_hu": {
          "empty": "Lyukasóra",
          "cancelled": "Elmarad",
          "substitution": "Helyettesítés",
          "absence": "Hiányoztál ezen az órán",
          "exam": "Dolgozat"
        },
        "de_de": {
          "empty": "Springstunde",
          "cancelled": "Abgesagte",
          "substitution": "Vertretene",
          "absence": "Sie waren in dieser Lektion nicht anwesend",
          "exam": "Prüfung"
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
