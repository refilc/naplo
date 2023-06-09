import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "title": "New grade",
          "body": "You got a %s in %s"
        },
        "hu_hu": {
          "title": "Új jegy",
          "body": "%s-st kaptál %s tantárgyból"
        },
        "de_de": {
          "title": "Neue Note",
          "body": "Du hast eine %s in %s"
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
