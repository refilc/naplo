import 'dart:convert';
import 'dart:developer';
import 'package:filcnaplo/models/subject_lesson_count.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

// Models
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_kreta_api/models/event.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/group_average.dart';

class DatabaseStore {
  DatabaseStore({required this.db});

  final Database db;

  Future<void> storeSettings(SettingsProvider settings) async {
    await db.update("settings", settings.toMap());
  }

  Future<void> storeUser(User user) async {
    List userRes = await db.query("users", where: "id = ?", whereArgs: [user.id]);
    if (userRes.isNotEmpty) {
      await db.update("users", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    } else {
      await db.insert("users", user.toMap());
      await db.insert("user_data", {"id": user.id});
    }
  }

  Future<void> removeUser(String userId) async {
    await db.delete("users", where: "id = ?", whereArgs: [userId]);
    await db.delete("user_data", where: "id = ?", whereArgs: [userId]);
  }
}

class UserDatabaseStore {
  UserDatabaseStore({required this.db});

  final Database db;

  Future<void> storeGrades(List<Grade> grades, {required String userId}) async {
    String gradesJson = jsonEncode(grades.map((e) => e.json).toList());
    await db.update("user_data", {"grades": gradesJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeLessons(Map<Week, List<Lesson>?> lessons, {required String userId}) async {
    final map = lessons.map<String, List<Map<String, Object?>>>(
      (k, v) => MapEntry(k.id.toString(), v!.where((e) => e.json != null).map((e) => e.json!).toList().cast()),
    );
    String lessonsJson = jsonEncode(map);
    await db.update("user_data", {"timetable": lessonsJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeExams(List<Exam> exams, {required String userId}) async {
    String examsJson = jsonEncode(exams.map((e) => e.json).toList());
    await db.update("user_data", {"exams": examsJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeHomework(List<Homework> homework, {required String userId}) async {
    String homeworkJson = jsonEncode(homework.map((e) => e.json).toList());
    await db.update("user_data", {"homework": homeworkJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeMessages(List<Message> messages, {required String userId}) async {
    String messagesJson = jsonEncode(messages.map((e) => e.json).toList());
    await db.update("user_data", {"messages": messagesJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeNotes(List<Note> notes, {required String userId}) async {
    String notesJson = jsonEncode(notes.map((e) => e.json).toList());
    await db.update("user_data", {"notes": notesJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeEvents(List<Event> events, {required String userId}) async {
    String eventsJson = jsonEncode(events.map((e) => e.json).toList());
    await db.update("user_data", {"events": eventsJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeAbsences(List<Absence> absences, {required String userId}) async {
    String absencesJson = jsonEncode(absences.map((e) => e.json).toList());
    await db.update("user_data", {"absences": absencesJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeGroupAverages(List<GroupAverage> groupAverages, {required String userId}) async {
    String groupAveragesJson = jsonEncode(groupAverages.map((e) => e.json).toList());
    await db.update("user_data", {"group_averages": groupAveragesJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeSubjectLessonCount(SubjectLessonCount lessonCount, {required String userId}) async {
    String lessonCountJson = jsonEncode(lessonCount.toMap());
    await db.update("user_data", {"subject_lesson_count": lessonCountJson}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeLastSeenGrade(DateTime date, {required String userId}) async {
    int lastSeenDate = date.millisecondsSinceEpoch;
    await db.update("user_data", {"last_seen_grade": lastSeenDate}, where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeRenamedSubjects(Map<String, String> subjects, {required String userId}) async {
    String renamedSubjectsJson = jsonEncode(subjects);
    await db.update("user_data", {"renamed_subjects": renamedSubjectsJson}, where: "id = ?", whereArgs: [userId]);
  }
}
