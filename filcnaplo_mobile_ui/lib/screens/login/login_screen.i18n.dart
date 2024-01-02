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
          "invalid_grant":
              // "Invalid Username/Password! (Try adding spaces after Username)",
              "Invalid Username/Password!",
          "error": "Failed to log in.",
          "schools_error": "Failed to get schools.",
          "login_w_kreten": "Log in with your e-KRÉTA account to continue!",
          "privacy": "Privacy Policy",
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
          "invalid_grant":
              // "Helytelen Felhasználónév/Jelszó! (Próbálj szóközöket írni a Felhasználónév után)",
              "Helytelen Felhasználónév/Jelszó!",
          "error": "Sikertelen bejelentkezés.",
          "schools_error": "Nem sikerült lekérni az iskolákat.",
          "login_w_kreten":
              "Jelentkezz be az e-KRÉTA fiókoddal a folytatáshoz!",
          "privacy": "Adatkezelési tájékoztató",
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
          "schools_error": "Keine Schulen gefunden.",
          "login_w_kreten":
              "Melden Sie sich mit Ihrem e-KRÉTA-Konto an, um fortzufahren!",
          "privacy": "Datenschutzrichtlinie",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
