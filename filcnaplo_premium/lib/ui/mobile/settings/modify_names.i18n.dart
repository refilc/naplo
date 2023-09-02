import 'package:i18n_extension/i18n_extension.dart';

extension SettingsLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          // subject rename
          "renamed_subjects": "Renamed Subjects",
          "rename_subjects": "Rename Subjects",
          "rename_subject": "Rename Subject",
          "select_subject": "Select Subject",
          "modified_name": "Modified Name",
          "modify_subjects": "Modify Subjects",
          "cancel": "Cancel",
          "done": "Done",
          "rename_new_subject": "Rename New Subject",
          "italics_toggle": "Italic Font",
          // teacher rename
          "renamed_teachers": "Renamed Teachers",
          "rename_teachers": "Rename Teachers",
          "rename_teacher": "Rename Teacher",
          "select_teacher": "Select Teacher",
          "modify_teachers": "Modify Teachers",
          "rename_new_teacher": "Rename New Teacher",
        },
        "hu_hu": {
          // subject rename
          "renamed_subjects": "Átnevezett Tantárgyaid",
          "rename_subjects": "Tantárgyak átnevezése",
          "rename_subject": "Tantárgy átnevezése",
          "select_subject": "Válassz tantárgyat",
          "modified_name": "Módosított név",
          "modify_subjects": "Tantárgyak módosítása",
          "cancel": "Mégse",
          "done": "Kész",
          "rename_new_subject": "Új tantárgy átnevezése",
          "italics_toggle": "Dőlt betűs megjelenítés",
          // teacher rename
          "renamed_teachers": "Átnevezett tanáraid",
          "rename_teachers": "Tanárok átnevezése",
          "rename_teacher": "Tanár átnevezése",
          "select_teacher": "Válassz tanárt",
          "modify_teachers": "Tanárok módosítása",
          "rename_new_teacher": "Új tanár átnevezése",
        },
        "de_de": {
          // subject rename
          "renamed_subjects": "Umbenannte Fächer",
          "rename_subjects": "Fächer umbenennen",
          "rename_subject": "Fach umbenennen",
          "select_subject": "Fach auswählen",
          "modified_name": "Geänderter Name",
          "modify_subjects": "Fächer ändern",
          "cancel": "Abbrechen",
          "done": "Erledigt",
          "rename_new_subject": "Neues Fach umbenennen",
          "italics_toggle": "Kursivschrift umschalten",
          // teacher rename
          "renamed_teachers": "Renamed Teachers",
          "rename_teachers": "Rename Teachers",
          "rename_teacher": "Rename Teacher",
          "select_teacher": "Select Teacher",
          "modify_teachers": "Modify Teachers",
          "rename_new_teacher": "Rename New Teacher",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
