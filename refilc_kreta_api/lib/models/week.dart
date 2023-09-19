import 'package:refilc_kreta_api/controllers/timetable_controller.dart';

class Week {
  DateTime start;
  DateTime end;

  Week({required this.start, required this.end});

  factory Week.current() => Week.fromDate(DateTime.now());

  factory Week.fromId(int id) {
    DateTime _now = TimetableController.getSchoolYearStart()
        .add(Duration(days: id * DateTime.daysPerWeek));
    DateTime now = DateTime(_now.year, _now.month, _now.day);
    return Week(
      start: now.subtract(Duration(days: now.weekday - 1)),
      end: now.add(Duration(days: DateTime.daysPerWeek - now.weekday)),
    );
  }

  factory Week.fromDate(DateTime date) {
    // fix #32
    DateTime _date = DateTime(date.year, date.month, date.day);
    return Week(
      start: _date.subtract(Duration(days: _date.weekday - 1)),
      end: _date.add(Duration(days: DateTime.daysPerWeek - _date.weekday)),
    );
  }

  Week next() => Week.fromDate(start.add(const Duration(days: 8)));

  int get id =>
      -(TimetableController.getSchoolYearStart().difference(start).inDays /
              DateTime.daysPerWeek)
          .floor();

  @override
  String toString() => "Week(start: $start, end: $end)";

  @override
  bool operator ==(Object other) => other is Week && id == other.id;

  @override
  int get hashCode => id;
}
