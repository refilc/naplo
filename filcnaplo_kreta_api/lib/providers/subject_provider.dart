// import 'package:filcnaplo/api/providers/user_provider.dart';
// import 'package:filcnaplo/api/providers/database_provider.dart';
// import 'package:filcnaplo/models/settings.dart';
// import 'package:filcnaplo/models/user.dart';
// import 'package:filcnaplo_kreta_api/client/api.dart';
// import 'package:filcnaplo_kreta_api/client/client.dart';
// import 'package:filcnaplo_kreta_api/models/grade.dart';
// import 'package:filcnaplo_kreta_api/models/group_average.dart';
// import 'package:filcnaplo_kreta_api/providers/grade_provider.i18n.dart';
// import 'package:flutter/material.dart';

// class SubjectProvider with ChangeNotifier {
//   // Private
//   late List<Grade> _grades;
//   late DateTime _lastSeen;
//   late String _groups;
//   List<GroupAverage> _groupAvg = [];
//   late final SettingsProvider _settings;
//   late final UserProvider _user;
//   late final DatabaseProvider _database;
//   late final KretaClient _kreta;

//   // Public
//   List<Grade> get grades => _grades;
//   DateTime get lastSeenDate =>
//       _settings.gradeOpeningFun ? _lastSeen : DateTime(3000);
//   String get groups => _groups;
//   List<GroupAverage> get groupAverages => _groupAvg;

//   SubjectProvider({
//     List<Grade> initialGrades = const [],
//     required SettingsProvider settings,
//     required UserProvider user,
//     required DatabaseProvider database,
//     required KretaClient kreta,
//   }) {
//     _settings = settings;
//     _user = user;
//     _database = database;
//     _kreta = kreta;

//     _grades = List.castFrom(initialGrades);
//     _lastSeen = DateTime.now();

//     if (_grades.isEmpty) restore();
//   }

//   Future<void> seenAll() async {
//     String? userId = _user.id;
//     if (userId != null) {
//       final userStore = _database.userStore;
//       userStore.storeLastSeenGrade(DateTime.now(), userId: userId);
//       _lastSeen = DateTime.now();
//     }
//   }

//   Future<void> restore() async {
//     String? userId = _user.id;

//     // Load grades from the database
//     if (userId != null) {
//       final userQuery = _database.userQuery;

//       _grades = await userQuery.getGrades(userId: userId);
//       await convertBySettings();
//       _groupAvg = await userQuery.getGroupAverages(userId: userId);
//       notifyListeners();
//       DateTime lastSeenDB = await userQuery.lastSeenGrade(userId: userId);
//       if (lastSeenDB.millisecondsSinceEpoch == 0 ||
//           lastSeenDB.year == 0 ||
//           !_settings.gradeOpeningFun) {
//         _lastSeen = DateTime.now();
//         await seenAll();
//       } else {
//         _lastSeen = lastSeenDB;
//       }
//       notifyListeners();
//     }
//   }

//   // good student mode, renamed subjects
//   Future<void> convertBySettings() async {
//     Map<String, String> renamedSubjects = _settings.renamedSubjectsEnabled
//         ? await _database.userQuery.renamedSubjects(userId: _user.user!.id)
//         : {};
//     Map<String, String> renamedTeachers = _settings.renamedTeachersEnabled
//         ? await _database.userQuery.renamedTeachers(userId: _user.user!.id)
//         : {};

//     for (Grade grade in _grades) {
//       grade.subject.renamedTo =
//           renamedSubjects.isNotEmpty ? renamedSubjects[grade.subject.id] : null;
//       grade.teacher.renamedTo =
//           renamedTeachers.isNotEmpty ? renamedTeachers[grade.teacher.id] : null;

//       grade.value.value =
//           _settings.goodStudent ? 5 : grade.json!["SzamErtek"] ?? 0;
//       grade.value.valueName = _settings.goodStudent
//           ? "Jeles".i18n
//           : '${grade.json!["SzovegesErtek"]}'
//               .replaceAll(RegExp(r'[(]+[12345]?[)]'), '')
//               .i18n;
//       grade.value.shortName = _settings.goodStudent
//           ? "Jeles".i18n
//           : '${grade.json!["SzovegesErtekelesRovidNev"]}' != "null" &&
//                   '${grade.json!["SzovegesErtekelesRovidNev"]}' != "-" &&
//                   '${grade.json!["SzovegesErtekelesRovidNev"]}'
//                           .replaceAll(RegExp(r'[0123456789]+[%]?'), '') !=
//                       ""
//               ? '${grade.json!["SzovegesErtekelesRovidNev"]}'.i18n
//               : grade.value.valueName;
//     }

//     notifyListeners();
//   }

//   // fetch subjects from kreten then store them
//   Future<void> fetch() async {
//     User? user = _user.user;
//     if (user == null) throw "Cannot fetch Subjects for User null";
//     String iss = user.instituteCode;

//     List? gradesJson = await _kreta.getAPI(KretaAPI.subjects(iss, ""));
//     if (gradesJson == null) throw "Cannot fetch Subjects for User ${user.id}";
//     List<Grade> grades = gradesJson.map((e) => Grade.fromJson(e)).toList();

//     if (grades.isNotEmpty || _grades.isNotEmpty) await store(grades);

//     List? groupsJson = await _kreta.getAPI(KretaAPI.groups(iss));
//     if (groupsJson == null || groupsJson.isEmpty) {
//       throw "Cannot fetch Groups for User ${user.id}";
//     }
//     _groups = (groupsJson[0]["OktatasNevelesiFeladat"] ?? {})["Uid"] ?? "";

//     List? groupAvgJson =
//         await _kreta.getAPI(KretaAPI.groupAverages(iss, _groups));
//     if (groupAvgJson == null) {
//       throw "Cannot fetch Class Averages for User ${user.id}";
//     }
//     final groupAvgs =
//         groupAvgJson.map((e) => GroupAverage.fromJson(e)).toList();
//     await storeGroupAvg(groupAvgs);
//   }

//   // store subjects in db
//   Future<void> store(List<Grade> grades) async {
//     User? user = _user.user;
//     if (user == null) throw "Cannot store Grades for User null";
//     String userId = user.id;

//     await _database.userStore.storeGrades(grades, userId: userId);
//     _grades = grades;
//     await convertBySettings();
//   }

//   Future<void> storeGroupAvg(List<GroupAverage> groupAvgs) async {
//     _groupAvg = groupAvgs;

//     User? user = _user.user;
//     if (user == null) throw "Cannot store Grades for User null";
//     String userId = user.id;
//     await _database.userStore.storeGroupAverages(groupAvgs, userId: userId);
//     notifyListeners();
//   }
// }
