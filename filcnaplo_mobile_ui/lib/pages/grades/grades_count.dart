import 'package:flutter/material.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grades_count_item.dart';
import 'package:collection/collection.dart';

class GradesCount extends StatelessWidget {
  const GradesCount({Key? key, required this.grades}) : super(key: key);

  final List<Grade> grades;

  @override
  Widget build(BuildContext context) {
    List<int> gradesCount = List.generate(5, (int index) => grades.where((e) => e.value.value == index + 1).length);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 6.0, left: 12.0, right: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: gradesCount.mapIndexed((index, e) => GradesCountItem(count: e, value: index + 1)).toList(),
      ),
    );
  }
}
