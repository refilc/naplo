import 'category.dart';

class Note {
  Map? json;
  String id;
  String title;
  DateTime date;
  DateTime submitDate;
  String teacher;
  DateTime seenDate;
  String groupId;
  String content;
  Category? type;

  Note({
    required this.id,
    required this.title,
    required this.date,
    required this.submitDate,
    required this.teacher,
    required this.seenDate,
    required this.groupId,
    required this.content,
    this.type,
    this.json,
  });

  factory Note.fromJson(Map json) {
    return Note(
      id: json["Uid"] ?? "",
      title: json["Cim"] ?? "",
      date: json["Datum"] != null ? DateTime.parse(json["Datum"]).toLocal() : DateTime(0),
      submitDate: json["KeszitesDatuma"] != null ? DateTime.parse(json["KeszitesDatuma"]).toLocal() : DateTime(0),
      teacher: (json["KeszitoTanarNeve"] ?? "").trim(),
      seenDate: json["LattamozasDatuma"] != null ? DateTime.parse(json["LattamozasDatuma"]).toLocal() : DateTime(0),
      groupId: json["OsztalyCsoport"] != null ? json["OsztalyCsoport"]["Uid"] ?? "" : "",
      content: json["Tartalom"].replaceAll("\r", "") ?? "",
      type: json["Tipus"] != null ? Category.fromJson(json["Tipus"]) : null,
      json: json,
    );
  }
}
