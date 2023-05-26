import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'changed_lesson_tile.i18n.dart';

class ChangedLessonTile extends StatelessWidget {
  const ChangedLessonTile(this.lesson, {Key? key, this.onTap, this.padding}) : super(key: key);

  final Lesson lesson;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    String lessonIndexTrailing = "";

    // Only put a trailing . if its a digit
    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    Color accent = Theme.of(context).colorScheme.secondary;

    if (lesson.substituteTeacher != "") {
      accent = AppColors.of(context).yellow;
    }

    if (lesson.status?.name == "Elmaradt") {
      accent = AppColors.of(context).red;
    }

    return Material(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(14.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          leading: SizedBox(
            width: 44.0,
            height: 44.0,
            child: Center(
              child: Text(
                lesson.lessonIndex + lessonIndexTrailing,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ),
          ),
          title: Text(
            lesson.substituteTeacher != "" ? "substituted".i18n : "cancelled".i18n,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            lesson.subject.renamedTo ?? lesson.subject.name.capital(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500, fontStyle: lesson.subject.isRenamed ? FontStyle.italic : null),
          ),
          trailing: const Icon(FeatherIcons.arrowRight),
          minLeadingWidth: 0,
        ),
      ),
    );
  }
}
