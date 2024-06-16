import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "birthdate": "Birth date",
          "school": "School",
          "class": "Class",
          "address": "Home address",
          "parents": "Parent(s)",
          "parents_phone": "Parents' phone number: ",
        },
        "hu_hu": {
          "birthdate": "Születési dátum",
          "school": "Iskola",
          "class": "Osztály",
          "address": "Lakcím",
          "parents": "Szülő(k)",
        },
        "de_de": {
          "birthdate": "Geburtsdatum",
          "school": "Schule",
          "class": "Klasse",
          "address": "Wohnanschrift",
          "parents": "Elter(n)",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
