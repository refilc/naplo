import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "uhoh": "Uh Oh!",
          "description": "An error occurred!",
          "submit": "Submit",
          "details": "Details",
          "error": "Error",
          "os": "Operating System",
          "version": "App Version",
          "stack": "Stack Trace",
          "done": "Done",
        },
        "hu_hu": {
          "uhoh": "Ajajj!",
          "description": "Hiba történt!",
          "submit": "Probléma Jelentése",
          "details": "Részletek",
          "error": "Hiba",
          "os": "Operációs Rendszer",
          "version": "App Verzió",
          "stack": "Stacktrace",
          "done": "Kész",
        },
        "de_de": {
          "uhoh": "Uh Oh!",
          "description": "Ein Fehler ist aufgetreten!",
          "submit": "Abschicken",
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
