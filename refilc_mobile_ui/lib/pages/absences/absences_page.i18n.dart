import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Absences": "Absences",
          "Delays": "Delays",
          "Misses": "Misses",
          "emptyDelays": "You have no delays.",
          "emptyMisses": "You have no missing homeworks or equipments.",
          "stat_1": "Excused",
          "stat_2": "Unexcused",
          "stat_3": "Excused",
          "stat_4": "Unexcused",
          "min": "min",
          "hr": "hrs",
          "Subjects": "Subjects",
          "attention": "Attention!",
          "attention_body":
              "Percentage calculations are only an approximation so they may not be accurate.",
          "lesson_not_found": "Cannot find lesson",
          "pending": "Pending",
          "sept": "September",
          "now": "Now",
        },
        "hu_hu": {
          "Absences": "Hiányzások",
          "Delays": "Késések",
          "Misses": "Hiányok",
          "emptyDelays": "Nincsenek késéseid.",
          "emptyMisses": "Nincsenek hiányzó házi feladataid, felszereléseid.",
          "stat_1": "Igazolt",
          "stat_2": "Igazolatlan",
          "stat_3": "Igazolt",
          "stat_4": "Igazolatlan",
          "min": "perc",
          "hr": "óra",
          "Subjects": "Tantárgyak",
          "attention": "Figyelem!",
          "attention_body":
              "A százalékos számítások csak közelítések, ezért előfordulhat, hogy nem pontosak.",
          "lesson_not_found": "Nem található óra",
          "pending": "Függőben",
          "sept": "Szeptember",
          "now": "Most",
        },
        "de_de": {
          "Absences": "Fehlen",
          "Delays": "Verspätung",
          "Misses": "Fehlt",
          "emptyDelays": "Sie haben keine Abwesenheiten.",
          "emptyMisses":
              "Sie haben noch keine fehlende Hausaufgaben oder Austattung.",
          "stat_1": "Entschuldigte",
          "stat_2": "Unentschuldigte",
          "stat_3": "Entschuldigte",
          "stat_4": "Unentschuldigte",
          "min": "min",
          "hr": "hrs",
          "Subjects": "Fächer",
          "attention": "Achtung!",
          "attention_body":
              "Prozentberechnungen sind nur eine Annäherung und können daher ungenau sein.",
          "lesson_not_found": "Lektion kann nicht gefunden werden",
          "pending": "Anhängig",
          "sept": "September",
          "now": "Jetzt",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
