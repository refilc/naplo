import 'package:flutter/material.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'missed_exam_tile.i18n.dart';

class MissedExamTile extends StatelessWidget {
  const MissedExamTile(this.missedExams, {Key? key, this.onTap, this.padding}) : super(key: key);

  final List<Lesson> missedExams;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      child: PanelButton(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        leading: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              FeatherIcons.slash,
              color: AppColors.of(context).red.withOpacity(.75),
              size: 28.0,
            )),
        title: Text("missed_exams".plural(missedExams.length).fill([missedExams.length])),
        trailing: const Icon(FeatherIcons.arrowRight),
        onPressed: onTap,
      ),
    );
  }
}
