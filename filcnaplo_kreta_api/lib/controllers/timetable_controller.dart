// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum LoadType { initial, offline, loading, online }

class TimetableController extends ChangeNotifier {
  late Week currentWeek;
  int currentWeekId = -1;
  late int previousWeekId;
  List<List<Lesson>>? days;
  LoadType loadType = LoadType.initial;

  TimetableController() {
    current();
  }

  static int getWeekId(Week week) =>
      (week.start.difference(getSchoolYearStart()).inDays /
              DateTime.daysPerWeek)
          .ceil();

  static DateTime getSchoolYearStart() {
    DateTime now = DateTime.now();
    DateTime nowStart = _getYearStart(now.year);

    if (nowStart.isBefore(now)) {
      return nowStart;
    } else {
      return _getYearStart(now.year - 1);
    }
  }

  static DateTime _getYearStart(int year) {
    var s1 = DateTime(year, DateTime.september, 1);
    if (s1.weekday == 6) {
      s1.add(const Duration(days: 2));
    } else if (s1.weekday == 7) {
      s1.add(const Duration(days: 1));
    }
    return s1;
  }

  // Jump shortcuts
  Future<void> next(BuildContext context) =>
      jump(Week.fromId(currentWeekId + 1), context: context);
  Future<void> previous(BuildContext context) =>
      jump(Week.fromId(currentWeekId - 1), context: context);
  void current() {
    Week week = Week.current();
    int id = getWeekId(week);

    if (id > 51) id = 51;
    if (id < 0) id = 0;

    _setWeek(Week.fromId(id));
  }

  Future<void> jump(Week week,
      {required BuildContext context,
      bool initial = false,
      bool skip = false,
      bool loader = true}) async {
    if (_setWeek(week)) return;

    loadType = LoadType.initial;

    if (loader) {
      days = null;

      // Don't start loading on init
      if (!initial) notifyListeners();
    }

    days = _sortDays(week, context: context);

    if (week != currentWeek) return;

    loadType = LoadType.loading;

    notifyListeners();

    try {
      await _fetchWeek(week, context: context).timeout(
          const Duration(seconds: 5),
          onTimeout: (() => throw "timeout"));
      loadType = LoadType.online;
    } catch (error, stack) {
      print("ERROR: TimetableController.jump: $error\n$stack");
      loadType = LoadType.offline;
    }

    if (week != currentWeek) return;

    days = _sortDays(week, context: context);

    if (week != currentWeek) return;

    // Jump to next week on weekends
    if (skip &&
        (days?.length ?? 0) > 0 &&
        days!.last.last.end.isBefore(DateTime.now())) return next(context);

    notifyListeners();
  }

  bool _setWeek(Week week) {
    int id = getWeekId(week);
    if (id > 51) return true; // Max 52.
    if (id < 0) return true; // Min 1.

    // Set week start to Sept. 1 of first week
    if (!_differentDate(week.start, Week.fromId(0).start)) {
      week.start = TimetableController.getSchoolYearStart();
    }

    currentWeek = week;
    previousWeekId = currentWeekId;
    currentWeekId = id;
    return false;
  }

  Future<void> _fetchWeek(Week week, {required BuildContext context}) async {
    await Future.wait([
      context.read<TimetableProvider>().fetch(week: week),
      context.read<HomeworkProvider>().fetch(from: week.start, db: false),
    ]);
  }

  List<List<Lesson>> _sortDays(Week week, {required BuildContext context}) {
    List<List<Lesson>> days = [];

    try {
      final timetableProvider = context.read<TimetableProvider>();

      List<Lesson> lessons = timetableProvider.getWeek(week) ?? [];

      if (lessons.isNotEmpty) {
        days.add([]);
        lessons.sort((a, b) => a.date.compareTo(b.date));
        for (var lesson in lessons) {
          if (days.last.isNotEmpty &&
              _differentDate(lesson.date, days.last.last.date)) days.add([]);
          days.last.add(lesson);
        }

        for (int i = 0; i < days.length; i++) {
          List<Lesson> _day = List.castFrom(days[i]);

          List<int> lessonIndexes = _getIndexes(_day);
          int minIndex = 0, maxIndex = 0;

          if (lessonIndexes.isNotEmpty) {
            minIndex = lessonIndexes.reduce(math.min);
            maxIndex = lessonIndexes.reduce(math.max);
          }

          List<Lesson> day = [];

          if (lessonIndexes.isNotEmpty) {
            // Fill missing indexes with empty spaces
            for (var i in List<int>.generate(
                maxIndex - minIndex + 1, (int i) => minIndex + i)) {
              List<Lesson> indexLessons = _getLessonsByIndex(_day, i);

              // Empty lesson
              if (indexLessons.isEmpty) {
                // Get start date by previous lesson
                List<Lesson> prevLesson = _getLessonsByIndex(day, i - 1);
                try {
                  DateTime startDate =
                      prevLesson.last.start.add(const Duration(seconds: 1));
                  indexLessons.add(Lesson.fromJson({
                    'isEmpty': true,
                    'Oraszam': i,
                    'KezdetIdopont': startDate.toIso8601String()
                  }));
                  // ignore: empty_catches
                } catch (e) {}
              }

              day.addAll(indexLessons);
            }
          }

          // Additional lessons
          day.addAll(_day.where((l) =>
              int.tryParse(l.lessonIndex) == null && l.subject.id != ''));

          day.sort((a, b) => a.start.compareTo(b.start));

          // Special Dates
          for (var l in _day) {
            l.subject.id == '' ? day.insert(0, l) : null;
          }

          days[i] = day;
        }
      }
    } catch (e) {
      log("_sortDays error: $e");
    }

    return days;
  }

  List<Lesson> _getLessonsByIndex(List<Lesson> lessons, int index) {
    List<Lesson> ret = [];

    for (var lesson in lessons) {
      int? lessonIndex = int.tryParse(lesson.lessonIndex);

      if (lessonIndex != null && lessonIndex == index) {
        ret.add(lesson);
      }
    }

    return ret;
  }

  List<int> _getIndexes(List<Lesson> lessons) {
    List<int> indexes = [];
    for (var l in lessons) {
      int? index = int.tryParse(l.lessonIndex);
      if (index != null) indexes.add(index);
    }
    return indexes;
  }

  bool _differentDate(DateTime a, DateTime b) =>
      !(a.year == b.year && a.month == b.month && a.day == b.day);
}
