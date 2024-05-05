import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "date": "Date",
          "description": "Description",
          "mode": "Type",
        },
        "hu_hu": {
          "date": "Írás ideje",
          "description": "Leírás",
          "mode": "Típus",
        },
        "de_de": {
          "date": "Prüfungszeit",
          "description": "Bezeichnung",
          "mode": "Typ",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
