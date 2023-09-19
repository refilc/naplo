import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Elégtelen": "Fail",
          "Elégséges": "Warning but passing",
          "Közepes": "Passed",
          "Jó": "Good",
          "Jeles": "Excellent"
        },
        "hu_hu": {
          "Elégtelen": "Elégtelen",
          "Elégséges": "Elégséges",
          "Közepes": "Közepes",
          "Jó": "Jó",
          "Jeles": "Jeles"
        },
        "de_de": {
          "Elégtelen": "Ungenügend",
          "Elégséges": "Mangelhaft",
          "Közepes": "Ausreichend",
          "Jó": "Befriedigend",
          "Jeles": "Gut"
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
