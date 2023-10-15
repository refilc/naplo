import "category.dart";
import "subject.dart";
import "teacher.dart";

class Absence {
  Map? json;
  String id;
  DateTime date;
  int delay;
  DateTime submitDate;
  Teacher teacher;
  Justification state;
  Category? justification;
  Category? type;
  Category? mode;
  GradeSubject subject;
  DateTime lessonStart;
  DateTime lessonEnd;
  int? lessonIndex;
  String group;
  bool isSeen;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Absence && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Absence({
    required this.id,
    required this.date,
    required this.delay,
    required this.submitDate,
    required this.teacher,
    required this.state,
    this.justification,
    this.type,
    this.mode,
    required this.subject,
    required this.lessonStart,
    required this.lessonEnd,
    this.lessonIndex,
    required this.group,
    this.json,
    this.isSeen = false,
  });

  factory Absence.fromJson(Map json) {
    DateTime lessonStart;
    DateTime lessonEnd;
    int? lessonIndex;
    if (json["Ora"] != null) {
      lessonStart = json["Ora"]["KezdoDatum"] != null
          ? DateTime.parse(json["Ora"]["KezdoDatum"]).toLocal()
          : DateTime(0);
      lessonEnd = json["Ora"]["VegDatum"] != null
          ? DateTime.parse(json["Ora"]["VegDatum"]).toLocal()
          : DateTime(0);
      lessonIndex = json["Ora"]["Oraszam"];
    } else {
      lessonStart = DateTime(0);
      lessonEnd = DateTime(0);
    }

    return Absence(
      id: json["Uid"],
      date: json["Datum"] != null
          ? DateTime.parse(json["Datum"]).toLocal()
          : DateTime(0),
      delay: json["KesesPercben"] ?? 0,
      submitDate: json["KeszitesDatuma"] != null
          ? DateTime.parse(json["KeszitesDatuma"]).toLocal()
          : DateTime(0),
      teacher: Teacher.fromString((json["RogzitoTanarNeve"] ?? "").trim()),
      state: json["IgazolasAllapota"] == "Igazolt"
          ? Justification.excused
          : json["IgazolasAllapota"] == "Igazolando"
              ? Justification.pending
              : Justification.unexcused,
      justification: json["IgazolasTipusa"] != null
          ? Category.fromJson(json["IgazolasTipusa"])
          : null,
      type: json["Tipus"] != null ? Category.fromJson(json["Tipus"]) : null,
      mode: json["Mod"] != null ? Category.fromJson(json["Mod"]) : null,
      subject: GradeSubject.fromJson(json["Tantargy"] ?? {}),
      lessonStart: lessonStart,
      lessonEnd: lessonEnd,
      lessonIndex: lessonIndex,
      group:
          json["OsztalyCsoport"] != null ? json["OsztalyCsoport"]["Uid"] : "",
      isSeen: false,
      json: json,
    );
  }
}

enum Justification { excused, unexcused, pending }
