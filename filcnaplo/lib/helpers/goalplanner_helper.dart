/* 
 * Maintainer: DarK
 * Translated from C version
 * ##Please do NOT modify if you don't know whats going on##
 * 
 * Issue: #59
 * 
 * Future changes / ideas:
 *  - `best` should be configurable
 */
import 'dart:math';

import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';

/// Generate list of grades that achieve the wanted goal.
/// After generating possible options, it (when doing so would NOT result in empty list) filters with two criteria:
///  - Plan should not contain more than 15 grades
///  - Plan should not contain only one type of grade
///
/// **Usage**:
///
/// ```dart
/// List<int> GoalPlanner(double goal, List<Grade> grades).solve().plan
/// ```
class GoalPlanner {
  final double goal;
  final List<Grade> grades;
  List<Plan> plans = [];
  GoalPlanner(this.goal, this.grades);

  bool _allowed(int grade) => grade > goal;

  Avg _addToAvg(Avg base, int grade, int n) => Avg((base.avg * base.n + grade * n) / (base.n + n), base.n + n);
  List<T> _addToList<T>(List<T> l, T e, int n) {
    if (n == 0) return l;
    List<T> tmp = l;
    for (int i = 0; i < n; i++) tmp.add(e);
    return tmp;
  }

  void _generate(Generator g) {
    // Exit condition 1: Generator has working plan.
    if (g.currentAvg.avg >= goal) {
      plans.add(Plan(g.plan));
      return;
    }
    // Exit condition 2: Generator plan will never work.
    if (!_allowed(g.gradeToAdd)) return;
    for (int i = 0; i < g.max; i++) {
      int newGradeToAdd = g.gradeToAdd - 1;
      List<int> newPlan = _addToList<int>(g.plan, g.gradeToAdd, i);
      Avg newAvg = _addToAvg(g.currentAvg, g.gradeToAdd, i);
      int newN = AverageHelper.howManyNeeded(newGradeToAdd, [], goal);

      _generate(Generator(newGradeToAdd, newN, newAvg, newPlan));
    }
  }

  Plan solve() {
    _generate(
      Generator(
        5,
        AverageHelper.howManyNeeded(
          5,
          [],
          goal,
          filcgrade: false,
          avg: AverageHelper.averageEvals(grades),
          wsum: AverageHelper.weightSum(grades),
        ),
        Avg(AverageHelper.averageEvals(grades), AverageHelper.weightSum(grades)),
        [],
      ),
    );

    // Calculate Statistics
    plans.forEach((e) {
      e.sum = e.plan.fold(0, (int a, b) => a + b);
      e.avg = e.sum / e.plan.length;
      e.sigma = sqrt(e.plan.map((i) => pow(i - e.avg, 2)).fold(0, (num a, b) => a + b) / e.plan.length);
    });

    // filter without aggression
    if (plans.where((e) => e.plan.length < 15).isNotEmpty) plans.removeWhere((e) => !(e.plan.length < 15));
    if (plans.where((e) => e.sigma > 1).isNotEmpty) plans.removeWhere((e) => !(e.sigma > 1));

    return plans[Random().nextInt(plans.length)];
  }
}

class Avg {
  final double avg;
  final double n;

  Avg(this.avg, this.n);
}

class Generator {
  final int gradeToAdd;
  final int max;
  final Avg currentAvg;
  final List<int> plan;

  Generator(this.gradeToAdd, this.max, this.currentAvg, this.plan);
}

class Plan {
  final List<int> plan;
  int sum = 0;
  double avg = 0;
  int med = 0; // currently
  int mod = 0; // unused
  double sigma = 0;

  Plan(this.plan);
}
