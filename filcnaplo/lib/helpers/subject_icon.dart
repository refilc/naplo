import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:flutter/material.dart';

class SubjectIcon {
  static IconData? lookup({Subject? subject, String? subjectName}) {
    assert(!(subject == null && subjectName == null));

    String name = (subject?.name ?? subjectName ?? "").toLowerCase().specialChars().trim();
    String category = subject?.category.description.toLowerCase().specialChars() ?? "";

    // todo: check for categories
    if (RegExp("mate(k|matika)").hasMatch(name) || category == "matematika") return Icons.calculate_outlined;
    if (RegExp("magyar nyelv|nyelvtan").hasMatch(name)) return Icons.spellcheck_outlined;
    if (RegExp("irodalom").hasMatch(name)) return Icons.menu_book_outlined;
    if (RegExp("tor(i|tenelem)").hasMatch(name)) return Icons.hourglass_empty_outlined;
    if (RegExp("foldrajz").hasMatch(name)) return Icons.public_outlined;
    if (RegExp("rajz|muvtori|muveszet|vizualis").hasMatch(name)) return Icons.palette_outlined;
    if (RegExp("fizika").hasMatch(name)) return Icons.emoji_objects_outlined;
    if (RegExp("^enek|zene|szolfezs|zongora|korus").hasMatch(name)) return Icons.music_note_outlined;
    if (RegExp("^tes(i|tneveles)|sport").hasMatch(name)) return Icons.sports_soccer_outlined;
    if (RegExp("kemia").hasMatch(name)) return Icons.science_outlined;
    if (RegExp("biologia").hasMatch(name)) return Icons.pets_outlined;
    if (RegExp("kornyezet|termeszet(tudomany|ismeret)|hon( es nep)?ismeret").hasMatch(name)) return Icons.eco_outlined;
    if (RegExp("(hit|erkolcs)tan|vallas|etika").hasMatch(name)) return Icons.favorite_border_outlined;
    if (RegExp("penzugy").hasMatch(name)) return Icons.savings_outlined;
    if (RegExp("informatika|szoftver|iroda|digitalis").hasMatch(name)) return Icons.computer_outlined;
    if (RegExp("prog").hasMatch(name)) return Icons.code_outlined;
    if (RegExp("halozat").hasMatch(name)) return Icons.wifi_tethering_outlined;
    if (RegExp("szinhaz").hasMatch(name)) return Icons.theater_comedy_outlined;
    if (RegExp("film|media").hasMatch(name)) return Icons.theaters_outlined;
    if (RegExp("elektro(tech)?nika").hasMatch(name)) return Icons.electrical_services_outlined;
    if (RegExp("gepesz|mernok|ipar").hasMatch(name)) return Icons.precision_manufacturing_outlined;
    if (RegExp("technika").hasMatch(name)) return Icons.build_outlined;
    if (RegExp("tanc").hasMatch(name)) return Icons.speaker_outlined;
    if (RegExp("filozofia").hasMatch(name)) return Icons.psychology_outlined;
    if (RegExp("osztaly(fonoki|kozosseg)").hasMatch(name) || name == "ofo") return Icons.groups_outlined;
    if (RegExp("gazdasag").hasMatch(name)) return Icons.account_balance_outlined;
    if (RegExp("szorgalom").hasMatch(name)) return Icons.verified_outlined;
    if (RegExp("magatartas").hasMatch(name)) return Icons.emoji_people_outlined;
    if (RegExp("angol|nemet|francia|olasz|orosz|spanyol|latin|kinai|nyelv").hasMatch(name)) return Icons.translate_outlined;
    if (RegExp("linux").hasMatch(name)) return FilcIcons.linux;
    return Icons.widgets_outlined;
  }
}
