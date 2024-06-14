import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "ekretaYou": "e-KRÉTA, you",
          "description": "Unexpected error while using the application!",
          "submit": "Submit",
          "goback": "Go back",
          "details": "Details",
          "error": "Error",
          "os": "Operating System",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Done",
          "smth_went_wrong":
              "An unexpected error occurred while using the app.",
        },
        "hu_hu": {
          "ekretaYou": "e-KRÉTA, te",
          "description": "Váratlan hiba az alkalmazás használata közben!",
          "submit": "Hiba jelentése",
          "goback": "Vissza",
          "details": "Részletek",
          "error": "Hiba",
          "os": "Operációs Rendszer",
          "version": "App Verzió",
          "stack": "Stacktrace",
          "done": "Kész",
          "smth_went_wrong":
              "Nem várt hiba következett be az alkalmazás használata közben.",
        },
        "de_de": {
          "ekretaYou": "e-KRÉTA, du",
          "description": "Unerwarteter Fehler bei der Benutzung der Anwendung!",
          "submit": "Abschicken",
          "goback": "Zurück",
          "details": "Details",
          "error": "Fehler",
          "os": "Betriebssystem",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Fertig",
          "smth_went_wrong":
              "Bei der Benutzung der Anwendung ist ein unerwarteter Fehler aufgetreten.",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
