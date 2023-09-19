import 'package:refilc/helpers/subject.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_mobile_ui/common/bottom_card.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_mobile_ui/common/detail.dart';
import 'package:flutter/material.dart';
import 'exam_view.i18n.dart';

class ExamView extends StatelessWidget {
  const ExamView(this.exam, {Key? key}) : super(key: key);

  final Exam exam;

  static show(Exam exam, {required BuildContext context}) =>
      showBottomCard(context: context, child: ExamView(exam));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Icon(
                SubjectIcon.resolveVariant(
                    subjectName: exam.subjectName, context: context),
                size: 36.0,
                color: AppColors.of(context).text.withOpacity(.75),
              ),
            ),
            title: Text(
              exam.subjectName.capital(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              (exam.teacher.isRenamed
                      ? exam.teacher.renamedTo
                      : exam.teacher.name) ??
                  '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              exam.date.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Details
          if (exam.writeDate.year != 0)
            Detail(
                title: "date".i18n,
                description: exam.writeDate.format(context)),
          if (exam.description != "")
            Detail(title: "description".i18n, description: exam.description),
          if (exam.mode != null)
            Detail(title: "mode".i18n, description: exam.mode!.description),
        ],
      ),
    );
  }
}
