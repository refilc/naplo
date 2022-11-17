// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:filcnaplo_kreta_api/models/grade.dart';

class AverageHelper {
  static double averageEvals(List<Grade> grades, {bool finalAvg = false}) {
    List<String> ignoreInFinal = ["5,SzorgalomErtek", "4,MagatartasErtek"];
    if (finalAvg) grades.removeWhere((e) => (e.value.value == 0) || (ignoreInFinal.contains(e.gradeType?.id)));

    double average =
        grades.map((e) => e.value.value * e.value.weight / 100.0).fold(0.0, (double a, double b) => a + b) / weightSum(grades, finalAvg: finalAvg);
    return average.isNaN ? 0.0 : average;
  }

  static double weightSum(List<Grade> grades, {bool finalAvg = false}) =>
      grades.map((e) => finalAvg ? 1 : e.value.weight / 100).fold(0, (a, b) => a + b);

  static int howManyNeeded(int grade, List<Grade> base, double goal, {bool filcgrade = true, double avg = 0, double wsum = 0}) {
    double _avg = filcgrade ? averageEvals(base) : avg;
    double _wsum = filcgrade ? weightSum(base) : wsum;
    if (_avg >= goal) return 0;
    return (_wsum * (_avg - goal) / (goal - grade)).ceil();
  }
}
