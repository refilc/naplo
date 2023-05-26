import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_card.dart';
import 'package:filcnaplo_mobile_ui/common/detail.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'grade_view.i18n.dart';

class GradeView extends StatelessWidget {
  const GradeView(this.grade, {Key? key}) : super(key: key);

  static show(Grade grade, {required BuildContext context}) => showBottomCard(context: context, child: GradeView(grade));

  final Grade grade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: GradeValueWidget(grade.value, fill: true),
            title: Text(
              grade.subject.renamedTo ?? grade.subject.name.capital(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600, fontStyle: grade.subject.isRenamed ? FontStyle.italic : null),
            ),
            subtitle: Text(
              !Provider.of<SettingsProvider>(context, listen: false).presentationMode ? grade.teacher : "Tanár",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              grade.date.format(context),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Grade Details
          Detail(
            title: "value".i18n,
            description: "${grade.value.valueName} " + percentText(),
          ),
          if (grade.description != "") Detail(title: "description".i18n, description: grade.description),
          if (grade.mode.description != "") Detail(title: "mode".i18n, description: grade.mode.description),
          if (grade.writeDate.year != 0) Detail(title: "date".i18n, description: grade.writeDate.format(context)),
        ],
      ),
    );
  }

  String percentText() => grade.value.weight != 100 && grade.value.weight > 0 ? "${grade.value.weight}%" : "";
}
