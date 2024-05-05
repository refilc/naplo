import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Failed to open attachment": "Failed to open attachment",
        },
        "hu_hu": {
          "Failed to open attachment": "Nem sikerült megnyitni a mellékletet",
        },
        "de_de": {
          "Failed to open attachment": "Anhang konnte nicht geöffnet werden",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
