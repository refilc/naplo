import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_mobile_ui/common/average_display.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradeSubjectTile extends StatelessWidget {
  const GradeSubjectTile(this.subject,
      {super.key,
      this.average = 0.0,
      this.groupAverage = 0.0,
      this.onTap,
      this.averageBefore = 0.0});

  final GradeSubject subject;
  final void Function()? onTap;
  final double average;
  final double groupAverage;
  final double averageBefore;
  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.of(context).text;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    // Failing indicator
    if (average < 2.0 && average >= 1.0) {
      textColor = AppColors.of(context).red;
    }

    final String changeIcon = average < averageBefore ? "▼" : "▲";
    final Color changeColor = average < averageBefore
        ? Colors.redAccent
        : Colors.lightGreenAccent.shade700;

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        minLeadingWidth: 32.0,
        dense: true,
        contentPadding: const EdgeInsets.only(left: 8.0, right: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: RoundBorderIcon(
          icon: Icon(
            SubjectIcon.resolveVariant(
              context: context,
              subject: subject,
            ),
            size: 22.0,
            weight: 2.5,
          ),
          padding: 5.0,
          width: 1.0,
        ),
        title: Text(
          subject.renamedTo ?? subject.name.capital(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: textColor,
              fontStyle:
                  settingsProvider.renamedSubjectsItalics && subject.isRenamed
                      ? FontStyle.italic
                      : null),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (groupAverage != 0 && averageBefore == 0.0)
              AverageDisplay(average: groupAverage, border: true),
            const SizedBox(width: 6.0),
            if (averageBefore != 0.0 && averageBefore != average) ...[
              AverageDisplay(average: averageBefore),
              Padding(
                padding:
                    const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 3.5),
                child: Text(
                  changeIcon,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 20.0,
                  ),
                ),
              )
            ],
            AverageDisplay(average: average)
          ],
        ),
      ),
    );
  }
}
