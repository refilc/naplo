import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          // main thingies
          "no_grades": "No grades found",
          "no_lesson": "No lessons found",
          "greeting": "You had a good year, %s!",
          "title_start": "So let's summarize...",
          "title_grades": "Let's look at your grades... 📖",
          "title_lessons": "Your favorite lesson 💓",
          "title_personality": "Your personality is...",
          // start page
          "start": "Start",
          // grades page
          "tryagain": "Trial and error 🔃",
          "oops": "Ouch... 🥴",
          "endyear_avg": "Year-end average",
          // lessons page
          "absence": "%s absence(s)",
          "delay": "A total of %s minute(s) late",
          "dontfelt": "You didn't like this...",
          "youlate": "You're late!",
          // allsum page
          "test": "test(s)",
          "closingtest": "module test(s)",
          "grade": "grade(s)",
          "hw": "homework(s)",
          "subject": "subject(s)",
          "lesson": "lesson(s)",
          "absence_sum": "absence(s)",
          "excused": "excused",
          "unexcused": "unexcused",
          "delay_sum": "delay(s)",
          "min": "minute(s)",
          // personality page
          "click_reveal": "Click to reveal...",
        },
        "hu_hu": {
          // main thingies
          "no_grades": "Nincsenek jegyek",
          "no_lesson": "Nincsenek tanórák",
          "greeting": "Jó éved volt, %s!",
          "title_start": "Összegezzünk hát...",
          "title_grades": "Nézzük a jegyeidet... 📖",
          "title_lessons": "A kedvenc órád 💓",
          "title_personality": "A te személyiséged...",
          // start page
          "start": "Kezdés",
          // grades page
          "tryagain": "Próba teszi a mestert! 🔃",
          "oops": "Ajjaj... 🥴",
          "endyear_avg": "Év végi átlagod",
          // lessons page
          "absence": "%s hiányzás",
          "delay": "Összesen %s perc késés",
          "dontfelt": "Nem volt kedved hozzá...",
          "youlate": "Késtél!",
          // allsum page
          "test": "dolgozat",
          "closingtest": "témazáró",
          "grade": "jegy",
          "hw": "házi",
          "subject": "tantárgy",
          "lesson": "óra",
          "absence_sum": "hiányzás",
          "excused": "igazolt",
          "unexcused": "igazolatlan",
          "delay_sum": "késés",
          "min": "perc",
          // personality page
          "click_reveal": "Kattints a felfedéshez...",
        },
        "de_de": {
          // main thingies
          "no_grades": "Keine Grade gefunden",
          "no_lesson": "Keine Lektionen gefunden",
          "greeting": "Du hattest ein gutes Jahr, %s!",
          "title_start": "Fassen wir also zusammen...",
          "title_grades": "Schauen wir uns eure Tickets an... 📖",
          "title_lessons": "Deine Lieblingsuhr 💓",
          "title_personality": "Deine Persönlichkeit...",
          // start page
          "start": "Anfang",
          // grades page
          "tryagain": "Er stellt den Meister auf die Probe! 🔃",
          "oops": "Autsch... 🥴",
          "endyear_avg": "Ihr Jahresenddurchschnitt",
          // lessons page
          "absence": "%s Abwesenheit(en)",
          "delay": "Insgesamt %s Minute(n) zu spät",
          "dontfelt": "Es hat dir nicht gefallen...",
          "youlate": "Du bist spät!",
          // allsum page
          "test": "These(n)",
          "closingtest": "Modultest",
          "grade": "Grad",
          "hw": "Hausaufgaben",
          "subject": "Themen",
          "lesson": "Lektionen",
          "absence_sum": "Abwesenheit(en)",
          "excused": "bescheinigte",
          "unexcused": "unentschuldigte",
          "delay_sum": "Verzögerung(en)",
          "min": "Minute(n)",
          // personality page
          "click_reveal": "Klicken Sie hier, um es anzuzeigen...",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
