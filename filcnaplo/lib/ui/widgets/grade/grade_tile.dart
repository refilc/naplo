import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class GradeTile extends StatelessWidget {
  const GradeTile(this.grade,
      {Key? key, this.onTap, this.padding, this.censored = false})
      : super(key: key);

  final Grade grade;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final bool censored;

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    bool isTitleItalic = false;
    bool isSubtitleItalic = false;
    EdgeInsets leadingPadding = EdgeInsets.zero;
    bool isSubjectView = SubjectGradesContainer.of(context) != null;
    String subjectName =
        grade.subject.renamedTo ?? grade.subject.name.capital();
    String modeDescription = grade.mode.description.capital();
    String description = grade.description.capital();

    GradeCalculatorProvider calculatorProvider =
        Provider.of<GradeCalculatorProvider>(context, listen: false);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    // Test order:
    // description
    // mode
    // value name
    if (grade.type == GradeType.midYear || grade.type == GradeType.ghost) {
      if (grade.description != "") {
        title = description;
      } else {
        title = modeDescription != ""
            ? modeDescription
            : grade.value.valueName.split("(")[0];
      }
    } else {
      title = subjectName;
      isTitleItalic =
          grade.subject.isRenamed && settingsProvider.renamedSubjectsItalics;
    }

    // Test order:
    // subject name
    // mode + weight != 100
    if (grade.type == GradeType.midYear) {
      subtitle = isSubjectView
          ? description != ""
              ? modeDescription
              : ""
          : subjectName;
      isSubtitleItalic = isSubjectView
          ? false
          : grade.subject.isRenamed && settingsProvider.renamedSubjectsItalics;
    } else {
      subtitle = grade.value.valueName.split("(")[0];
    }

    if (subtitle != "") leadingPadding = const EdgeInsets.only(top: 2.0);

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: isSubjectView
              ? grade.type != GradeType.ghost
                  ? const EdgeInsets.symmetric(horizontal: 12.0)
                  : const EdgeInsets.only(left: 12.0, right: 4.0)
              : const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: onTap,
          // onLongPress: kDebugMode ? () => log(jsonEncode(grade.json)) : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          leading: isSubjectView
              ? GradeValueWidget(grade.value)
              : SizedBox(
                  width: 44,
                  height: 44,
                  child: censored
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColors.of(context).text,
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: leadingPadding,
                            child: Icon(
                              SubjectIcon.resolveVariant(
                                  subject: grade.subject, context: context),
                              size: 28.0,
                              color: AppColors.of(context).text,
                            ),
                          ),
                        ),
                ),
          title: censored
              ? Wrap(
                  children: [
                    Container(
                      width: 110,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                )
              : Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: isTitleItalic ? FontStyle.italic : null),
                ),
          subtitle: subtitle != ""
              ? censored
                  ? Wrap(
                      children: [
                        Container(
                          width: 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.of(context).text,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              isSubtitleItalic ? FontStyle.italic : null),
                    )
              : null,
          trailing: isSubjectView
              ? grade.type != GradeType.ghost
                  ? Text(grade.date.format(context),
                      style: const TextStyle(fontWeight: FontWeight.w500))
                  : IconButton(
                      splashRadius: 24.0,
                      icon: Icon(FeatherIcons.trash2,
                          color: AppColors.of(context).red),
                      onPressed: () {
                        calculatorProvider.removeGrade(grade);
                      },
                    )
              : censored
                  ? Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: AppColors.of(context).text,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )
                  : GradeValueWidget(grade.value),
          minLeadingWidth: isSubjectView ? 32.0 : 0,
        ),
      ),
    );
  }
}

class GradeValueWidget extends StatelessWidget {
  const GradeValueWidget(
    this.value, {
    Key? key,
    this.size = 38.0,
    this.fill = false,
    this.contrast = false,
    this.shadow = false,
    this.outline = false,
    this.complemented = false,
    this.nocolor = false,
    this.color,
  }) : super(key: key);

  final GradeValue value;
  final double size;
  final bool fill;
  final bool contrast;
  final bool shadow;
  final bool outline;
  final bool complemented;
  final bool nocolor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    GradeValue value = this.value;
    bool isSubjectView = SubjectGradesContainer.of(context) != null;

    Color color = this.color ??
        gradeColor(context: context, value: value.value, nocolor: nocolor);
    Widget valueText;
    final percentage = value.percentage;

    if (percentage) {
      double multiplier = 1.0;

      if (isSubjectView) multiplier = 0.75;

      valueText = Text.rich(
        TextSpan(
          text: value.value.toString(),
          children: [
            TextSpan(
              text: "\n%",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: size / 2.5 * multiplier,
                  height: 0.7),
            ),
          ],
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: size / 1 * multiplier,
              height: 1),
        ),
        textAlign: TextAlign.center,
      );
    } else if (value.valueName.toLowerCase().specialChars() == 'nem irt') {
      valueText = const Icon(FeatherIcons.slash);
    } else {
      valueText = Stack(alignment: Alignment.topRight, children: [
        Transform.translate(
          offset: (value.weight >= 200) ? const Offset(2, 1.5) : Offset.zero,
          child: Text(
            value.value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight:
                  value.weight == 50 ? FontWeight.w500 : FontWeight.bold,
              fontSize: size,
              color: contrast ? Colors.white : color,
              shadows: [
                if (value.weight >= 200)
                  Shadow(
                    color: (contrast ? Colors.white : color).withOpacity(.4),
                    offset: const Offset(-4, -3),
                  )
              ],
            ),
          ),
        ),
        if (complemented)
          Transform.translate(
            offset: const Offset(9, 1),
            child: Text(
              "*",
              style:
                  TextStyle(fontSize: size / 1.6, fontWeight: FontWeight.bold),
            ),
          ),
      ]);
    }

    return fill
        ? Container(
            width: size * 1.4,
            height: size * 1.4,
            decoration: BoxDecoration(
              color: color.withOpacity(contrast ? 1.0 : .25),
              shape: BoxShape.circle,
              boxShadow: [
                if (shadow &&
                    Provider.of<SettingsProvider>(context, listen: false)
                        .shadowEffect)
                  BoxShadow(
                    color: color,
                    blurRadius: 62.0,
                  )
              ],
            ),
            child: Center(child: valueText),
          )
        : valueText;
  }
}

Color gradeColor(
    {required BuildContext context, required num value, bool nocolor = false}) {
  int valueInt = 0;

  var settings = Provider.of<SettingsProvider>(context, listen: false);

  try {
    if (value < 2.0) {
      valueInt = 1;
    } else {
      if (value >= value.floor() + settings.rounding / 10) {
        valueInt = value.ceil();
      } else {
        valueInt = value.floor();
      }
    }
  } catch (_) {}

  if (nocolor) return AppColors.of(context).text;

  switch (valueInt) {
    case 5:
      return settings.gradeColors[4];
    case 4:
      return settings.gradeColors[3];
    case 3:
      return settings.gradeColors[2];
    case 2:
      return settings.gradeColors[1];
    case 1:
      return settings.gradeColors[0];
    default:
      return AppColors.of(context).text;
  }
}
