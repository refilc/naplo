import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "title_grade": "New grade",
          "body_grade": "You got a %s in %s",
          "body_grade_multiuser": "%s got a %s in %s",
          "title_absence": "Absence recorded",
          "body_absence": "An absence was recorded on %s for %s",
          "body_absence_multiuser": "An absence was recorded for %s on %s for the subject %s",
        },
        "hu_hu": {
          "title_grade": "Új jegy",
          "body_grade": "%s-st kaptál %s tantárgyból",
          "body_grade_multiuser": "%s tanuló %s-st kapott %s tantárgyból",
          "title_absence": "Új hiányzás",
          "body_absence": "Új hiányzást kaptál %s napon %s tantárgyból",
          "body_absence_multiuser": "%s tanuló új hiányzást kapott %s napon %s tantárgyból",
        },
        "de_de": {
          "title_grade": "Neue Note",
          "body_grade": "Du hast eine %s in %s",
          "body_grade_multiuser": "%s hast eine %s in %s",
          "title_absence": "Abwesenheit aufgezeichnet",
          "body_absence": "Auf %s für %s wurde eine Abwesenheit aufgezeichnet",
          "body_absence_multiuser": "Für %s wurde am %s für das Thema Mathematik eine Abwesenheit aufgezeichnet",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
