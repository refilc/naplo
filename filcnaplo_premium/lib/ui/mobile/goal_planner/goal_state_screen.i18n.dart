import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "goal_planner_title": "Goal Planning",
          "almost_there": "Almost there! Keep going!",
          "started_with": "Started with:",
          "current": "Current:",
          "your_goal": "Your goal:",
          "change_it": "Change it",
          "look_at_graph": "Look at this graph!",
          "thats_progress":
              "Now that's what I call progress! Push a little more, you're almost there..",
          "you_need": "You need:",
        },
        "hu_hu": {
          "goal_planner_title": "Cél követés",
          "almost_there": "Majdnem megvan! Így tovább!",
          "started_with": "Így kezdődött:",
          "current": "Jelenlegi:",
          "your_goal": "Célod:",
          "change_it": "Megváltoztatás",
          "look_at_graph": "Nézd meg ezt a grafikont!",
          "thats_progress":
              "Ezt nevezem haladásnak! Hajts még egy kicsit, már majdnem kész..",
          "you_need": "Szükséges:",
        },
        "de_de": {
          "goal_planner_title": "Zielplanung",
          "almost_there": "Fast dort! Weitermachen!",
          "started_with": "Begann mit:",
          "current": "Aktuell:",
          "your_goal": "Dein Ziel:",
          "change_it": "Ändern Sie es",
          "look_at_graph": "Schauen Sie sich diese Grafik an!",
          "thats_progress":
              "Das nenne ich Fortschritt! Drücken Sie noch ein wenig, Sie haben es fast geschafft..",
          "you_need": "Du brauchst:",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
