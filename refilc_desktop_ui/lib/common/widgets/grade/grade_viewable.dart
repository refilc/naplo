import 'package:flutter/material.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';

class GradeViewable extends StatelessWidget {
  const GradeViewable(this.grade, {Key? key}) : super(key: key);

  final Grade grade;

  @override
  Widget build(BuildContext context) {
    return GradeTile(grade);
  }
}
