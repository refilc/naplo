import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Room": "Room",
          "Description": "Description",
          "Lesson Number": "Lesson Number",
          "Group": "Group",
        },
        "hu_hu": {
          "Room": "Terem",
          "Description": "Leírás",
          "Lesson Number": "Éves óraszám",
          "Group": "Csoport",
        },
        "de_de": {
          "Room": "Raum",
          "Description": "Bezeichnung",
          "Lesson Number": "Ordinalzahl",
          "Group": "Gruppe",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
