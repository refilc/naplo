import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:flutter/cupertino.dart';

class SubjectIconData {
  final IconData data;
  final String name; // for iOS live activities compatibilty

  SubjectIconData({
    this.data = CupertinoIcons.rectangle_grid_2x2,
    this.name = "square.grid.2x2",
  });
}

class SubjectIcon {
  static SubjectIconData resolve({Subject? subject, String? subjectName}) {
    assert(!(subject == null && subjectName == null));

    String name = (subject?.name ?? subjectName ?? "").toLowerCase().specialChars().trim();
    String category = subject?.category.description.toLowerCase().specialChars() ?? "";

    // todo: check for categories
    if (RegExp("mate(k|matika)").hasMatch(name) || category == "matematika") {
      return SubjectIconData(data: CupertinoIcons.function, name: "function");
    } else if (RegExp("magyar nyelv|nyelvtan").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.textformat_alt, name: "textformat.alt");
    } else if (RegExp("irodalom").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.book, name: "book");
    } else if (RegExp("tor(i|tenelem)").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.compass, name: "safari");
    } else if (RegExp("foldrajz").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.map, name: "map");
    } else if (RegExp("rajz|muvtori|muveszet|vizualis").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.paintbrush, name: "paintbrush");
    } else if (RegExp("fizika").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.lightbulb, name: "lightbulb");
    } else if (RegExp("^enek|zene|szolfezs|zongora|korus").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.music_note, name: "music.note");
    } else if (RegExp("^tes(i|tneveles)|sport").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.sportscourt, name: "sportscourt");
    } else if (RegExp("kemia").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.lab_flask, name: "testtube.2");
    } else if (RegExp("biologia").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.paw, name: "pawprint");
    } else if (RegExp("kornyezet|termeszet ?(tudomany|ismeret)|hon( es nep)?ismeret").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.arrow_3_trianglepath, name: "arrow.3.trianglepath");
    } else if (RegExp("(hit|erkolcs)tan|vallas|etika").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.heart, name: "heart");
    } else if (RegExp("penzugy").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.money_dollar, name: "dollarsign");
    } else if (RegExp("informatika|szoftver|iroda|digitalis").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.device_laptop, name: "laptopcomputer");
    } else if (RegExp("prog").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.chevron_left_slash_chevron_right, name: "chevron.left.forwardslash.chevron.right");
    } else if (RegExp("halozat").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.antenna_radiowaves_left_right, name: "antenna.radiowaves.left.and.right");
    } else if (RegExp("szinhaz").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.hifispeaker, name: "hifispeaker");
    } else if (RegExp("film|media").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.film, name: "film");
    } else if (RegExp("elektro(tech)?nika").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.bolt, name: "bolt");
    } else if (RegExp("gepesz|mernok|ipar").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.wrench, name: "wrench");
    } else if (RegExp("technika").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.hammer, name: "hammer");
    } else if (RegExp("tanc").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.music_mic, name: "music.mic");
    } else if (RegExp("filozofia").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.bubble_left, name: "bubble.left");
    } else if (RegExp("osztaly(fonoki|kozosseg)").hasMatch(name) || name == "ofo") {
      return SubjectIconData(data: CupertinoIcons.group, name: "person.3");
    } else if (RegExp("gazdasag").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.chart_pie, name: "chart.pie");
    } else if (RegExp("szorgalom").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.checkmark_seal, name: "checkmark.seal");
    } else if (RegExp("magatartas").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.smiley, name: "face.smiling");
    } else if (RegExp("angol|nemet|francia|olasz|orosz|spanyol|latin|kinai|nyelv").hasMatch(name)) {
      return SubjectIconData(data: CupertinoIcons.globe, name: "globe");
    } else if (RegExp("linux").hasMatch(name)) {
      return SubjectIconData(data: FilcIcons.linux);
    }

    return SubjectIconData();
  }
}

class ShortSubject {
  static String resolve({Subject? subject, String? subjectName}) {
    assert(!(subject == null && subjectName == null));

    String name = (subject?.name ?? subjectName ?? "").toLowerCase().specialChars().trim();
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
    } else if (RegExp("(angol|nemet|francia|olasz|orosz|spanyol|latin|kinai) nyelv").hasMatch(name)) {
      return (subject?.name ?? subjectName ?? "?").replaceAll(" nyelv", "");
    } else if (RegExp("informatika").hasMatch(name)) {
      return "Infó";
    } else if (RegExp("osztalyfonoki").hasMatch(name)) {
      return "Ofő";
    }

    return subject?.name.capital() ?? subjectName?.capital() ?? "?";
  }
}
