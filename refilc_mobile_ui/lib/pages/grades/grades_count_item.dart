import 'package:flutter/widgets.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:refilc_mobile_ui/common/progress_bar.dart';

class GradesCountItem extends StatelessWidget {
  const GradesCountItem({
    super.key,
    required this.count,
    required this.value,
    required this.total,
  });

  final int count;
  final int value;
  final double total;

  @override
  Widget build(BuildContext context) {
    // return Row(
    //   children: [
    //     Text.rich(
    //       TextSpan(children: [
    //         TextSpan(
    //           text: count.toString(),
    //           style: const TextStyle(fontWeight: FontWeight.w600),
    //         ),
    //         const TextSpan(
    //           text: "x",
    //           style: TextStyle(fontSize: 13.0),
    //         ),
    //       ]),
    //       style: const TextStyle(fontSize: 15.0),
    //     ),
    //     const SizedBox(width: 3.0),
    //     GradeValueWidget(GradeValue(value, "Value", "Value", 100),
    //         size: 18.0, fill: true, shadow: false),
    //   ],
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GradeValueWidget(
          GradeValue(value, "Value", "Value", 100),
          size: 18.0,
          fill: true,
          shadow: false,
        ),
        const SizedBox(
          width: 12.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: ProgressBar(
            value: (count / total),
            backgroundColor: gradeColor(
              context: context,
              value: value,
              nocolor: false,
            ),
            height: 10.0,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        SizedBox(
          width: 22.0,
          child: Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}
