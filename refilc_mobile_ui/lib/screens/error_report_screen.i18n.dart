import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "ekretaYou": "e-KRÉTA, you",
          "description": "An error occurred!",
          "submit": "Submit",
          "goback": "Go back",
          "details": "Details",
          "error": "Error",
          "os": "Operating System",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Done",
          "smth_went_wrong":
              "Something went wrong, it is of course the fault of Educational Development Informatikai Zrt. (e-KRÉTA) in any case! /s",
        },
        "hu_hu": {
          "ekretaYou": "e-KRÉTA, te",
          "description": "Fasz-emulátor hivatásos balfasz!",
          "submit": "Hiba jelentése",
          "goback": "Vissza",
          "details": "Részletek",
          "error": "Hiba",
          "os": "Operációs Rendszer",
          "version": "App Verzió",
          "stack": "Stacktrace",
          "done": "Kész",
          "smth_went_wrong":
              "Valami probléma történt, ez természetesen az Educational Development Informatikai Zrt. (e-KRÉTA) hibája minden esetben! /s",
        },
        "de_de": {
          "ekretaYou": "e-KRÉTA, du",
          "description": "Ein Fehler ist aufgetreten!",
          "submit": "Abschicken",
          "goback": "Zurück",
          "details": "Details",
          "error": "Fehler",
          "os": "Betriebssystem",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Fertig",
          "smth_went_wrong":
              "Irgendetwas ist schief gelaufen, es ist natürlich auf jeden Fall die Schuld der Educational Development Informatikai Zrt. (e-KRÉTA)! /ss",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
