import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:flutter/material.dart';

class TimetableProvider with ChangeNotifier {
  Map<Week, List<Lesson>> lessons = {};
  late final UserProvider _user;
  late final DatabaseProvider _database;
  late final KretaClient _kreta;

  TimetableProvider({
    required UserProvider user,
    required DatabaseProvider database,
    required KretaClient kreta,
  })  : _user = user,
        _database = database,
        _kreta = kreta {
    restoreUser();
  }

  Future<void> restoreUser() async {
    String? userId = _user.id;

    // Load lessons from the database
    if (userId != null) {
      var dbLessons = await _database.userQuery.getLessons(userId: userId);
      lessons = dbLessons;
      await convertBySettings();
    }
  }

  // for renamed subjects
  Future<void> convertBySettings() async {
    Map<String, String> renamedSubjects =
        (await _database.query.getSettings(_database)).renamedSubjectsEnabled
            ? await _database.userQuery.renamedSubjects(userId: _user.id!)
            : {};
    Map<String, String> renamedTeachers =
        (await _database.query.getSettings(_database)).renamedTeachersEnabled
            ? await _database.userQuery.renamedTeachers(userId: _user.id!)
            : {};

    for (Lesson lesson in lessons.values.expand((e) => e)) {
      lesson.subject.renamedTo = renamedSubjects.isNotEmpty
          ? renamedSubjects[lesson.subject.id]
          : null;
      lesson.teacher.renamedTo = renamedTeachers.isNotEmpty
          ? renamedTeachers[lesson.teacher.id]
          : null;
    }

    notifyListeners();
  }

  List<Lesson>? getWeek(Week week) => lessons[week];

  // Fetches Lessons from the Kreta API then stores them in the database
  Future<void> fetch({Week? week}) async {
    if (week == null) return;
    User? user = _user.user;
    if (user == null) throw "Cannot fetch Lessons for User null";
    String iss = user.instituteCode;
    List? lessonsJson = await _kreta
        .getAPI(KretaAPI.timetable(iss, start: week.start, end: week.end));
    if (lessonsJson == null) throw "Cannot fetch Lessons for User ${user.id}";
    List<Lesson> lessonsList = lessonsJson.map((e) => Lesson.fromJson(e)).toList();

    if (lessons.isEmpty && lessons.isEmpty) return;

    lessons[week] = lessonsList;

    await store();
    await convertBySettings();
  }

  // Stores Lessons in the database
  Future<void> store() async {
    User? user = _user.user;
    if (user == null) throw "Cannot store Lessons for User null";
    String userId = user.id;

    // -TODO: clear indexes with weeks outside of the current school year
    await _database.userStore.storeLessons(lessons, userId: userId);
  }

  // Future<void> setLessonCount(SubjectLessonCount lessonCount, {bool store = true}) async {
  //   _subjectLessonCount = lessonCount;

  //   if (store) {
  //     User? user = Provider.of<UserProvider>(_context, listen: false).user;
  //     if (user == null) throw "Cannot store Lesson Count for User null";
  //     String userId = user.id;

  //     await Provider.of<DatabaseProvider>(_context, listen: false).userStore.storeSubjectLessonCount(lessonCount, userId: userId);
  //   }

  //   notifyListeners();
  // }
}
