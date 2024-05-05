import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_mobile_ui/common/bottom_card.dart';
import 'package:refilc_mobile_ui/common/detail.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lesson_view.i18n.dart';

class LessonView extends StatelessWidget {
  const LessonView(this.lesson, {super.key});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    Color accent = AppColors.of(context).text;
    String lessonIndexTrailing = "";

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    if (lesson.substituteTeacher != null &&
        lesson.substituteTeacher?.name != "") {
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
              child: RoundBorderIcon(
                color: accent,
                width: 1.0,
                icon: SizedBox(
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Text(
                        lesson.lessonIndex + lessonIndexTrailing,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              lesson.subject.renamedTo ?? lesson.subject.name.capital(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: lesson.subject.isRenamed &&
                          settingsProvider.renamedSubjectsItalics
                      ? FontStyle.italic
                      : null),
            ),
            subtitle: Text(
              ((lesson.substituteTeacher == null ||
                          lesson.substituteTeacher!.name == "")
                      ? (lesson.teacher.isRenamed
                          ? lesson.teacher.renamedTo
                          : lesson.teacher.name)
                      : (lesson.substituteTeacher!.isRenamed
                          ? lesson.substituteTeacher!.renamedTo
                          : lesson.substituteTeacher!.name)) ??
                  '',
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
          if (lesson.room != "")
            Detail(
                title: "Room".i18n,
                description: lesson.room.replaceAll("_", " ")),
          if (lesson.description != "")
            Detail(title: "Description".i18n, description: lesson.description),
          if (lesson.lessonYearIndex != null)
            Detail(
                title: "Lesson Number".i18n,
                description: "${lesson.lessonYearIndex}."),
          if (lesson.groupName != "")
            Detail(title: "Group".i18n, description: lesson.groupName),
        ],
      ),
    );
  }

  static show(Lesson lesson, {required BuildContext context}) {
    showBottomCard(context: context, child: LessonView(lesson));
  }
}
