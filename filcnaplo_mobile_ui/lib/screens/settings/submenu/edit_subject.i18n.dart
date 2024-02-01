import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "rename_it": "Rename Subject",
          "rename_te": "Rename Teacher",
          "rounding": "Rounding",
          "gs_mode": "Good Student Mode",
          "rename_subject": "Rename Subject",
          "modified_name": "Modified Name",
          "cancel": "Cancel",
          "done": "Done",
        },
        "hu_hu": {
          "rename_it": "Tantárgy átnevezése",
          "rename_te": "Tanár átnevezése",
          "rounding": "Kerekítés",
          "gs_mode": "Jó tanuló mód",
          "rename_subject": "Tantárgy átnevezése",
          "modified_name": "Módosított név",
          "cancel": "Mégse",
          "done": "Kész",
        },
        "de_de": {
          "rename_it": "Betreff umbenennen",
          "rename_te": "Lehrer umbenennen",
          "rounding": "Rundung",
          "gs_mode": "Guter Student Modus",
          "rename_subject": "Fach umbenennen",
          "modified_name": "Geänderter Name",
          "cancel": "Abbrechen",
          "done": "Erledigt",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
