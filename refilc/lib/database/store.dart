import 'dart:convert';
import 'package:refilc/models/linked_account.dart';
import 'package:refilc/helpers/notification_helper.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/models/subject_lesson_count.dart';
import 'package:refilc_kreta_api/models/week.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';

// Models
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:refilc_kreta_api/models/note.dart';
import 'package:refilc_kreta_api/models/event.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_kreta_api/models/group_average.dart';

class DatabaseStore {
  DatabaseStore({required this.db});

  final Database db;

  Future<void> storeSettings(SettingsProvider settings) async {
    await db.update("settings", settings.toMap());
  }

  Future<void> storeUser(User user) async {
    List userRes =
        await db.query("users", where: "id = ?", whereArgs: [user.id]);
    if (userRes.isNotEmpty) {
      await db
          .update("users", user.toMap(), where: "id = ?", whereArgs: [user.id]);
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
    await db.update("user_data", {"grades": gradesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeLessons(Map<Week, List<Lesson>?> lessons,
      {required String userId}) async {
    final map = lessons.map<String, List<Map<String, Object?>>>(
      (k, v) => MapEntry(k.id.toString(),
          v!.where((e) => e.json != null).map((e) => e.json!).toList().cast()),
    );
    String lessonsJson = jsonEncode(map);
    await db.update("user_data", {"timetable": lessonsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeExams(List<Exam> exams, {required String userId}) async {
    String examsJson = jsonEncode(exams.map((e) => e.json).toList());
    await db.update("user_data", {"exams": examsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeHomework(List<Homework> homework,
      {required String userId}) async {
    String homeworkJson = jsonEncode(homework.map((e) => e.json).toList());
    await db.update("user_data", {"homework": homeworkJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeMessages(List<Message> messages,
      {required String userId}) async {
    String messagesJson = jsonEncode(messages.map((e) => e.json).toList());
    await db.update("user_data", {"messages": messagesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeRecipients(List<SendRecipient> recipients,
      {required String userId}) async {
    String recipientsJson = jsonEncode(recipients.map((e) => e.json).toList());
    await db.update("user_data", {"recipients": recipientsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeNotes(List<Note> notes, {required String userId}) async {
    String notesJson = jsonEncode(notes.map((e) => e.json).toList());
    await db.update("user_data", {"notes": notesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeEvents(List<Event> events, {required String userId}) async {
    String eventsJson = jsonEncode(events.map((e) => e.json).toList());
    await db.update("user_data", {"events": eventsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeAbsences(List<Absence> absences,
      {required String userId}) async {
    String absencesJson = jsonEncode(absences.map((e) => e.json).toList());
    await db.update("user_data", {"absences": absencesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeGroupAverages(List<GroupAverage> groupAverages,
      {required String userId}) async {
    String groupAveragesJson =
        jsonEncode(groupAverages.map((e) => e.json).toList());
    await db.update("user_data", {"group_averages": groupAveragesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeSubjectLessonCount(SubjectLessonCount lessonCount,
      {required String userId}) async {
    String lessonCountJson = jsonEncode(lessonCount.toMap());
    await db.update("user_data", {"subject_lesson_count": lessonCountJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeLastSeen(DateTime date,
      {required String userId, required LastSeenCategory category}) async {
    int lastSeenDate = date.millisecondsSinceEpoch;
    await db.update("user_data", {"last_seen_${category.name}": lastSeenDate},
        where: "id = ?", whereArgs: [userId]);
  }

  // renamed things
  Future<void> storeRenamedSubjects(Map<String, String> subjects,
      {required String userId}) async {
    String renamedSubjectsJson = jsonEncode(subjects);
    await db.update("user_data", {"renamed_subjects": renamedSubjectsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeRenamedTeachers(Map<String, String> teachers,
      {required String userId}) async {
    String renamedTeachersJson = jsonEncode(teachers);
    await db.update("user_data", {"renamed_teachers": renamedTeachersJson},
        where: "id = ?", whereArgs: [userId]);
  }

  // goal planner
  Future<void> storeSubjectGoalPlans(Map<String, String> plans,
      {required String userId}) async {
    String goalPlansJson = jsonEncode(plans);
    await db.update("user_data", {"goal_plans": goalPlansJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeSubjectGoalAverages(Map<String, String> avgs,
      {required String userId}) async {
    String goalAvgsJson = jsonEncode(avgs);
    await db.update("user_data", {"goal_averages": goalAvgsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeSubjectGoalBefores(Map<String, String> befores,
      {required String userId}) async {
    String goalBeforesJson = jsonEncode(befores);
    await db.update("user_data", {"goal_befores": goalBeforesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeSubjectGoalPinDates(Map<String, String> dates,
      {required String userId}) async {
    String goalPinDatesJson = jsonEncode(dates);
    await db.update("user_data", {"goal_pin_dates": goalPinDatesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  // todo and notes
  Future<void> storeToDoItem(Map<String, bool> items,
      {required String userId}) async {
    String toDoItemsJson = jsonEncode(items);
    await db.update("user_data", {"todo_items": toDoItemsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeSelfNotes(List<SelfNote> selfNotes,
      {required String userId}) async {
    String selfNotesJson = jsonEncode(selfNotes.map((e) => e.json).toList());
    await db.update("user_data", {"self_notes": selfNotesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  // v5
  Future<void> storeRoundings(Map<String, String> roundings,
      {required String userId}) async {
    String roundingsJson = jsonEncode(roundings);
    await db.update("user_data", {"roundings": roundingsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeGradeRarities(Map<String, String> rarities,
      {required String userId}) async {
    String raritiesJson = jsonEncode(rarities);
    await db.update("user_data", {"grade_rarities": raritiesJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeLinkedAccounts(List<LinkedAccount> accounts,
      {required String userId}) async {
    String accountsJson = jsonEncode(accounts.map((e) => e.json).toList());
    await db.update("user_data", {"linked_accounts": accountsJson},
        where: "id = ?", whereArgs: [userId]);
  }

  Future<void> storeCustomLessonDescriptions(Map<String, String> descs,
      {required String userId}) async {
    String descJson = jsonEncode(descs);
    await db.update("user_data", {"custom_lesson_desc": descJson},
        where: "id = ?", whereArgs: [userId]);
  }
}
