import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_card.dart';
import 'package:filcnaplo_mobile_ui/common/detail.dart';
import 'package:flutter/material.dart';
import 'lesson_view.i18n.dart';

class LessonView extends StatelessWidget {
  const LessonView(this.lesson, {Key? key}) : super(key: key);

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    Color accent = Theme.of(context).colorScheme.secondary;
    String lessonIndexTrailing = "";

    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    if (lesson.substituteTeacher != "") {
      accent = AppColors.of(context).yellow;
    }

    if (lesson.status?.name == "Elmaradt") {
      accent = AppColors.of(context).red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                lesson.lessonIndex + lessonIndexTrailing,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ),
            title: Text(
              lesson.subject.renamedTo ?? lesson.subject.name.capital(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600, fontStyle: lesson.subject.isRenamed ? FontStyle.italic : null),
            ),
            subtitle: Text(
              lesson.substituteTeacher == "" ? lesson.teacher : lesson.substituteTeacher,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              lesson.date.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          if (lesson.room != "") Detail(title: "Room".i18n, description: lesson.room.replaceAll("_", " ")),
          if (lesson.description != "") Detail(title: "Description".i18n, description: lesson.description),
          if (lesson.lessonYearIndex != null) Detail(title: "Lesson Number".i18n, description: "${lesson.lessonYearIndex}."),
          if (lesson.groupName != "") Detail(title: "Group".i18n, description: lesson.groupName),
        ],
      ),
    );
  }

  static show(Lesson lesson, {required BuildContext context}) {
    showBottomCard(context: context, child: LessonView(lesson));
  }
}
