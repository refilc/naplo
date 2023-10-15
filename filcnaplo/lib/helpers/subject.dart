import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/models/icon_pack.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef SubjectIconVariants = Map<IconPack, IconData>;

class SubjectIconData {
  final SubjectIconVariants data;
  final String name; // for iOS live activities compatibilty

  SubjectIconData({
    this.data = const {
      IconPack.material: Icons.widgets_outlined,
      IconPack.cupertino: CupertinoIcons.rectangle_grid_2x2,
    },
    this.name = "square.grid.2x2",
  });
}

SubjectIconVariants createIcon(
    {required IconData material, required IconData cupertino}) {
  return {
    IconPack.material: material,
    IconPack.cupertino: cupertino,
  };
}

class SubjectIcon {
  static String resolveName({GradeSubject? subject, String? subjectName}) =>
      _resolve(subject: subject, subjectName: subjectName).name;
  static IconData resolveVariant(
          {GradeSubject? subject,
          String? subjectName,
          required BuildContext context}) =>
      _resolve(subject: subject, subjectName: subjectName).data[
          Provider.of<SettingsProvider>(context, listen: false).iconPack]!;

  static SubjectIconData _resolve(
      {GradeSubject? subject, String? subjectName}) {
    assert(!(subject == null && subjectName == null));

    String name = (subject?.name ?? subjectName ?? "")
        .toLowerCase()
        .specialChars()
        .trim();
    String category =
        subject?.category.description.toLowerCase().specialChars() ?? "";

    // todo: check for categories
    if (RegExp("mate(k|matika)").hasMatch(name) || category == "matematika") {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.function,
              material: Icons.calculate_outlined),
          name: "function");
    } else if (RegExp("magyar nyelv|nyelvtan").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.textformat_alt,
              material: Icons.spellcheck_outlined),
          name: "textformat.alt");
    } else if (RegExp("irodalom").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.book,
              material: Icons.menu_book_outlined),
          name: "book");
    } else if (RegExp("tor(i|tenelem)").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.compass,
              material: Icons.hourglass_empty_outlined),
          name: "safari");
    } else if (RegExp("foldrajz").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.map, material: Icons.public_outlined),
          name: "map");
    } else if (RegExp("rajz|muvtori|muveszet|vizualis").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.paintbrush,
              material: Icons.palette_outlined),
          name: "paintbrush");
    } else if (RegExp("fizika").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.lightbulb,
              material: Icons.emoji_objects_outlined),
          name: "lightbulb");
    } else if (RegExp("^enek|zene|szolfezs|zongora|korus").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.music_note,
              material: Icons.music_note_outlined),
          name: "music.note");
    } else if (RegExp("^tes(i|tneveles)|sport").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.sportscourt,
              material: Icons.sports_soccer_outlined),
          name: "sportscourt");
    } else if (RegExp("kemia").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.lab_flask,
              material: Icons.science_outlined),
          name: "testtube.2");
    } else if (RegExp("biologia").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.paw, material: Icons.pets_outlined),
          name: "pawprint");
    } else if (RegExp(
            "kornyezet|termeszet ?(tudomany|ismeret)|hon( es nep)?ismeret")
        .hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.arrow_3_trianglepath,
              material: Icons.eco_outlined),
          name: "arrow.3.trianglepath");
    } else if (RegExp("(hit|erkolcs)tan|vallas|etika").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.heart,
              material: Icons.favorite_border_outlined),
          name: "heart");
    } else if (RegExp("penzugy").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.money_dollar,
              material: Icons.savings_outlined),
          name: "dollarsign");
    } else if (RegExp("informatika|szoftver|iroda|digitalis").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.device_laptop,
              material: Icons.computer_outlined),
          name: "laptopcomputer");
    } else if (RegExp("prog").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.chevron_left_slash_chevron_right,
              material: Icons.code_outlined),
          name: "chevron.left.forwardslash.chevron.right");
    } else if (RegExp("halozat").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.antenna_radiowaves_left_right,
              material: Icons.wifi_tethering_outlined),
          name: "antenna.radiowaves.left.and.right");
    } else if (RegExp("szinhaz").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.hifispeaker,
              material: Icons.theater_comedy_outlined),
          name: "hifispeaker");
    } else if (RegExp("film|media").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.film,
              material: Icons.theaters_outlined),
          name: "film");
    } else if (RegExp("elektro(tech)?nika").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.bolt,
              material: Icons.electrical_services_outlined),
          name: "bolt");
    } else if (RegExp("gepesz|mernok|ipar").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.wrench,
              material: Icons.precision_manufacturing_outlined),
          name: "wrench");
    } else if (RegExp("technika").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.hammer, material: Icons.build_outlined),
          name: "hammer");
    } else if (RegExp("tanc").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.music_mic,
              material: Icons.speaker_outlined),
          name: "music.mic");
    } else if (RegExp("filozofia").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.bubble_left,
              material: Icons.psychology_outlined),
          name: "bubble.left");
    } else if (RegExp("osztaly(fonoki|kozosseg)").hasMatch(name) ||
        name == "ofo") {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.group, material: Icons.groups_outlined),
          name: "person.3");
    } else if (RegExp("gazdasag").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.chart_pie,
              material: Icons.account_balance_outlined),
          name: "chart.pie");
    } else if (RegExp("szorgalom").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.checkmark_seal,
              material: Icons.verified_outlined),
          name: "checkmark.seal");
    } else if (RegExp("magatartas").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.smiley,
              material: Icons.emoji_people_outlined),
          name: "face.smiling");
    } else if (RegExp(
            "angol|nemet|francia|olasz|orosz|spanyol|latin|kinai|nyelv")
        .hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.globe,
              material: Icons.translate_outlined),
          name: "globe");
    } else if (RegExp("linux").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              material: FilcIcons.linux, cupertino: FilcIcons.linux));
    } else if (RegExp("adatbazis").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.table_badge_more,
              material: Icons.table_chart),
          name: "table.badge.more");
    } else if (RegExp("asztali alkalmazasok").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.macwindow,
              material: Icons.desktop_windows_outlined),
          name: "macwindow");
    } else if (RegExp("projekt").hasMatch(name)) {
      return SubjectIconData(
          data: createIcon(
              cupertino: CupertinoIcons.person_3_fill,
              material: Icons.groups_3),
          name: "person.3.fill");
    }

    return SubjectIconData();
  }
}

