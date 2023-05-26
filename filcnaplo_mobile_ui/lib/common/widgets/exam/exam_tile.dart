import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ExamTile extends StatelessWidget {
  const ExamTile(this.exam, {Key? key, this.onTap, this.padding}) : super(key: key);

  final Exam exam;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          leading: SizedBox(
              width: 44,
              height: 44,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  SubjectIcon.resolveVariant(subjectName: exam.subjectName, context: context),
                  size: 28.0,
                  color: AppColors.of(context).text.withOpacity(.75),
                ),
              )),
          title: Text(
            exam.description != "" ? exam.description : (exam.mode?.description ?? "Számonkérés"),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            exam.subjectName.capital(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Icon(
            FeatherIcons.edit,
            color: AppColors.of(context).text.withOpacity(.75),
          ),
          minLeadingWidth: 0,
        ),
      ),
    );
  }
}
