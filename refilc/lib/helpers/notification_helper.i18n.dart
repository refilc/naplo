import 'package:i18n_extension/i18n_extension.dart';
import 'package:refilc/api/providers/database_provider.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "title_grade": "New grade",
          "body_grade": "%s: %s",
          "body_grade_multiuser": "(%s) %s: %s",
          "title_absence": "Absence recorded",
          "body_absence": "An absence was recorded on %s for %s",
          "body_absence_multiuser": "An absence was recorded for %s on %s for the subject %s",
          "title_lesson": "Timetable modified",
          "body_lesson_canceled": "Lesson #%s (%s) has been canceled on %s",
          "body_lesson_canceled_multiuser": "(%s) Lesson #%s (%s) has been canceled on %s",
          "body_lesson_substituted": "Lesson #%s (%s) on %s will be substituted by %s",
          "body_lesson_substituted_multiuser": "(%s) Lesson #%s (%s) on %s will be substituted by %s"
        },
        "hu_hu": {
          "title_grade": "Új jegy",
          "body_grade": "%s: %s",
          "body_grade_multiuser": "(%s) %s: %s",
          "body_grade_surprise": "Nyisd meg az alkalmazást a jegyed megtekintéséhez!",
          "title_absence": "Új hiányzás",
          "body_absence": "Új hiányzást kaptál %s napon %s tantárgyból",
          "body_absence_multiuser": "%s tanuló új hiányzást kapott %s napon %s tantárgyból",
          "title_lesson": "Órarend szerkesztve",
          "body_lesson_canceled": "%s napon a(z) %s. óra (%s) elmarad",
          "body_lesson_canceled_multiuser": "(%s) %s napon a(z) %s. óra (%s) elmarad",
          "body_lesson_substituted": "%s napon a(z) %s. (%s) órát %s helyettesíti",
          "body_lesson_substituted_multiuser": "(%s) %s napon a(z) %s. (%s) órát %s helyettesíti"
        },
        "de_de": {
          "title_grade": "Neue Note",
          "body_grade": "%s: %s",
          "body_grade_multiuser": "(%s) %s: %s",
          "body_grade_surprise": "Öffnen Sie die App, um Ihre Note anzuzeigen",
          "title_absence": "Abwesenheit aufgezeichnet",
          "body_absence": "Auf %s für %s wurde eine Abwesenheit aufgezeichnet",
          "body_absence_multiuser": "Für %s wurde am %s für das Thema Mathematik eine Abwesenheit aufgezeichnet",
          "title_lesson": "Fahrplan geändert",
          "body_lesson_canceled": "Lektion Nr. %s (%s) wurde am %s abgesagt",
          "body_lesson_canceled_multiuser": "(%s) Lektion Nr. %s (%s) wurde am %s abgesagt",
          "body_lesson_substituted": "Lektion Nr. %s (%s) wird am %s durch %s ersetzt",
          "body_lesson_substituted_multiuser": "(%s) Lektion Nr. %s (%s) wird am %s durch %s ersetzt"
        },
      };
  String get i18n {
    // very hacky way to get app language in notifications
    // i18n does not like being in background functions (it cannot retrieve locale sometimes)
    final DatabaseProvider databaseProvider = DatabaseProvider();
    databaseProvider.init().then((value) {
      databaseProvider.query.getSettings(databaseProvider).then((settings) {
      return localize(this, _t, locale: "${settings.language}_${settings.language.toUpperCase()}");
    });
    });


    return localize(this, _t);
  }
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
