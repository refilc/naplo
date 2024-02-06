import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "general": "General",
          "personalization": "Personalization",
          "extras": "Extras",
          "surprise_grades": "Surprise Grades",
        },
        "hu_hu": {
          "general": "Általános",
          "personalization": "Személyre szabás",
          "extras": "Extrák",
          "surprise_grades": "Meglepetés jegyek",
        },
        "de_de": {
          "general": "Allgemeine",
          "personalization": "Personalisierung",
          "extras": "Extras",
          "surprise_grades": "Überraschende Noten",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
