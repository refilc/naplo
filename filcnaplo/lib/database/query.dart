import 'dart:convert';
import 'package:filcnaplo/models/subject_lesson_count.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:sqflite_common/sqlite_api.dart';

// Models
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo_kreta_api/models/event.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/group_average.dart';

class DatabaseQuery {
  DatabaseQuery({required this.db});

  final Database db;

  Future<SettingsProvider> getSettings() async {
    Map settingsMap = (await db.query("settings")).elementAt(0);
    SettingsProvider settings = SettingsProvider.fromMap(settingsMap);
    return settings;
  }

  Future<UserProvider> getUsers() async {
    var userProvider = UserProvider();
    List<Map> usersMap = await db.query("users");
    for (var user in usersMap) {
      userProvider.addUser(User.fromMap(user));
    }
    return userProvider;
  }
}

class UserDatabaseQuery {
  UserDatabaseQuery({required this.db});

  final Database db;

  Future<List<Grade>> getGrades({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? gradesJson = userData.elementAt(0)["grades"] as String?;
    if (gradesJson == null) return [];
    List<Grade> grades = (jsonDecode(gradesJson) as List).map((e) => Grade.fromJson(e)).toList();
    return grades;
  }

  Future<List<Lesson>> getLessons({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? lessonsJson = userData.elementAt(0)["timetable"] as String?;
    if (lessonsJson == null) return [];
    List<Lesson> lessons = (jsonDecode(lessonsJson) as List).map((e) => Lesson.fromJson(e)).toList();
    return lessons;
  }

  Future<List<Exam>> getExams({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? examsJson = userData.elementAt(0)["exams"] as String?;
    if (examsJson == null) return [];
    List<Exam> exams = (jsonDecode(examsJson) as List).map((e) => Exam.fromJson(e)).toList();
    return exams;
  }

  Future<List<Homework>> getHomework({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? homeworkJson = userData.elementAt(0)["homework"] as String?;
    if (homeworkJson == null) return [];
    List<Homework> homework = (jsonDecode(homeworkJson) as List).map((e) => Homework.fromJson(e)).toList();
    return homework;
  }

  Future<List<Message>> getMessages({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? messagesJson = userData.elementAt(0)["messages"] as String?;
    if (messagesJson == null) return [];
    List<Message> messages = (jsonDecode(messagesJson) as List).map((e) => Message.fromJson(e)).toList();
    return messages;
  }

  Future<List<Note>> getNotes({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? notesJson = userData.elementAt(0)["notes"] as String?;
    if (notesJson == null) return [];
    List<Note> notes = (jsonDecode(notesJson) as List).map((e) => Note.fromJson(e)).toList();
    return notes;
  }

  Future<List<Event>> getEvents({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? eventsJson = userData.elementAt(0)["events"] as String?;
    if (eventsJson == null) return [];
    List<Event> events = (jsonDecode(eventsJson) as List).map((e) => Event.fromJson(e)).toList();
    return events;
  }

  Future<List<Absence>> getAbsences({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? absencesJson = userData.elementAt(0)["absences"] as String?;
    if (absencesJson == null) return [];
    List<Absence> absences = (jsonDecode(absencesJson) as List).map((e) => Absence.fromJson(e)).toList();
    return absences;
  }

  Future<List<GroupAverage>> getGroupAverages({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? groupAveragesJson = userData.elementAt(0)["group_averages"] as String?;
    if (groupAveragesJson == null) return [];
    List<GroupAverage> groupAverages = (jsonDecode(groupAveragesJson) as List).map((e) => GroupAverage.fromJson(e)).toList();
    return groupAverages;
  }

  Future<SubjectLessonCount> getSubjectLessonCount({required String userId}) async {
    List<Map> userData = await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return SubjectLessonCount.fromMap({});
    String? lessonCountJson = userData.elementAt(0)["subject_lesson_count"] as String?;
    if (lessonCountJson == null) return SubjectLessonCount.fromMap({});
    SubjectLessonCount lessonCount = SubjectLessonCount.fromMap(jsonDecode(lessonCountJson) as Map);
    return lessonCount;
  }
}
