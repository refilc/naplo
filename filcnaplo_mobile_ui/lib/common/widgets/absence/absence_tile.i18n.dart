import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "excused": "excused %s",
          "pending": "%s to be excused",
          "unexcused": "unexcused %s",
          "absence": "absence",
          "delay": "delay",
          "minute": " minutes of ".one(" minute of "),
        },
        "hu_hu": {
          "excused": "igazolt %s",
          "pending": "igazolandó %s",
          "unexcused": "igazolatlan %s",
          "absence": "hiányzás",
          "delay": "késés",
          "minute": " perc ",
        },
        "de_de": {
          "excused": "anerkannt %s",
          "pending": "%s zu anerkennen",
          "unexcused": "unanerkannt %s",
          "absence": "Abwesenheit",
          "delay": "Verspätung",
          "minute": " Minuten ".one(" Minute "),
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
