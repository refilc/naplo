import 'package:filcnaplo/utils/format.dart';
import 'category.dart';
import 'subject.dart';
import 'teacher.dart';

class Grade {
  Map? json;
  String id;
  DateTime date;
  GradeValue value;
  Teacher teacher;
  String description;
  GradeType type;
  String groupId;
  GradeSubject subject;
  Category? gradeType;
  Category mode;
  DateTime writeDate;
  DateTime seenDate;
  String form;

  Grade({
    required this.id,
    required this.date,
    required this.value,
    required this.teacher,
    required this.description,
    required this.type,
    required this.groupId,
    required this.subject,
    this.gradeType,
    required this.mode,
    required this.writeDate,
    required this.seenDate,
    required this.form,
    this.json,
  });

  factory Grade.fromJson(Map json) {
    return Grade(
      id: json["Uid"] ?? "",
      date: json["KeszitesDatuma"] != null
          ? DateTime.parse(json["KeszitesDatuma"]).toLocal()
          : DateTime(0),
      value: GradeValue(
        json["SzamErtek"] ?? 0,
        json["SzovegesErtek"] ?? "",
        json["SzovegesErtekelesRovidNev"] ?? "",
        json["SulySzazalekErteke"] ?? 0,
        percentage: json["ErtekFajta"] != null
            ? json["ErtekFajta"]["Uid"] == "3,Szazalekos"
            : false,
      ),
      teacher: Teacher.fromString((json["ErtekeloTanarNeve"] ?? "").trim()),
      description: json["Tema"] ?? "",
      type: json["Tipus"] != null
          ? Category.getGradeType(json["Tipus"]["Nev"])
          : GradeType.unknown,
      groupId: (json["OsztalyCsoport"] ?? {})["Uid"] ?? "",
      subject: GradeSubject.fromJson(json["Tantargy"] ?? {}),
      gradeType: json["ErtekFajta"] != null
          ? Category.fromJson(json["ErtekFajta"])
          : null,
      mode: Category.fromJson(json["Mod"] ?? {}),
      writeDate: json["RogzitesDatuma"] != null
          ? DateTime.parse(json["RogzitesDatuma"]).toLocal()
          : DateTime(0),
      seenDate: json["LattamozasDatuma"] != null
          ? DateTime.parse(json["LattamozasDatuma"]).toLocal()
          : DateTime(0),
      form: (json["Jelleg"] ?? "Na") != "Na" ? json["Jelleg"] : "",
      json: json,
    );
  }

  bool compareTo(dynamic other) {
    if (runtimeType != other.runtimeType) return false;

    if (id == other.id && seenDate == other.seenDate) {
      return true;
    }

    return false;
  }
}

class GradeValue {
  int _value;
  set value(int v) => _value = v;
  int get value {
    String _valueName = valueName.toLowerCase().specialChars();
    if (_value == 0 &&
        ["peldas", "jo", "valtozo", "rossz", "hanyag"].contains(_valueName)) {
      switch (_valueName) {
        case "peldas":
          return 5;
        case "jo":
          return 4;
        case "valtozo":
          return 3;
        case "rossz":
          return 2;
        case "hanyag":
          return 1;
        // other
        case "jeles":
          return 5;
        case "kozepes":
          return 3;
        case "elegseges":
          return 2;
        case "elegtelen":
          return 1;
      }
    }
    return _value;
  }

  String _valueName;
  set valueName(String v) => _valueName = v;
  String get valueName => _valueName.split("(")[0];
  String shortName;
  int _weight;
  set weight(int v) => _weight = v;
  int get weight {
    String _valueName = valueName.toLowerCase().specialChars();
    if (_value == 0 &&
        ["peldas", "jo", "valtozo", "rossz", "hanyag"].contains(_valueName)) {
      return 0;
    }
    return _weight;
  }

  final bool _percentage;
  bool get percentage => _percentage;

  GradeValue(int value, String valueName, this.shortName, int weight,
      {bool percentage = false})
      : _value = value,
        _valueName = valueName,
        _weight = weight,
        _percentage = percentage;
}

enum GradeType {
  midYear,
  firstQ,
  secondQ,
  halfYear,
  thirdQ,
  fourthQ,
  endYear,
  levelExam,
  ghost,
  unknown
}
