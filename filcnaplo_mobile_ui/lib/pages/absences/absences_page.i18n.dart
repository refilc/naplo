import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "Absences": "Absences",
          "Delays": "Delays",
          "Misses": "Misses",
          "empty": "You have no absences.",
          "stat_1": "Excused Absences",
          "stat_2": "Unexcused Absences",
          "stat_3": "Excused Delay",
          "stat_4": "Unexcused Delay",
          "min": "min",
          "hr": "hrs",
          "Subjects": "Subjects",
          "attention": "Attention!",
          "attention_body": "Percentage calculations are only an approximation so they may not be accurate.",
        },
        "hu_hu": {
          "Absences": "Hiányzások",
          "Delays": "Késések",
          "Misses": "Hiányok",
          "empty": "Nincsenek hiányaid.",
          "stat_1": "Igazolt hiányzások",
          "stat_2": "Igazolatlan hiányzások",
          "stat_3": "Igazolt Késés",
          "stat_4": "Igazolatlan Késés",
          "min": "perc",
          "hr": "óra",
          "Subjects": "Tantárgyak",
          "attention": "Figyelem!",
          "attention_body": "A százalékos számítások csak közelítések, ezért előfordulhat, hogy nem pontosak.",
        },
        "de_de": {
          "Absences": "Fehlen",
          "Delays": "Verspätung",
          "Misses": "Fehlt",
          "empty": "Sie haben keine Fehlen.",
          "stat_1": "Entschuldigte Fehlen",
          "stat_2": "Unentschuldigte Fehlen",
          "stat_3": "Entschuldigte Verspätung",
          "stat_4": "Unentschuldigte Verspätung",
          "min": "min",
          "hr": "hrs",
          "Subjects": "Fächer",
          "attention": "Achtung!",
          "attention_body": "Prozentberechnungen sind nur eine Annäherung und können daher ungenau sein.",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
