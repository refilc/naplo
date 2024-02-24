import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_mobile_ui/common/viewable.dart';
import 'package:refilc_mobile_ui/common/widgets/card_handle.dart';
import 'package:refilc_mobile_ui/common/widgets/exam/exam_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/exam/exam_view.dart';
import 'package:flutter/material.dart';

class ExamViewable extends StatelessWidget {
  const ExamViewable(this.exam,
      {super.key, this.showSubject = true, this.tilePadding});

  final Exam exam;
  final bool showSubject;
  final EdgeInsetsGeometry? tilePadding;

  @override
  Widget build(BuildContext context) {
    return Viewable(
      tile: ExamTile(
        exam,
        showSubject: showSubject,
        padding: tilePadding,
      ),
      view: CardHandle(child: ExamView(exam)),
    );
  }
}
