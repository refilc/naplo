import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:flutter/widgets.dart';

class GoalProvider extends ChangeNotifier {
  final DatabaseProvider _db;
  final UserProvider _user;

  late bool _done = false;
  late GradeSubject? _doneSubject;

  bool get hasDoneGoals => _done;
  GradeSubject? get doneSubject => _doneSubject;

  GoalProvider({
    required DatabaseProvider database,
    required UserProvider user,
  })  : _db = database,
        _user = user;

  Future<void> fetchDone({required GradeProvider gradeProvider}) async {
    var goalAvgs = await _db.userQuery.subjectGoalAverages(userId: _user.id!);
    var beforeAvgs = await _db.userQuery.subjectGoalBefores(userId: _user.id!);

    List<GradeSubject> subjects = gradeProvider.grades
        .map((e) => e.subject)
        .toSet()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    goalAvgs.forEach((k, v) {
      if (beforeAvgs[k] == v) {
        _done = true;
        _doneSubject = subjects.where((e) => e.id == k).toList()[0];

        notifyListeners();
      }
    });
  }

  void lock() {
    _done = false;
    _doneSubject = null;
  }

  Future<void> clearGoal(GradeSubject subject) async {
    final goalPlans = await _db.userQuery.subjectGoalPlans(userId: _user.id!);
    final goalAvgs = await _db.userQuery.subjectGoalAverages(userId: _user.id!);
    final goalBeforeGrades =
        await _db.userQuery.subjectGoalBefores(userId: _user.id!);
    final goalPinDates =
        await _db.userQuery.subjectGoalPinDates(userId: _user.id!);

    goalPlans.remove(subject.id);
    goalAvgs.remove(subject.id);
    goalBeforeGrades.remove(subject.id);
    goalPinDates.remove(subject.id);

    await _db.userStore.storeSubjectGoalPlans(goalPlans, userId: _user.id!);
    await _db.userStore.storeSubjectGoalAverages(goalAvgs, userId: _user.id!);
    await _db.userStore
        .storeSubjectGoalBefores(goalBeforeGrades, userId: _user.id!);
    await _db.userStore
        .storeSubjectGoalPinDates(goalPinDates, userId: _user.id!);
  }
}
