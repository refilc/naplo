import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc/ui/widgets/lesson/lesson_tile.dart';
import 'package:flutter/material.dart';

class LessonViewable extends StatelessWidget {
  const LessonViewable(this.lesson, {super.key, this.swapDesc = false});

  final Lesson lesson;
  final bool swapDesc;

  @override
  Widget build(BuildContext context) {
    final tile = LessonTile(lesson, swapDesc: swapDesc);

    if (lesson.subject.id == '' || tile.lesson.isEmpty) return tile;

    return tile;
  }
}
