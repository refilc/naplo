import 'package:filcnaplo_kreta_api/models/subject.dart';

import 'category.dart';
import 'teacher.dart';

class Exam {
  Map? json;
  DateTime date;
  DateTime writeDate;
  Category? mode;
  // int? subjectIndex;
  // String subjectName;
  GradeSubject subject;
  Teacher teacher;
  String description;
  String group;
  String id;

  Exam({
    required this.id,
    required this.date,
    required this.writeDate,
    this.mode,
    // this.subjectIndex,
    // required this.subjectName,
    required this.subject,
    required this.teacher,
    required this.description,
    required this.group,
    this.json,
  });

  factory Exam.fromJson(Map json) {
    return Exam(
      id: json["Uid"] ?? "",
      date: json["BejelentesDatuma"] != null
          ? DateTime.parse(json["BejelentesDatuma"]).toLocal()
          : DateTime(0),
      writeDate: json["Datum"] != null
          ? DateTime.parse(json["Datum"]).toLocal()
          : DateTime(0),
      mode: json["Modja"] != null ? Category.fromJson(json["Modja"]) : null,
      // subjectIndex: json["OrarendiOraOraszama"],
      // subjectName: json["TantargyNeve"] ?? "",
      subject: GradeSubject.fromJson(json["Tantargy"] ?? {}),
      teacher: Teacher.fromString((json["RogzitoTanarNeve"] ?? "").trim()),
      description: (json["Temaja"] ?? "").trim(),
      group: json["OsztalyCsoport"] != null
          ? json["OsztalyCsoport"]["Uid"] ?? ""
          : "",
      json: json,
    );
  }
}
