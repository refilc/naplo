import 'package:filcnaplo_kreta_api/models/grade.dart';

class AverageHelper {
  static double averageEvals(List<Grade> grades, {bool finalAvg = false}) {
    double average = 0.0;

    List<String> ignoreInFinal = ["5,SzorgalomErtek", "4,MagatartasErtek"];

    if (finalAvg) {
      grades.removeWhere((e) => (e.value.value == 0) || (ignoreInFinal.contains(e.gradeType?.id)));
    }

    for (var e in grades) {
      average += e.value.value * ((finalAvg ? 100 : e.value.weight) / 100);
    }

    average = average / grades.map((e) => (finalAvg ? 100 : e.value.weight) / 100).fold(0.0, (a, b) => a + b);

    return average.isNaN ? 0.0 : average;
  }
}
