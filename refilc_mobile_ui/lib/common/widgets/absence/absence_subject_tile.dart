import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
import 'package:refilc_mobile_ui/common/widgets/absence/absence_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AbsenceSubjectTile extends StatelessWidget {
  const AbsenceSubjectTile(
    this.subject, {
    super.key,
    this.percentage = 0.0,
    this.excused = 0,
    this.unexcused = 0,
    this.pending = 0,
    this.onTap,
  });

  final GradeSubject subject;
  final void Function()? onTap;
  final double percentage;

  final int excused;
  final int unexcused;
  final int pending;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Material(
      type: MaterialType.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          // minLeadingWidth: 32.0,
          dense: true,
          contentPadding: const EdgeInsets.only(left: 12.0, right: 12.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          visualDensity: VisualDensity.compact,
          onTap: onTap,
          leading: RoundBorderIcon(
            padding: 8.0,
            icon: Icon(
              SubjectIcon.resolveVariant(subject: subject, context: context),
              size: 20.0,
            ),
          ),
          title: Text(
            subject.renamedTo ?? subject.name.capital(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                fontStyle:
                    subject.isRenamed && settingsProvider.renamedSubjectsItalics
                        ? FontStyle.italic
                        : null),
          ),
          subtitle: AbsenceDisplay(excused, unexcused, pending),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8.0),
              if (percentage >= 0)
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    const Opacity(
                        opacity: 0,
                        child: Text("100%",
                            style: TextStyle(fontFamily: "monospace"))),
                    Text(
                      "${percentage.round()}%",
                      style: TextStyle(
                        // fontFamily: "monospace",
                        color:
                            getColorByPercentage(percentage, context: context)
                                .withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Color getColorByPercentage(double percentage, {required BuildContext context}) {
  Color color = AppColors.of(context).text;

  percentage = percentage.round().toDouble();

  if (percentage > 35) {
    color = AppColors.of(context).red;
  } else if (percentage > 25) {
    color = AppColors.of(context).orange;
  } else if (percentage > 15) {
    color = AppColors.of(context).yellow;
  }

  return color.withOpacity(.8);
}
