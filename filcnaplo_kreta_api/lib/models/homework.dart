import 'package:filcnaplo_kreta_api/client/api.dart';

import 'subject.dart';
import 'teacher.dart';

class Homework {
  Map? json;
  DateTime date;
  DateTime lessonDate;
  DateTime deadline;
  bool byTeacher;
  bool homeworkEnabled;
  Teacher teacher;
  String content;
  GradeSubject subject;
  String group;
  List<HomeworkAttachment> attachments;
  String id;

  Homework({
    required this.date,
    required this.lessonDate,
    required this.deadline,
    required this.byTeacher,
    required this.homeworkEnabled,
    required this.teacher,
    required this.content,
    required this.subject,
    required this.group,
    required this.attachments,
    required this.id,
    this.json,
  });

  factory Homework.fromJson(Map json) {
    return Homework(
      id: json["Uid"] ?? "",
      date: json["RogzitesIdopontja"] != null
          ? DateTime.parse(json["RogzitesIdopontja"]).toLocal()
          : DateTime(0),
      lessonDate: json["FeladasDatuma"] != null
          ? DateTime.parse(json["FeladasDatuma"]).toLocal()
          : DateTime(0),
      deadline: json["HataridoDatuma"] != null
          ? DateTime.parse(json["HataridoDatuma"]).toLocal()
          : DateTime(0),
      byTeacher: json["IsTanarRogzitette"] ?? true,
      homeworkEnabled: json["IsTanuloHaziFeladatEnabled"] ?? false,
      teacher: Teacher.fromString((json["RogzitoTanarNeve"] ?? "").trim()),
      content: (json["Szoveg"] ?? "").trim(),
      subject: GradeSubject.fromJson(json["Tantargy"] ?? {}),
      group: json["OsztalyCsoport"] != null
          ? json["OsztalyCsoport"]["Uid"] ?? ""
          : "",
      attachments: ((json["Csatolmanyok"] ?? []) as List)
          .cast<Map>()
          .map((Map json) => HomeworkAttachment.fromJson(json))
          .toList(),
      json: json,
    );
  }
}

class HomeworkAttachment {
  Map? json;
  String id;
  String name;
  String type;

  HomeworkAttachment(
      {required this.id, this.name = "", this.type = "", this.json});

  factory HomeworkAttachment.fromJson(Map json) {
    return HomeworkAttachment(
      id: json["Uid"] ?? "",
      name: json["Nev"] ?? "",
      type: json["Tipus"] ?? "",
      json: json,
    );
  }

  String downloadUrl(String iss) =>
      KretaAPI.downloadHomeworkAttachments(iss, id, type);
  bool get isImage =>
      name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png");
}
