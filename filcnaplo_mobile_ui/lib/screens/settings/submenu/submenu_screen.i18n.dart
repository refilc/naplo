import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "general": "General",
          "personalization": "Personalization",
          "extras": "Extras",
          "surprise_grades": "Surprise Grades",
          "cancel": "Cancel",
          "done": "Done",
          "rarity_title": "Rarity Text",
          // default rarities
          "common": "Common",
          "uncommon": "Uncommon",
          "rare": "Rare",
          "epic": "Epic",
          "legendary": "Legendary",
        },
        "hu_hu": {
          "general": "Általános",
          "personalization": "Személyre szabás",
          "extras": "Extrák",
          "surprise_grades": "Meglepetés jegyek",
          "cancel": "Mégse",
          "done": "Kész",
          "rarity_title": "Ritkaság szövege",
          // default rarities
          "common": "Gyakori",
          "uncommon": "Nem gyakori",
          "rare": "Ritka",
          "epic": "Epikus",
          "legendary": "Legendás",
        },
        "de_de": {
          "general": "Allgemeine",
          "personalization": "Personalisierung",
          "extras": "Extras",
          "surprise_grades": "Überraschende Noten",
          "cancel": "Abbrechen",
          "done": "Bereit",
          "rarity_title": "Text zur Seltenheit",
          // default rarities
          "common": "Gemeinsam",
          "uncommon": "Gelegentlich",
          "rare": "Selten",
          "epic": "Episch",
          "legendary": "Legendär",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
