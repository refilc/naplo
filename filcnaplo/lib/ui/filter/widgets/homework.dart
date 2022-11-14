import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Homework> providerHomework) {
  List<DateWidget> items = [];
  for (var homework in providerHomework) {
    items.add(DateWidget(
      key: homework.id,
      date: homework.deadline.year != 0 ? homework.deadline : homework.date,
      widget: mobile.HomeworkViewable(homework),
    ));
  }
  return items;
}
