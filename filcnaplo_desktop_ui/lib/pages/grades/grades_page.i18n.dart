import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Grades": "Grades",
          "Ghost Grades": "Grades",
          "Subjects": "Subjects",
          "Subjects_changes": "Subject Differences",
          "empty": "You don't have any subjects.",
          "annual_average": "Annual average",
          "3_months_average": "3 Monthly Average",
          "30_days_average": "Monthly Average",
          "14_days_average": "2 Weekly Average",
          "7_days_average": "Weekly Average",
          "subjectavg": "Subject Average",
          "classavg": "Class Average",
          "fail_warning": "Faliure warning",
          "fail_warning_description": "You are failing %d subject(s)",
        },
        "hu_hu": {
          "Grades": "Jegyek",
          "Ghost Grades": "Szellem jegyek",
          "Subjects": "Tantárgyak",
          "Subjects_changes": "Tantárgyi változások",
          "empty": "Még nincs egy tárgyad sem.",
          "annual_average": "Éves átlag",
          "3_months_average": "Háromhavi átlag",
          "30_days_average": "Havi átlag",
          "14_days_average": "Kétheti átlag",
          "7_days_average": "Heti átlag",
          "subjectavg": "Tantárgyi átlag",
          "classavg": "Osztályátlag",
          "fail_warning": "Bukás figyelmeztető",
          "fail_warning_description": "Bukásra állsz %d tantárgyból",
        },
        "de_de": {
          "Grades": "Noten",
          "Ghost Grades": "Geist Noten",
          "Subjects": "Fächer",
          "Subjects_changes": "Betreff Änderungen",
          "empty": "Sie haben keine Fächer.",
          "annual_average": "Jahresdurchschnitt",
          "3_months_average": "Drei-Monats-Durchschnitt",
          "30_days_average": "Monatsdurchschnitt",
          "14_days_average": "Vierzehntägiger Durchschnitt",
          "7_days_average": "Wöchentlicher Durchschnitt",
          "subjectavg": "Fächer Durchschnitt",
          "classavg": "Klassendurchschnitt",
          "fail_warning": "Ausfallwarnung",
          "fail_warning_description": "Sie werden in %d des Fachs durchfallen",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
