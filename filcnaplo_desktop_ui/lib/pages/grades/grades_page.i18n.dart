import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Grades": "Grades",
          "Ghost Grades": "Grades",
          "Subjects": "Subjects",
          "Subjects_changes": "Subject differences",
          "empty": "You don't have any subjects.",
          "annual_average": "Annual average",
          "3_months_average": "3 monthly average",
          "30_days_average": "Monthly average",
          "14_days_average": "2 weekly average",
          "7_days_average": "Weekly average",
          "subjectavg": "Subject average",
          "classavg": "Class average",
          "fail_warning": "Failure warning",
          "fail_warning_description": "You are failing %d subjects.".one("You are failing a subject."),
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
          "fail_warning_description": "Bukásra állsz %d tantárgyból.".one("Bukásra állsz egy tantárgyból."),
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
          "fail_warning_description": "Du fällst in %d Fächern durch.".one("Du fällst in einem Fach durch."),
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
