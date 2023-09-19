import 'dart:convert';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/subject_lesson_count.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc_kreta_api/models/week.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

// Models
import 'package:refilc/models/settings.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:refilc_kreta_api/models/note.dart';
import 'package:refilc_kreta_api/models/event.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_kreta_api/models/group_average.dart';

class DatabaseQuery {
  DatabaseQuery({required this.db});

  final Database db;

  Future<SettingsProvider> getSettings(DatabaseProvider database) async {
    Map settingsMap = (await db.query("settings")).elementAt(0);
    SettingsProvider settings =
        SettingsProvider.fromMap(settingsMap, database: database);
    return settings;
  }

  Future<UserProvider> getUsers(SettingsProvider settings) async {
    var userProvider = UserProvider(settings: settings);
    List<Map> usersMap = await db.query("users");
    for (var user in usersMap) {
      userProvider.addUser(User.fromMap(user));
    }
    if (userProvider
        .getUsers()
        .map((e) => e.id)
        .contains(settings.lastAccountId)) {
      userProvider.setUser(settings.lastAccountId);
    } else {
      if (usersMap.isNotEmpty) {
        userProvider.setUser(userProvider.getUsers().first.id);
        settings.update(lastAccountId: userProvider.id);
      }
    }
    return userProvider;
  }
}

class UserDatabaseQuery {
  UserDatabaseQuery({required this.db});

  final Database db;

  Future<List<Grade>> getGrades({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? gradesJson = userData.elementAt(0)["grades"] as String?;
    if (gradesJson == null) return [];
    List<Grade> grades =
        (jsonDecode(gradesJson) as List).map((e) => Grade.fromJson(e)).toList();
    return grades;
  }

  Future<Map<Week, List<Lesson>>> getLessons({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? lessonsJson = userData.elementAt(0)["timetable"] as String?;
    if (lessonsJson == null) return {};
    if (jsonDecode(lessonsJson) is List) return {};
    Map<Week, List<Lesson>> lessons =
        (jsonDecode(lessonsJson) as Map).cast<String, List>().map((key, value) {
      return MapEntry(
          Week.fromId(int.parse(key)),
          value
              .cast<Map<String, Object?>>()
              .map((e) => Lesson.fromJson(e))
              .toList());
    }).cast();
    return lessons;
  }

  Future<List<Exam>> getExams({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? examsJson = userData.elementAt(0)["exams"] as String?;
    if (examsJson == null) return [];
    List<Exam> exams =
        (jsonDecode(examsJson) as List).map((e) => Exam.fromJson(e)).toList();
    return exams;
  }

  Future<List<Homework>> getHomework({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? homeworkJson = userData.elementAt(0)["homework"] as String?;
    if (homeworkJson == null) return [];
    List<Homework> homework = (jsonDecode(homeworkJson) as List)
        .map((e) => Homework.fromJson(e))
        .toList();
    return homework;
  }

  Future<List<Message>> getMessages({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? messagesJson = userData.elementAt(0)["messages"] as String?;
    if (messagesJson == null) return [];
    List<Message> messages = (jsonDecode(messagesJson) as List)
        .map((e) => Message.fromJson(e))
        .toList();
    return messages;
  }

  Future<List<Note>> getNotes({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? notesJson = userData.elementAt(0)["notes"] as String?;
    if (notesJson == null) return [];
    List<Note> notes =
        (jsonDecode(notesJson) as List).map((e) => Note.fromJson(e)).toList();
    return notes;
  }

  Future<List<Event>> getEvents({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? eventsJson = userData.elementAt(0)["events"] as String?;
    if (eventsJson == null) return [];
    List<Event> events =
        (jsonDecode(eventsJson) as List).map((e) => Event.fromJson(e)).toList();
    return events;
  }

  Future<List<Absence>> getAbsences({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? absencesJson = userData.elementAt(0)["absences"] as String?;
    if (absencesJson == null) return [];
    List<Absence> absences = (jsonDecode(absencesJson) as List)
        .map((e) => Absence.fromJson(e))
        .toList();
    return absences;
  }

  Future<List<GroupAverage>> getGroupAverages({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return [];
    String? groupAveragesJson =
        userData.elementAt(0)["group_averages"] as String?;
    if (groupAveragesJson == null) return [];
    List<GroupAverage> groupAverages = (jsonDecode(groupAveragesJson) as List)
        .map((e) => GroupAverage.fromJson(e))
        .toList();
    return groupAverages;
  }

  Future<SubjectLessonCount> getSubjectLessonCount(
      {required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return SubjectLessonCount.fromMap({});
    String? lessonCountJson =
        userData.elementAt(0)["subject_lesson_count"] as String?;
    if (lessonCountJson == null) return SubjectLessonCount.fromMap({});
    SubjectLessonCount lessonCount =
        SubjectLessonCount.fromMap(jsonDecode(lessonCountJson) as Map);
    return lessonCount;
  }

  Future<DateTime> lastSeenGrade({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return DateTime(0);
    int? lastSeenDate = userData.elementAt(0)["last_seen_grade"] as int?;
    if (lastSeenDate == null) return DateTime(0);
    DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenDate);
    return lastSeen;
  }

  // renamed things
  Future<Map<String, String>> renamedSubjects({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? renamedSubjectsJson =
        userData.elementAt(0)["renamed_subjects"] as String?;
    if (renamedSubjectsJson == null) return {};
    return (jsonDecode(renamedSubjectsJson) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<Map<String, String>> renamedTeachers({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? renamedTeachersJson =
        userData.elementAt(0)["renamed_teachers"] as String?;
    if (renamedTeachersJson == null) return {};
    return (jsonDecode(renamedTeachersJson) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  // goal planner
  Future<Map<String, String>> subjectGoalPlans({required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? goalPlansJson = userData.elementAt(0)["goal_plans"] as String?;
    if (goalPlansJson == null) return {};
    return (jsonDecode(goalPlansJson) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<Map<String, String>> subjectGoalAverages(
      {required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? goalAvgsJson = userData.elementAt(0)["goal_averages"] as String?;
    if (goalAvgsJson == null) return {};
    return (jsonDecode(goalAvgsJson) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<Map<String, String>> subjectGoalBefores(
      {required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? goalBeforesJson = userData.elementAt(0)["goal_befores"] as String?;
    if (goalBeforesJson == null) return {};
    return (jsonDecode(goalBeforesJson) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<Map<String, String>> subjectGoalPinDates(
      {required String userId}) async {
    List<Map> userData =
        await db.query("user_data", where: "id = ?", whereArgs: [userId]);
    if (userData.isEmpty) return {};
    String? goalPinDatesJson =
        userData.elementAt(0)["goal_pin_dates"] as String?;
    if (goalPinDatesJson == null) return {};
    return (jsonDecode(goalPinDatesJson) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }
}
