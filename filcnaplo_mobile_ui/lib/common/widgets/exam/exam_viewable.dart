import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:filcnaplo_mobile_ui/common/viewable.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/card_handle.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam/exam_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam/exam_view.dart';
import 'package:flutter/material.dart';

class ExamViewable extends StatelessWidget {
  const ExamViewable(this.exam, {Key? key}) : super(key: key);

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Viewable(
      tile: ExamTile(exam),
      view: CardHandle(child: ExamView(exam)),
    );
  }
}
