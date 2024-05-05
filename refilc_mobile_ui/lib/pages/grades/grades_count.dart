import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_mobile_ui/pages/grades/grades_count_item.dart';
import 'package:collection/collection.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'grades_page.i18n.dart';

class GradesCount extends StatelessWidget {
  const GradesCount({super.key, required this.grades});

  final List<Grade> grades;

  @override
  Widget build(BuildContext context) {
    List<int> gradesCount = List.generate(5,
        (int index) => grades.where((e) => e.value.value == index + 1).length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: RoundedExpansionTile(
        tileColor: Colors.transparent,
        childrenPadding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -4),
        duration: const Duration(milliseconds: 250),
        trailingDuration: 0.5,
        trailing: const Icon(FeatherIcons.chevronDown),
        title: Text(
          'grades_cnt'.i18n.fill([
            gradesCount.reduce((a, b) => a + b).toString(),
          ]),
          style: const TextStyle(
            height: 1.0,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: gradesCount
            .mapIndexed(
              (index, e) => Padding(
                padding: const EdgeInsets.only(bottom: 7.0, left: 4.0),
                child: GradesCountItem(
                  count: e,
                  value: index + 1,
                  total:
                      gradesCount.reduce(max) + (gradesCount.reduce(max) / 5),
                ),
              ),
            )
            .toList()
            .reversed
            .toList(),
      ),
    );
  }
}
