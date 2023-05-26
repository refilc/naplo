import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';

class GradeCalculatorProvider extends GradeProvider {
  GradeCalculatorProvider({
    List<Grade> initialGrades = const [],
    required SettingsProvider settings,
    required UserProvider user,
    required DatabaseProvider database,
    required KretaClient kreta,
  }) : super(
          initialGrades: initialGrades,
          settings: settings,
          database: database,
          kreta: kreta,
          user: user,
        );

  List<Grade> _grades = [];
  List<Grade> _ghosts = [];
  @override
  List<Grade> get grades => _grades + _ghosts;
  List<Grade> get ghosts => _ghosts;

  void addGhost(Grade grade) {
    _ghosts.add(grade);
    notifyListeners();
  }

  void addGrade(Grade grade) {
    _grades.add(grade);
    notifyListeners();
  }

  void removeGrade(Grade ghost) {
    _ghosts.removeWhere((e) => ghost.id == e.id);
    notifyListeners();
  }

  void addAllGrades(List<Grade> grades) {
    _grades.addAll(grades);
    notifyListeners();
  }

  void clear() {
    _grades = [];
    _ghosts = [];
  }
}
