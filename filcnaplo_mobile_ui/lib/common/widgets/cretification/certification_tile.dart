import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/utils/format.dart';
import 'certification_tile.i18n.dart';

class CertificationTile extends StatelessWidget {
  const CertificationTile(this.grade, {Key? key, this.onTap, this.padding}) : super(key: key);

  final Function()? onTap;
  final Grade grade;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    bool isSubjectView = SubjectGradesContainer.of(context) != null;
    String certificationName;

    switch (grade.type) {
      case GradeType.endYear:
        certificationName = "final".i18n;
        break;
      case GradeType.halfYear:
        certificationName = "mid".i18n;
        break;
      case GradeType.firstQ:
        certificationName = "1q".i18n;
        break;
      case GradeType.secondQ:
        certificationName = "2q".i18n;
        break;
      case GradeType.thirdQ:
        certificationName = "3q".i18n;
        break;
      case GradeType.fourthQ:
        certificationName = "4q".i18n;
        break;
      case GradeType.levelExam:
        certificationName = "equivalency".i18n;
        break;
      case GradeType.unknown:
      default:
        certificationName = "unknown".i18n;
    }

    return Material(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding:
              isSubjectView ? const EdgeInsets.only(left: 12.0, right: 12.0, top: 2.0, bottom: 8.0) : const EdgeInsets.only(left: 8.0, right: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onTap: onTap,
          leading: isSubjectView
              ? GradeValueWidget(
                  grade.value,
                  complemented: grade.description == 'Dicséret',
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Icon(SubjectIcon.resolveVariant(subject: grade.subject, context: context),
                      size: 28.0, color: AppColors.of(context).text.withOpacity(.75)),
                ),
          minLeadingWidth: isSubjectView ? 32.0 : 42.0,
          trailing: isSubjectView
              ? const Icon(FeatherIcons.award)
              : GradeValueWidget(
                  grade.value,
                  complemented: grade.description == 'Dicséret',
                ),
          title: Text(isSubjectView ? certificationName : grade.subject.renamedTo ?? grade.subject.name.capital(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0, fontStyle: grade.subject.isRenamed ? FontStyle.italic : null)),
          subtitle: Text(grade.value.valueName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
        ),
      ),
    );
  }
}
