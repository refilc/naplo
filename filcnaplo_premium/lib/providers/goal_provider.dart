import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:flutter/widgets.dart';

class GoalProvider extends ChangeNotifier {
  final DatabaseProvider _db;
  final UserProvider _user;
  final GradeProvider _gradeProvider;

  late bool _done = false;
  late Subject _doneSubject;

  bool get hasDoneGoals => _done;
  Subject get doneSubject => _doneSubject;

  GoalProvider({
    required DatabaseProvider database,
    required UserProvider user,
    required GradeProvider gradeProvider,
  })  : _db = database,
        _user = user,
        _gradeProvider = gradeProvider;

  Future<void> fetchDone() async {
    var goalAvgs = await _db.userQuery.subjectGoalAverages(userId: _user.id!);
    var beforeAvgs = await _db.userQuery.subjectGoalAverages(userId: _user.id!);

    List<Subject> subjects = _gradeProvider.grades
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
}
