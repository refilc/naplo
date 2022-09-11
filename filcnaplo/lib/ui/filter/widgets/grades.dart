import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo/utils/platform.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/grade_viewable.dart' as mobile;
import 'package:filcnaplo_desktop_ui/common/widgets/grade/grade_viewable.dart' as desktop;

List<DateWidget> getWidgets(List<Grade> providerGrades) {
  List<DateWidget> items = [];
  for (var grade in providerGrades) {
    if (grade.type == GradeType.midYear) {
      items.add(DateWidget(
        key: grade.id,
        date: grade.date,
        widget: PlatformUtils.isMobile ? mobile.GradeViewable(grade) : desktop.GradeViewable(grade),
      ));
    }
  }
  return items;
}
