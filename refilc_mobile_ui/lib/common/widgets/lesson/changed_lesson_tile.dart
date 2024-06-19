import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:refilc/utils/format.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'changed_lesson_tile.i18n.dart';

class ChangedLessonTile extends StatelessWidget {
  const ChangedLessonTile(this.lesson, {super.key, this.onTap, this.padding});

  final Lesson lesson;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    String lessonIndexTrailing = "";

    // Only put a trailing . if its a digit
    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    Color accent = Theme.of(context).colorScheme.secondary;

    if (lesson.substituteTeacher?.name != '') {
      accent = AppColors.of(context).yellow;
    }

    if (lesson.status?.name == "Elmaradt") {
      accent = AppColors.of(context).red;
    }

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: onTap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
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
            lesson.status?.name == "Elmaradt" &&
                    lesson.substituteTeacher?.name != ""
                ? "cancelled".i18n
                : "substituted".i18n,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            lesson.subject.renamedTo ?? lesson.subject.name.capital(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: lesson.subject.isRenamed &&
                        settingsProvider.renamedSubjectsItalics
                    ? FontStyle.italic
                    : null),
          ),
          trailing: const Icon(FeatherIcons.arrowRight),
          minLeadingWidth: 0,
        ),
      ),
    );
  }
}
