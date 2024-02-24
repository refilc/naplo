import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Missing homework": "Missing homework",
          "Missing equipment": "Missing equipment",
        },
        "hu_hu": {
          "Missing homework": "Házi feladat hiány",
          "Missing equipment": "Felszerelés Hiány",
        },
        "de_de": {
          "Missing homework": "Fehlende Hausaufgaben",
          "Missing equipment": "Fehlende Ausrüstung",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
