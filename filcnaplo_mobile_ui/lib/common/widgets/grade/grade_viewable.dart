import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/card_handle.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/grade_view.dart';
import 'package:filcnaplo_mobile_ui/common/viewable.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:flutter/material.dart';

class GradeViewable extends StatelessWidget {
  const GradeViewable(this.grade, {Key? key, this.padding}) : super(key: key);

  final Grade grade;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final subject = SubjectGradesContainer.of(context) != null;
    final tile = GradeTile(grade, padding: subject ? EdgeInsets.zero : padding);

    return Viewable(
      tile: subject ? SubjectGradesContainer(child: tile) : tile,
      view: CardHandle(child: GradeView(grade)),
    );
  }
}
