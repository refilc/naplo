import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson/changed_lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';

class ChangedLessonViewable extends StatelessWidget {
  const ChangedLessonViewable(this.lesson, {Key? key}) : super(key: key);

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return ChangedLessonTile(
      lesson,
      onTap: () => TimetablePage.jump(context, lesson: lesson),
    );
  }
}
