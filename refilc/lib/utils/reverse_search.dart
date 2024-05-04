import 'dart:developer';

import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_kreta_api/models/week.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_kreta_api/providers/timetable_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ReverseSearch {
  static Future<Lesson?> getLessonByAbsence(
      Absence absence, BuildContext context) async {
    final timetableProvider =
        Provider.of<TimetableProvider>(context, listen: false);

    List<Lesson> lessons = [];
    final week = Week.fromDate(absence.date);
    try {
      await timetableProvider.fetch(week: week);
    } catch (e) {
      log("[ERROR] getLessonByAbsence: $e");
    }
    lessons = timetableProvider.getWeek(week) ?? [];

    // Find absence lesson in timetable
    Lesson lesson = lessons.firstWhere(
      (l) =>
          _sameDate(l.date, absence.date) &&
          l.subject.id == absence.subject.id &&
          l.lessonIndex == absence.lessonIndex.toString(),
      orElse: () => Lesson.fromJson({'isEmpty': true}),
    );

    if (lesson.isEmpty) {
      return null;
    } else {
      return lesson;
    }
  }

  // difference.inDays is not reliable
  static bool _sameDate(DateTime a, DateTime b) =>
      (a.year == b.year && a.month == b.month && a.day == b.day);

  static Future<GradeSubject?> getSubjectByLesson(
      Lesson lesson, BuildContext context) async {
    final gradeProvider = Provider.of<GradeProvider>(context, listen: false);

    try {
      await gradeProvider.fetch();
    } catch (e) {
      log("[ERROR] getSubjectByLesson: $e");
    }

    try {
      return gradeProvider.grades.map((e) => e.subject).firstWhere(
            (s) => s.id == lesson.subject.id,
          );
    } catch (e) {
      return null;
    }
  }
}
