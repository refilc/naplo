import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "theme_prev": "Preview",
          "colorpicker_presets": "Presets",
          "colorpicker_background": "Background",
          "colorpicker_panels": "Panels",
          "colorpicker_accent": "Accent",
          "colorpicker_icon": "Icon",
          "need_sub": "You need Kupak subscription to use modify this.",
          "advanced": "Advanced",
          "enter_id": "Enter ID",
          "theme_id": "Theme ID...",
          "theme_not_found": "Theme not found!",
          "attention": "Attention!",
          "share_disclaimer":
              "By sharing the theme, you agree that the nickname you set and all settings of the theme will be shared publicly.",
          "understand": "I understand",
          "share_subj_theme": "Share Theme",
        },
        "hu_hu": {
          "theme_prev": "Előnézet",
          "colorpicker_presets": "Téma",
          "colorpicker_background": "Háttér",
          "colorpicker_panels": "Panelek",
          "colorpicker_accent": "Színtónus",
          "colorpicker_icon": "Ikon",
          "need_sub": "A módosításhoz Kupak szintű támogatás szükséges.",
          "advanced": "Haladó",
          "enter_id": "ID megadása",
          "theme_id": "Téma azonosító...",
          "theme_not_found": "A téma nem található!",
          "attention": "Figyelem!",
          "share_disclaimer":
              "A téma megosztásával elfogadod, hogy az általad beállított becenév és a téma minden beállítása nyilvánosan megosztásra kerüljön.",
          "understand": "Értem",
          "share_subj_theme": "Téma Megosztás",
        },
        "de_de": {
          "theme_prev": "Vorschau",
          "colorpicker_presets": "Farben",
          "colorpicker_background": "Hintergrund",
          "colorpicker_panels": "Tafeln",
          "colorpicker_accent": "Akzent",
          "colorpicker_icon": "Ikone",
          "need_sub":
              "Sie benötigen ein Kupak-Abonnement, um diese Funktion zu ändern.",
          "advanced": "Fortschrittlich",
          "enter_id": "Geben Sie die ID ein",
          "theme_id": "Themen-ID...",
          "theme_not_found": "Thema nicht gefunden!",
          "attention": "Achtung!",
          "share_disclaimer":
              "Durch das Teilen des Themes erklären Sie sich damit einverstanden, dass der von Ihnen festgelegte Spitzname und alle Einstellungen des Themes öffentlich geteilt werden.",
          "understand": "Ich verstehe",
          "share_subj_theme": "Thema Teilen",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
