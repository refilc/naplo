// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:filcnaplo/api/providers/user_provider.dart';
// import 'package:filcnaplo/api/providers/database_provider.dart';
// import 'package:filcnaplo/models/user.dart';
// import 'package:filcnaplo_kreta_api/client/api.dart';
// import 'package:filcnaplo_kreta_api/client/client.dart';
// import 'package:filcnaplo_kreta_api/models/absence.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class TodoNotesProvider with ChangeNotifier {
//   late Map<> _absences;
//   late BuildContext _context;
//   List<Absence> get absences => _absences;

//   TodoNotesProvider({
//     List<Absence> initialAbsences = const [],
//     required BuildContext context,
//   }) {
//     _absences = List.castFrom(initialAbsences);
//     _context = context;

//     if (_absences.isEmpty) restore();
//   }

//   Future<void> restore() async {
//     String? userId = Provider.of<UserProvider>(_context, listen: false).id;

//     // Load absences from the database
//     if (userId != null) {
//       var dbAbsences =
//           await Provider.of<DatabaseProvider>(_context, listen: false)
//               .userQuery
//               .getAbsences(userId: userId);
//       _absences = dbAbsences;
//       await convertBySettings();
//     }
//   }

//   // for renamed subjects
//   Future<void> convertBySettings() async {
//     final _database = Provider.of<DatabaseProvider>(_context, listen: false);
//     Map<String, String> renamedSubjects =
//         (await _database.query.getSettings(_database)).renamedSubjectsEnabled
//             ? await _database.userQuery.renamedSubjects(
//                 userId:
//                     // ignore: use_build_context_synchronously
//                     Provider.of<UserProvider>(_context, listen: false).user!.id)
//             : {};
//     Map<String, String> renamedTeachers =
//         (await _database.query.getSettings(_database)).renamedTeachersEnabled
//             ? await _database.userQuery.renamedTeachers(
//                 userId:
//                     // ignore: use_build_context_synchronously
//                     Provider.of<UserProvider>(_context, listen: false).user!.id)
//             : {};

//     for (Absence absence in _absences) {
//       absence.subject.renamedTo = renamedSubjects.isNotEmpty
//           ? renamedSubjects[absence.subject.id]
//           : null;
//       absence.teacher.renamedTo = renamedTeachers.isNotEmpty
//           ? renamedTeachers[absence.teacher.id]
//           : null;
//     }

//     notifyListeners();
//   }

//   // Fetches Absences from the Kreta API then stores them in the database
//   Future<void> fetch() async {
//     User? user = Provider.of<UserProvider>(_context, listen: false).user;
//     if (user == null) throw "Cannot fetch Absences for User null";
//     String iss = user.instituteCode;

//     List? absencesJson = await Provider.of<KretaClient>(_context, listen: false)
//         .getAPI(KretaAPI.absences(iss));
//     if (absencesJson == null) throw "Cannot fetch Absences for User ${user.id}";
//     List<Absence> absences =
//         absencesJson.map((e) => Absence.fromJson(e)).toList();

//     if (absences.isNotEmpty || _absences.isNotEmpty) await store(absences);
//   }

//   // Stores Absences in the database
//   Future<void> store(List<Absence> absences) async {
//     User? user = Provider.of<UserProvider>(_context, listen: false).user;
//     if (user == null) throw "Cannot store Absences for User null";
//     String userId = user.id;

//     await Provider.of<DatabaseProvider>(_context, listen: false)
//         .userStore
//         .storeAbsences(absences, userId: userId);
//     _absences = absences;
//     await convertBySettings();
//   }
// }
