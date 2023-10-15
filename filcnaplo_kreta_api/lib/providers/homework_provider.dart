import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
// import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeworkProvider with ChangeNotifier {
  // Private
  // late final SettingsProvider _settings;
  late final UserProvider _user;
  late final DatabaseProvider _database;

  // Public
  late List<Homework> _homework;
  late BuildContext _context;
  List<Homework> get homework => _homework;

  HomeworkProvider({
    List<Homework> initialHomework = const [],
    required BuildContext context,
    required DatabaseProvider database,
    required UserProvider user,
  }) {
    _homework = List.castFrom(initialHomework);
    _context = context;
    _database = database;
    _user = user;

    if (_homework.isEmpty) restore();
  }

  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // Load homework from the database
    if (userId != null) {
      var dbHomework =
          await Provider.of<DatabaseProvider>(_context, listen: false)
              .userQuery
              .getHomework(userId: userId);
      _homework = dbHomework;
      await convertBySettings();
    }
  }

  Future<void> convertBySettings() async {
    Map<String, String> renamedSubjects =
        (await _database.query.getSettings(_database)).renamedSubjectsEnabled
            ? await _database.userQuery.renamedSubjects(userId: _user.id!)
            : {};
    Map<String, String> renamedTeachers =
        (await _database.query.getSettings(_database)).renamedTeachersEnabled
            ? await _database.userQuery.renamedTeachers(userId: _user.id!)
            : {};

    for (Homework homework in _homework) {
      homework.subject.renamedTo = renamedSubjects.isNotEmpty
          ? renamedSubjects[homework.subject.id]
          : null;
      homework.teacher.renamedTo = renamedTeachers.isNotEmpty
          ? renamedTeachers[homework.teacher.id]
          : null;
    }

    notifyListeners();
  }

  // Fetches Homework from the Kreta API then stores them in the database
  Future<void> fetch({DateTime? from, bool db = true}) async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot fetch Homework for User null";

    String iss = user.instituteCode;

    List? homeworkJson = [];

    try {
      Iterable hwjson = await Provider.of<KretaClient>(_context, listen: false)
          .getAPI(KretaAPI.homework(iss, start: from));
      homeworkJson = List.from(hwjson.map((model) => model));
    } catch (e) {
      if (kDebugMode) print(e);
      // error fetcing homework (unknown error)
    }

    if (homeworkJson == null) {
      if (kDebugMode) print("Cannot fetch Homework for User ${user.id}");
      return;
    }

    List<Homework> homework = [];
    await Future.forEach(homeworkJson.cast<Map>(), (Map hw) async {
      Map? e = await Provider.of<KretaClient>(_context, listen: false)
          .getAPI(KretaAPI.homework(iss, id: hw["Uid"]));
      // Map<String, String> renamedSubjects = _settings.renamedSubjectsEnabled
      //     ? await _database.userQuery.renamedSubjects(userId: _user.user!.id)
      //     : {};

      if (e != null) {
        Homework hmwrk = Homework.fromJson(e);
        // hw.subject.renamedTo =
        //     renamedSubjects.isNotEmpty ? renamedSubjects[hw.subject.id] : null;
        homework.add(hmwrk);
      }
    });

    if (homework.isEmpty && _homework.isEmpty) return;

    if (db) await store(homework);
    _homework = homework;
    notifyListeners();
    await convertBySettings();
  }

  // Stores Homework in the database
  Future<void> store(List<Homework> homework) async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Homework for User null";
    String userId = user.id;
    await Provider.of<DatabaseProvider>(_context, listen: false)
        .userStore
        .storeHomework(homework, userId: userId);
  }
}
