import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "ekretaYou": "eKréta, you",
          "description": "An error occurred!",
          "submit": "Submit",
          "goback": "Go back",
          "details": "Details",
          "error": "Error",
          "os": "Operating System",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Done",
        },
        "hu_hu": {
          "ekretaYou": "eKréta, te",
          "description": "Hiba történt!",
          "submit": "Hiba jelentése",
          "goback": "Vissza",
          "details": "Részletek",
          "error": "Hiba",
          "os": "Operációs Rendszer",
          "version": "App Verzió",
          "stack": "Stacktrace",
          "done": "Kész",
        },
        "de_de": {
          "ekretaYou": "eKréta, du",
          "description": "Ein Fehler ist aufgetreten!",
          "submit": "Abschicken",
          "goback": "Zurück",
          "details": "Details",
          "error": "Fehler",
          "os": "Betriebssystem",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Fertig",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
