import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:refilc/utils/format.dart';
import 'package:provider/provider.dart';
import 'missed_exam_tile.i18n.dart';

class MissedExamView extends StatelessWidget {
  const MissedExamView(this.missedExams, {super.key});

  final List<Lesson> missedExams;

  static show(List<Lesson> missedExams, {required BuildContext context}) =>
      showRoundedModalBottomSheet(context, child: MissedExamView(missedExams));

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = missedExams.map((e) => MissedExamViewTile(e)).toList();
    return Column(children: tiles);
  }
}

class MissedExamViewTile extends StatelessWidget {
  const MissedExamViewTile(this.lesson, {super.key, this.padding});

  final EdgeInsetsGeometry? padding;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    String? teacherName = lesson.teacher.isRenamed
        ? lesson.teacher.renamedTo
        : lesson.teacher.name;

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          leading: Icon(
            SubjectIcon.resolveVariant(
                subject: lesson.subject, context: context),
            color: AppColors.of(context).text.withOpacity(.8),
            size: 32.0,
          ),
          title: Text(
            "${lesson.subject.renamedTo ?? lesson.subject.name.capital()} • ${lesson.date.format(context)}",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: lesson.subject.isRenamed &&
                        settingsProvider.renamedSubjectsItalics
                    ? FontStyle.italic
                    : null),
          ),
          subtitle: Text(
            "missed_exam_contact".i18n.fill([teacherName ?? '']),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(FeatherIcons.arrowRight),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            TimetablePage.jump(context, lesson: lesson);
          },
        ),
      ),
    );
  }
}
