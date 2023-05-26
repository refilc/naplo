import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Today": "Today",
          "Yesterday": "Yesterday",
          "Tomorrow": "Tomorrow",
        },
        "hu_hu": {
          "Today": "Ma",
          "Yesterday": "Tegnap",
          "Tomorrow": "Holnap",
        },
        "de_de": {
          "Today": "Heute",
          "Yesterday": "Gestern",
          "Tomorrow": "Morgen",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
