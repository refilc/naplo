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
          // grade colors
          "grade_colors": "Grade Colors",
          // theme share popup
          "share_theme": "Share Paint",
          "paint_title": "Paint title...",
          "share_it": "Share it!",
          "is_public": "Public Paint",
          "attention": "Attention!",
          "share_disclaimer":
              "By sharing the theme, you agree that the nickname you set and all settings of the theme will be shared publicly.",
          "understand": "I understand",
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
          // grade colors
          "grade_colors": "Jegyek színei",
          // theme share popup
          "share_theme": "Téma megosztása",
          "paint_title": "Téma neve...",
          "share_it": "Megosztás!",
          "is_public": "Nyilvános téma",
          "attention": "Figyelem!",
          "share_disclaimer":
              "A téma megosztásával elfogadod, hogy az általad beállított becenév és a téma minden beállítása nyilvánosan megosztásra kerüljön.",
          "understand": "Értem",
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
          // grade colors
          "grade_colors": "Notenfarben",
          // theme share popup
          "share_theme": "Thema teilen",
          "paint_title": "Thema Titel...",
          "share_it": "Teilen!",
          "is_public": "Öffentliches Thema",
          "attention": "Achtung!",
          "share_disclaimer":
              "Durch das Teilen des Themes erklären Sie sich damit einverstanden, dass der von Ihnen festgelegte Spitzname und alle Einstellungen des Themes öffentlich geteilt werden.",
          "understand": "Ich verstehe",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
