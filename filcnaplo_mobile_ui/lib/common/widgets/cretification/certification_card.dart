import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/cretification/certification_view.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'certification_card.i18n.dart';

class CertificationCard extends StatelessWidget {
  const CertificationCard(this.grades, {Key? key, required this.gradeType, this.padding}) : super(key: key);

  final List<Grade> grades;
  final GradeType gradeType;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    String title = getGradeTypeTitle(gradeType);
    double average = AverageHelper.averageEvals(grades, finalAvg: true);
    String averageText = average.toStringAsFixed(1);
    if (I18n.of(context).locale.languageCode != "en") averageText = averageText.replaceAll(".", ",");
    Color color = gradeColor(context: context, value: average);
    Color textColor;

    if (color.computeLuminance() >= .5) {
      textColor = Colors.black;
    } else {
      textColor = Colors.white;
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            colors: [color, color.withOpacity(.75)],
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(12.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            leading: Text(
              averageText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            title: Text.rich(
              TextSpan(
                text: title,
                children: [
                  TextSpan(
                    text: " • ${grades.length}",
                    style: TextStyle(
                      color: textColor.withOpacity(.75),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
            trailing: Icon(FeatherIcons.arrowRight, color: textColor),
            onTap: () => CertificationView.show(grades, context: context, gradeType: gradeType),
          ),
        ),
      ),
    );
  }
}

String getGradeTypeTitle(GradeType gradeType) {
  String title;

  switch (gradeType) {
    case GradeType.halfYear:
      title = "mid".i18n;
      break;
    case GradeType.firstQ:
      title = "1q".i18n;
      break;
    case GradeType.secondQ:
      title = "2q".i18n;
      break;
    case GradeType.thirdQ:
      title = "3q".i18n;
      break;
    case GradeType.fourthQ:
      title = "4q".i18n;
      break;
    default:
      title = "final".i18n;
  }

  return title;
}
