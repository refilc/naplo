import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "username": "Username",
          "usernameHint": "Student ID number",
          "password": "Password",
          "passwordHint": "Date of birth",
          "school": "School",
          "login": "Log in",
          "welcome": "Welcome, %s!",
          "missing_fields": "Missing Fields!",
          "invalid_grant": "Invalid Username/Password!",
          "error": "Failed to log in.",
          "schools_error": "Failed to get schools."
        },
        "hu_hu": {
          "username": "Felhasználónév",
          "usernameHint": "Oktatási azonosító",
          "password": "Jelszó",
          "passwordHint": "Születési dátum",
          "school": "Iskola",
          "login": "Belépés",
          "welcome": "Üdv, %s!",
          "missing_fields": "Hiányzó adatok!",
          "invalid_grant": "Helytelen Felhasználónév/Jelszó!",
          "error": "Sikertelen bejelentkezés.",
          "schools_error": "Nem sikerült lekérni az iskolákat."
        },
        "de_de": {
          "username": "Benutzername",
          "usernameHint": "Ausbildung ID",
          "password": "Passwort",
          "passwordHint": "Geburtsdatum",
          "school": "Schule",
          "login": "Einloggen",
          "welcome": "Wilkommen, %s!",
          "missing_fields": "Fehlende Felder!",
          "invalid_grant": "Ungültiger Benutzername/Passwort!",
          "error": "Anmeldung fehlgeschlagen.",
          "schools_error": "Keine Schulen gefunden."
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
