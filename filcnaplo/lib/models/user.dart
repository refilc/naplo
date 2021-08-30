import 'dart:convert';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:uuid/uuid.dart';

class User {
  late String id;
  String username;
  String password;
  String instituteCode;
  String name;
  Student student;

  User({
    String? id,
    required this.name,
    required this.username,
    required this.password,
    required this.instituteCode,
    required this.student,
  }) {
    if (id != null) {
      this.id = id;
    } else {
      this.id = Uuid().v4();
    }
  }

  factory User.fromMap(Map map) {
    return User(
      id: map["id"],
      instituteCode: map["institute_code"],
      username: map["username"],
      password: map["password"],
      name: map["name"],
      student: Student.fromJson(jsonDecode(map["student"])),
    );
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "institute_code": instituteCode,
      "name": name,
      "student": jsonEncode(student.json),
    };
  }

  static Map<String, Object?> loginBody({
    required String username,
    required String password,
    required String instituteCode,
  }) {
    return {
      "userName": username,
      "password": password,
      "institute_code": instituteCode,
      "grant_type": "password",
      "client_id": KretaAPI.CLIENT_ID,
    };
  }
}
