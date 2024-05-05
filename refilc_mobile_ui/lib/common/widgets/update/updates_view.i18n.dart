import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "new_update": "New Update",
          "download": "download",
          "downloading": "downloading",
          "installing": "installing",
          "error": "Failed to install update!",
          "no": "No",
          "yes": "Yes",
          "mobileAlertTitle": "Hold up!",
          "mobileAlertDesc": "You're on mobile network trying to download a %s update. Are you sure you want to continue?"
        },
        "hu_hu": {
          "new_update": "Új frissítés",
          "download": "Letöltés",
          "downloading": "Letöltés",
          "installing": "Telepítés",
          "error": "Nem sikerült telepíteni a frissítést!",
          "no": "Nem",
          "yes": "Igen",
          "mobileAlertTitle": "Figyelem!",
          "mobileAlertDesc": "Jelenleg mobil interneten vagy, és egy %s méretű frissítést próbálsz letölteni. Biztosan folytatod?"
        },
        "de_de": {
          "new_update": "Neues Update",
          "download": "herunterladen",
          "downloading": "Herunterladen",
          "installing": "Installation",
          "error": "Update konnte nicht installiert werden!",
          "no": "Nein",
          "yes": "Ja",
          "mobileAlertTitle": "Achtung!",
          "mobileAlertDesc":
              "Sie befinden sich gerade im mobilen Internet und versuchen, ein %s Update herunterzuladen. Sind Sie sicher, dass Sie weitermachen wollen?"
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
