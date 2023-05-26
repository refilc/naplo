import 'package:filcnaplo_premium/ui/mobile/goal_planner/goal_input.dart';
import 'package:flutter/material.dart';

class GradeDisplay extends StatelessWidget {
  const GradeDisplay({Key? key, required this.grade}) : super(key: key);

  final int grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gradeColor(grade).withOpacity(.3),
      ),
      child: Center(
        child: Text(
          grade.toInt().toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: gradeColor(grade),
          ),
        ),
      ),
    );
  }
}
