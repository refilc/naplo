import 'school.dart';
import 'package:refilc/utils/format.dart';

class Student {
  Map? json;
  String id;
  String name;
  School school;
  DateTime birth;
  String yearId;
  String? address;
  String? groupId;
  List<String> parents;
  String? className;

  Student({
    required this.id,
    required this.name,
    required this.school,
    required this.birth,
    required this.yearId,
    this.address,
    required this.parents,
    this.json,
  });

  factory Student.fromJson(Map json) {
    List<String> parents = [];

    parents = ((json["Gondviselok"] ?? []) as List)
        .cast<Map>()
        .map((e) => e["Nev"] ?? "")
        .toList()
        .cast<String>();
    if (json["AnyjaNeve"] != null) parents.insert(0, json["AnyjaNeve"]);

    parents = parents.map((e) => e.capitalize()).toList(); // fix name casing
    parents = parents.toSet().toList(); // remove duplicates

    return Student(
      id: json["Uid"] ?? "",
      name: (json["Nev"] ?? json["SzuletesiNev"] ?? "").trim(),
      school: School(
        instituteCode: json["IntezmenyAzonosito"] ?? "",
        name: json["IntezmenyNev"] ?? "",
        city: "",
      ),
      birth: json["SzuletesiDatum"] != null
          ? DateTime.parse(json["SzuletesiDatum"]).toLocal()
          : DateTime(0),
      yearId: json["TanevUid"] ?? "",
      address: json["Cimek"] != null
          ? json["Cimek"].length > 0
              ? json["Cimek"][0]
              : null
          : null,
      parents: parents,
      json: json,
    );
  }
}
