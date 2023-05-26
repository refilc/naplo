import 'package:flutter/material.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_desktop_ui/pages/grades/grades_count_item.dart';
import 'package:collection/collection.dart';

class GradesCount extends StatelessWidget {
  const GradesCount({Key? key, required this.grades}) : super(key: key);

  final List<Grade> grades;

  @override
  Widget build(BuildContext context) {
    List<int> gradesCount = List.generate(5, (int index) => grades.where((e) => e.value.value == index + 1).length);

    return Container(
      width: 75,
      padding: const EdgeInsets.only(bottom: 6.0, top: 6.0, left: 12.0, right: 0.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: gradesCount.mapIndexed((index, e) => GradesCountItem(count: e, value: index + 1)).toList(),
      ),
    );
  }
}
