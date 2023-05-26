import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "common": "Common",
          "uncommon": "Uncommon",
          "rare": "Rare",
          "epic": "Epic",
          "legendary": "Legendary",
          "new_grades": "New grades",
          "tap_to_open": "Tap to open now!",
          "open_subtitle": "Tap to open...",
        },
        "hu_hu": {
          "common": "Gyakori",
          "uncommon": "Nem gyakori",
          "rare": "Ritka",
          "epic": "Epikus",
          "legendary": "Legendás",
          "new_grades": "Új jegyek",
          "tap_to_open": "Nyisd ki őket!",
          "open_subtitle": "Nyomd meg a kinyitáshoz...",
        },
        "de_de": {
          "common": "Gemeinsam",
          "uncommon": "Gelegentlich",
          "rare": "Selten",
          "epic": "Episch",
          "legendary": "Legendär",
          "new_grades": "Neue Noten",
          "tap_to_open": "Tippen, um jetzt zu öffnen!",
          "open_subtitle": "Antippen zum Öffnen...",
        }
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
