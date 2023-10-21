/* 
 * Maintainer: DarK
 * Translated from C version
 * Minimal Working Fixed @ 2022.12.25
 * ##Please do NOT modify if you don't know whats going on##
 * 
 * Issue: #59
 * 
 * Future changes / ideas:
 *  - `best` should be configurable
 */
import 'dart:math';
import 'package:filcnaplo_kreta_api/models/category.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/teacher.dart';
import 'package:flutter/foundation.dart' show listEquals;

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

  void _generate(Generator g) {
    // Exit condition 1: Generator has working plan.
    if (g.currentAvg.avg >= goal) {
      plans.add(Plan(g.plan));
      return;
    }
    // Exit condition 2: Generator plan will never work.
    if (!_allowed(g.gradeToAdd)) {
      return;
    }

    for (int i = g.max; i >= 0; i--) {
      int newGradeToAdd = g.gradeToAdd - 1;
      List<int> newPlan =
          GoalPlannerHelper._addToList<int>(g.plan, g.gradeToAdd, i);

      Avg newAvg = GoalPlannerHelper._addToAvg(g.currentAvg, g.gradeToAdd, i);
      int newN = GoalPlannerHelper.howManyNeeded(
          newGradeToAdd,
          grades +
              newPlan
                  .map((e) => Grade(
                        id: '',
                        date: DateTime(0),
                        value: GradeValue(e, '', '', 100),
                        teacher: Teacher.fromString(''),
                        description: '',
                        form: '',
                        groupId: '',
                        type: GradeType.midYear,
                        subject: GradeSubject.fromJson({}),
                        mode: Category.fromJson({}),
                        seenDate: DateTime(0),
                        writeDate: DateTime(0),
                      ))
                  .toList(),
          goal);

      _generate(Generator(newGradeToAdd, newN, newAvg, newPlan));
    }
  }

  List<Plan> solve() {
    _generate(
      Generator(
        5,
        GoalPlannerHelper.howManyNeeded(
          5,
          grades,
          goal,
        ),
        Avg(GoalPlannerHelper.averageEvals(grades),
            GoalPlannerHelper.weightSum(grades)),
        [],
      ),
    );

    // Calculate Statistics
    for (var e in plans) {
      e.sum = e.plan.fold(0, (int a, b) => a + b);
      e.avg = e.sum / e.plan.length;
      e.sigma = sqrt(
          e.plan.map((i) => pow(i - e.avg, 2)).fold(0, (num a, b) => a + b) /
              e.plan.length);
    }

    // filter without aggression
    if (plans.where((e) => e.plan.length < 30).isNotEmpty) {
      plans.removeWhere((e) => !(e.plan.length < 30));
    }
    if (plans.where((e) => e.sigma > 1).isNotEmpty) {
      plans.removeWhere((e) => !(e.sigma > 1));
    }

    return plans;
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

  String get dbString {
    var finalString = '';
    for (var i in plan) {
      finalString += "$i,";
    }
    return finalString;
  }

  @override
  bool operator ==(other) => other is Plan && listEquals(plan, other.plan);

  @override
  int get hashCode => Object.hashAll(plan);
}

class GoalPlannerHelper {
  static Avg _addToAvg(Avg base, int grade, int n) =>
      Avg((base.avg * base.n + grade * n) / (base.n + n), base.n + n);

  static List<T> _addToList<T>(List<T> l, T e, int n) {
    if (n == 0) return l;
    List<T> tmp = l;
    for (int i = 0; i < n; i++) {
      tmp = tmp + [e];
    }
    return tmp;
  }

  static int howManyNeeded(int grade, List<Grade> base, double goal) {
    double avg = averageEvals(base);
    double wsum = weightSum(base);
    if (avg >= goal) return 0;
    if (grade * 1.0 == goal) return -1;
    int candidate = (wsum * (avg - goal) / (goal - grade)).floor();
    return (candidate * grade + avg * wsum) / (candidate + wsum) < goal
        ? candidate + 1
        : candidate;
  }

  static double averageEvals(List<Grade> grades, {bool finalAvg = false}) {
    double average = grades
            .map((e) => e.value.value * e.value.weight / 100.0)
            .fold(0.0, (double a, double b) => a + b) /
        weightSum(grades, finalAvg: finalAvg);
    return average.isNaN ? 0.0 : average;
  }

  static double weightSum(List<Grade> grades, {bool finalAvg = false}) => grades
      .map((e) => finalAvg ? 1 : e.value.weight / 100)
      .fold(0, (a, b) => a + b);
}
