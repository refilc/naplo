import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Absence> providerAbsences, {bool noExcused = false}) {
  List<DateWidget> items = [];
  providerAbsences.where((a) => !noExcused || a.state != Justification.excused).forEach((absence) {
    items.add(DateWidget(
      key: absence.id,
      date: absence.date,
      widget: mobile.AbsenceViewable(absence),
    ));
  });
  return items;
}
