import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "goodmorning": "Good morning, %s!",
          "goodafternoon": "Good afternoon, %s!",
          "goodevening": "Good evening, %s!",
          "goodrest": "⛱️ Have a nice holiday, %s!",
          "happybirthday": "🎂 Happy birthday, %s!",
          "merryxmas": "🎄 Merry Christmas, %s!",
          "happynewyear": "🎉 Happy New Year, %s!",
          "empty": "Nothing to see here.",
          "All": "All",
          "Grades": "Grades",
          "Messages": "Messages",
          "Absences": "Absences",
          "update_available": "Update Available",
          "missed_exams": "You missed %s exams this week.".one("You missed an exam this week."),
          "missed_exam_contact": "Contact %s, to resolve it!",
        },
        "hu_hu": {
          "goodmorning": "Jó reggelt, %s!",
          "goodafternoon": "Szép napot, %s!",
          "goodevening": "Szép estét, %s!",
          "goodrest": "⛱️ Jó szünetet, %s!",
          "happybirthday": "🎂 Boldog születésnapot, %s!",
          "merryxmas": "🎄 Boldog Karácsonyt, %s!",
          "happynewyear": "🎉 Boldog új évet, %s!",
          "empty": "Nincs itt semmi látnivaló.",
          "All": "Összes",
          "Grades": "Jegyek",
          "Messages": "Üzenetek",
          "Absences": "Hiányok",
          "update_available": "Frissítés elérhető",
          "missed_exams": "Ezen a héten hiányoztál %s dolgozatról.".one("Ezen a héten hiányoztál egy dolgozatról."),
          "missed_exam_contact": "Keresd %s-t, ha pótolni szeretnéd!",
        },
        "de_de": {
          "goodmorning": "Guten morgen, %s!",
          "goodafternoon": "Guten Tag, %s!",
          "goodevening": "Guten Abend, %s!",
          "goodrest": "⛱️ Schöne Ferien, %s!",
          "happybirthday": "🎂 Alles Gute zum Geburtstag, %s!",
          "merryxmas": "🎄 Frohe Weihnachten, %s!",
          "happynewyear": "🎉 Frohes neues Jahr, %s!",
          "empty": "Hier gibt es nichts zu sehen.",
          "All": "Alles",
          "Grades": "Noten",
          "Messages": "Nachrichten",
          "Absences": "Fehlen",
          "update_available": "Update verfügbar",
          "missed_exams": "Diese Woche haben Sie %s Prüfungen verpasst.".one("Diese Woche haben Sie eine Prüfung verpasst."),
          "missed_exam_contact": "Wenden Sie sich an %s, um sie zu erneuern!",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
