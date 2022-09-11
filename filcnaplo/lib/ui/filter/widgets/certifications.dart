import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/cretification/certification_card.dart' as mobile;

List<DateWidget> getWidgets(List<Grade> providerGrades) {
  List<DateWidget> items = [];
  for (var gradeType in GradeType.values) {
    if ([GradeType.midYear, GradeType.unknown, GradeType.levelExam].contains(gradeType)) continue;

    List<Grade> grades = providerGrades.where((grade) => grade.type == gradeType).toList();
    if (grades.isNotEmpty) {
      grades.sort((a, b) => -a.date.compareTo(b.date));

      items.add(DateWidget(
        date: grades.first.date,
        widget: mobile.CertificationCard(
          grades,
          gradeType: gradeType,
        ),
      ));
    }
  }
  return items;
}
