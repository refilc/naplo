import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'grades_page.i18n.dart';

class FailWarning extends StatelessWidget {
  const FailWarning({Key? key, required this.subjectAvgs}) : super(key: key);

  final Map<Subject, double> subjectAvgs;

  @override
  Widget build(BuildContext context) {
    final failingSubjectCount = subjectAvgs.values.where((avg) => avg < 2.0).length;

    if (failingSubjectCount == 0) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Panel(
        title: Text("fail_warning".i18n),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              FeatherIcons.alertTriangle,
              color: Colors.orange.withOpacity(.5),
              size: 20.0,
            ),
            const SizedBox(width: 12.0),
            Text("fail_warning_description".i18n.fill([failingSubjectCount])),
          ],
        ),
      ),
    );
  }
}
