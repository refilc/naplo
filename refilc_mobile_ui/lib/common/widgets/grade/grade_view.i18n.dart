import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "value": "Value",
          "date": "Date",
          "description": "Description",
          "mode": "Type",
          "Nem írt": "Missed exam",
        },
        "hu_hu": {
          "value": "Érték",
          "date": "Írás ideje",
          "description": "Leírás",
          "mode": "Típus",
          "Nem írt": "Nem írta meg a dolgozatot"
        },
        "de_de": {
          "value": "Notenwert",
          "date": "Prüfungszeit",
          "description": "Bezeichnung",
          "mode": "Typ",
          "Nem írt": "Nicht geschrieben"
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
