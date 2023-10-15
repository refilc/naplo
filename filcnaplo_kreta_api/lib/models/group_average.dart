import 'package:filcnaplo_kreta_api/models/subject.dart';

class GroupAverage {
  String uid;
  double average;
  GradeSubject subject;
  Map json;

  GroupAverage({required this.uid, required this.average, required this.subject, this.json = const {}});

  factory GroupAverage.fromJson(Map json) {
    return GroupAverage(
      uid: json["Uid"] ?? "",
      average: json["OsztalyCsoportAtlag"] ?? 0,
      subject: GradeSubject.fromJson(json["Tantargy"] ?? {}),
      json: json,
    );
  }
}
