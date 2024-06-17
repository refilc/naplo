import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "new": "NEW",
          "beta": "BETA",
        },
        "hu_hu": {
          "new": "ÚJ",
          "beta": "BÉTA",
        },
        "de_de": {
          "new": "NEU",
          "beta": "BETA",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
