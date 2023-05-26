import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_display.dart';
import 'package:flutter/material.dart';

class AbsenceSubjectTile extends StatelessWidget {
  const AbsenceSubjectTile(this.subject, {Key? key, this.percentage = 0.0, this.excused = 0, this.unexcused = 0, this.pending = 0, this.onTap})
      : super(key: key);

  final Subject subject;
  final void Function()? onTap;
  final double percentage;

  final int excused;
  final int unexcused;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        // minLeadingWidth: 32.0,
        dense: true,
        contentPadding: const EdgeInsets.only(left: 8.0, right: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: Icon(SubjectIcon.resolveVariant(subject: subject, context: context), size: 32.0),
        title: Text(
          subject.renamedTo ?? subject.name.capital(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0, fontStyle: subject.isRenamed ? FontStyle.italic : null),
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
                  const Opacity(child: Text("100%", style: TextStyle(fontFamily: "monospace")), opacity: 0),
                  Text(
                    percentage.round().toString() + "%",
                    style: TextStyle(
                      // fontFamily: "monospace",
                      color: getColorByPercentage(percentage, context: context),
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
          ],
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
