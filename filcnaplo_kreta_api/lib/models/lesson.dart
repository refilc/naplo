import 'subject.dart';
import 'category.dart';
import 'teacher.dart';

class Lesson {
  Map? json;
  Category? status;
  DateTime date;
  GradeSubject subject;
  String lessonIndex;
  int? lessonYearIndex;
  Teacher? substituteTeacher;
  Teacher teacher;
  bool homeworkEnabled;
  DateTime start;
  DateTime end;
  bool studentPresence;
  String homeworkId;
  String exam;
  String id;
  Category? type;
  String description;
  String room;
  String groupName;
  String name;
  bool online;
  bool isEmpty;
  bool isSeen;

  Lesson({
    this.status,
    required this.date,
    required this.subject,
    required this.lessonIndex,
    this.lessonYearIndex,
    this.substituteTeacher,
    required this.teacher,
    this.homeworkEnabled = false,
    required this.start,
    required this.end,
    this.studentPresence = true,
    required this.homeworkId,
    this.exam = "",
    required this.id,
    this.type,
    required this.description,
    required this.room,
    required this.groupName,
    required this.name,
    this.online = false,
    this.isEmpty = false,
    this.json,
    this.isSeen = false,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lesson && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Lesson.fromJson(Map json) {
    return Lesson(
        id: json["Uid"] ?? "",
        status:
            json["Allapot"] != null ? Category.fromJson(json["Allapot"]) : null,
        date: json["Datum"] != null
            ? DateTime.parse(json["Datum"]).toLocal()
            : DateTime(0),
        subject: GradeSubject.fromJson(json["Tantargy"] ?? {}),
        lessonIndex: json["Oraszam"] != null ? json["Oraszam"].toString() : "+",
        lessonYearIndex: json["OraEvesSorszama"],
        substituteTeacher: json["HelyettesTanarNeve"] != null
            ? Teacher.fromString((json["HelyettesTanarNeve"]).trim())
            : null,
        teacher: Teacher.fromString((json["TanarNeve"] ?? "").trim()),
        homeworkEnabled: json["IsTanuloHaziFeladatEnabled"] ?? false,
        start: json["KezdetIdopont"] != null
            ? DateTime.parse(json["KezdetIdopont"]).toLocal()
            : DateTime(0),
        studentPresence: json["TanuloJelenlet"] != null
            ? (json["TanuloJelenlet"]["Nev"] ?? "") == "Hianyzas"
                ? false
                : true
            : true,
        end: json["VegIdopont"] != null
            ? DateTime.parse(json["VegIdopont"]).toLocal()
            : DateTime(0),
        homeworkId: json["HaziFeladatUid"] ?? "",
        exam: json["BejelentettSzamonkeresUid"] ?? "",
        type: json["Tipus"] != null ? Category.fromJson(json["Tipus"]) : null,
        description: json["Tema"] ?? "",
        room: ((json["TeremNeve"] ?? "").split("_").join(" ") as String)
            .replaceAll(RegExp(r" ?terem ?", caseSensitive: false), ""),
        groupName: json["OsztalyCsoport"] != null
            ? json["OsztalyCsoport"]["Nev"] ?? ""
            : "",
        name: json["Nev"] ?? "",
        online: json["IsDigitalisOra"] ?? false,
        isEmpty: json['isEmpty'] ?? false,
        json: json,
        isSeen: false);
  }

  int? getFloor() {
    final match = RegExp(r"(\d{3})").firstMatch(room);
    if (match != null) {
      final floorNumber = int.tryParse(match[0] ?? "");
      if (floorNumber != null) {
        return (floorNumber / 100).floor();
      }
    }
    return null;
  }

  bool get isChanged => status?.name == "Elmaradt" || substituteTeacher != null;
  bool get swapDesc => room.length > 8;
}
