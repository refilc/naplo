import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "not_enough_grades": "Not enough data to show a graph here.",
        },
        "hu_hu": {
          "not_enough_grades": "Nem szereztél még elég jegyet grafikon mutatáshoz.",
        },
        "de_de": {
          "not_enough_grades": "Noch nicht genug Noten, um die Grafik zu zeigen.",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
