import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "goal_planner_title": "Goal Planning",
          "set_a_goal": "Your Goal",
          "select_subject": "Subject",
          "pick_route": "Pick a Route",
          "track_it": "Track it!",
          "recommended": "Recommended",
          "fastest": "Fastest",
          "unsolvable": "Unsolvable :(",
          "unreachable": "Unreachable :(",
        },
        "hu_hu": {
          "goal_planner_title": "Cél követés",
          "set_a_goal": "Kitűzött cél",
          "select_subject": "Tantárgy",
          "pick_route": "Válassz egy utat",
          "track_it": "Követés!",
          "recommended": "Ajánlott",
          "fastest": "Leggyorsabb",
          "unsolvable": "Megoldhatatlan :(",
          "unreachable": "Elérhetetlen :(",
        },
        "de_de": {
          "goal_planner_title": "Zielplanung",
          "set_a_goal": "Dein Ziel",
          "select_subject": "Thema",
          "pick_route": "Wähle einen Weg",
          "track_it": "Verfolge es!",
          "recommended": "Empfohlen",
          "fastest": "Am schnellsten",
          "unsolvable": "Unlösbar :(",
          "unreachable": "Unerreichbar :(",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
