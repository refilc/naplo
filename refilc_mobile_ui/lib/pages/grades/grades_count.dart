import 'package:flutter/material.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_mobile_ui/pages/grades/grades_count_item.dart';
import 'package:collection/collection.dart';

class GradesCount extends StatelessWidget {
  const GradesCount({super.key, required this.grades});

  final List<Grade> grades;

  @override
  Widget build(BuildContext context) {
    List<int> gradesCount = List.generate(5,
        (int index) => grades.where((e) => e.value.value == index + 1).length);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: make a new widget here, cuz this will not fit
            // Text.rich(
            //   TextSpan(children: [
            //     TextSpan(
            //       text: gradesCount.reduce((a, b) => a + b).toString(),
            //       style: const TextStyle(fontWeight: FontWeight.w600),
            //     ),
            //     const TextSpan(
            //       text: "x",
            //       style: TextStyle(
            //         fontSize: 13.0,
            //       ),
            //     ),
            //   ]),
            //   style: const TextStyle(fontSize: 15.0),
            // ),
            // const SizedBox(
            //   width: 10.0,
            // ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10.0),
            //   child: VerticalDivider(
            //     width: 2,
            //     thickness: 2,
            //     indent: 2,
            //     endIndent: 2,
            //     color: MediaQuery.of(context).platformBrightness ==
            //             Brightness.light
            //         ? Colors.grey.shade300
            //         : Colors.grey.shade700,
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: gradesCount
                  .mapIndexed((index, e) => Padding(
                      padding: const EdgeInsets.only(left: 9.69),
                      child: GradesCountItem(count: e, value: index + 1)))
                  .toList(),
            ),
            const SizedBox(
              width: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}
