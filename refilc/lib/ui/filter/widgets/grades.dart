import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_mobile_ui/common/widgets/grade/grade_viewable.dart'
    as mobile;
import 'package:refilc_mobile_ui/common/widgets/grade/new_grades.dart'
    as mobile;

List<DateWidget> getWidgets(
    List<Grade> providerGrades, DateTime? lastSeenDate) {
  List<DateWidget> items = [];
  for (var grade in providerGrades) {
    final surprise =
        (!(lastSeenDate != null && grade.date.isAfter(lastSeenDate)) ||
            grade.value.value == 0);
    if (grade.type == GradeType.midYear && surprise) {
      items.add(DateWidget(
        key: grade.id,
        date: grade.date,
        widget: mobile.GradeViewable(grade),
      ));
    }
  }
  return items;
}

List<DateWidget> getNewWidgets(
    List<Grade> providerGrades, DateTime? lastSeenDate) {
  List<DateWidget> items = [];
  List<Grade> newGrades = [];
  for (var grade in providerGrades) {
    final surprise =
        !(lastSeenDate != null && !grade.date.isAfter(lastSeenDate)) &&
            grade.value.value != 0 &&
            grade.value.weight != 0;
    if (grade.type == GradeType.midYear && surprise) {
      newGrades.add(grade);
    }
  }
  newGrades.sort((a, b) => a.date.compareTo(b.date));
  if (newGrades.isNotEmpty) {
    items.add(DateWidget(
      key: newGrades.last.id,
      date: newGrades.last.date,
      widget: mobile.NewGradesSurprise(newGrades),
    ));
  }
  return items;
}
