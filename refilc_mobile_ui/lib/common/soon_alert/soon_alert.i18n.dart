import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "soon": "Soon...",
          "soon_body": "This feature is currently not available yet!",
        },
        "hu_hu": {
          "soon": "Hamarosan...",
          "soon_body": "Ez a funkció jelenleg még nem elérhető!",
        },
        "de_de": {
          "soon": "Bald...",
          "soon_body": "Diese Funktion ist derzeit noch nicht verfügbar!",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
