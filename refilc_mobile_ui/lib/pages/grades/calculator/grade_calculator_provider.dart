// import 'package:refilc/api/providers/database_provider.dart';
// import 'package:refilc/api/providers/user_provider.dart';
// import 'package:refilc/models/settings.dart';
// import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_kreta_api/models/grade.dart';

class GradeCalculatorProvider extends GradeProvider {
  GradeCalculatorProvider({
    super.initialGrades,
    required super.settings,
    required super.user,
    required super.database,
    required super.kreta,
  });

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
