import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/missed_exam/missed_exam_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/missed_exam/missed_exam_view.dart';
import 'package:flutter/material.dart';

class MissedExamViewable extends StatelessWidget {
  const MissedExamViewable(this.missedExams, {Key? key}) : super(key: key);

  final List<Lesson> missedExams;

  @override
  Widget build(BuildContext context) {
    return MissedExamTile(
      missedExams,
      onTap: () => MissedExamView.show(missedExams, context: context),
    );
  }
}