class ShortSubject {
  static String resolve({GradeSubject? subject, String? subjectName}) {
    assert(!(subject == null && subjectName == null));

    String name = (subject?.name ?? subjectName ?? "")
        .toLowerCase()
        .specialChars()
        .trim();
    // String category = subject?.category.description.toLowerCase().specialChars() ?? "";

    if (RegExp("magyar irodalom").hasMatch(name)) {
      return "Irodalom";
    } else if (RegExp("magyar nyelv").hasMatch(name)) {
      return "Nyelvtan";
    } else if (RegExp("matematika").hasMatch(name)) {
      return "Matek";
    } else if (RegExp("digitalis kultura").hasMatch(name)) {
      return "Dig. kult.";
    } else if (RegExp("testneveles").hasMatch(name)) {
      return "Tesi";
    } else if (RegExp("tortenelem").hasMatch(name)) {
      return "Töri";
    } else if (RegExp(
            "(angol|nemet|francia|olasz|orosz|spanyol|latin|kinai) nyelv")
        .hasMatch(name)) {
      return (subject?.name ?? subjectName ?? "?").replaceAll(" nyelv", "");
    } else if (RegExp("informatika").hasMatch(name)) {
      return "Infó";
    } else if (RegExp("osztalyfonoki").hasMatch(name)) {
      return "Ofő";
    }

    return subject?.name.capital() ?? subjectName?.capital() ?? "?";
  }
}
