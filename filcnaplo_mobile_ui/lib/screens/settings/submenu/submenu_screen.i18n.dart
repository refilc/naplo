import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "general": "General",
          "personalization": "Personalization",
          "extras": "Extras",
        },
        "hu_hu": {
          "general": "Általános",
          "personalization": "Személyre szabás",
          "extras": "Extrák",
        },
        "de_de": {
          "general": "Allgemeine",
          "personalization": "Personalisierung",
          "extras": "Extras",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
