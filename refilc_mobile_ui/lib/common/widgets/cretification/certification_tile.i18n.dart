import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "final": "Final",
          "mid": "Mid year",
          "1q": "1. Quarter",
          "2q": "2. Quarter",
          "3q": "3. Quarter",
          "4q": "4. Quarter",
          "equivalency": "Equivalency test",
          "unknown": "Unknown",
          "classavg": "Class Average",
        },
        "hu_hu": {
          "final": "Év vége",
          "mid": "Félév",
          "1q": "1. Negyedév",
          "2q": "2. Negyedév",
          "3q": "3. Negyedév",
          "4q": "4. Negyedév",
          "equivalency": "Osztályozó",
          "unknown": "Ismeretlen",
          "classavg": "Osztályátlag",
        },
        "de_de": {
          "final": "Zeugnis",
          "mid": "Halbjährlich",
          "1q": "1. Quartal",
          "2q": "2. Quartal",
          "3q": "3. Quartal",
          "4q": "4. Quartal",
          "equivalency": "Zulassungsprüfung",
          "unknown": "Unbekannt",
          "classavg": "Klassendurchschnitt",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
