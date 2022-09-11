import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework/homework_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Homework> providerHomework) {
  List<DateWidget> items = [];
  final now = DateTime.now();
  providerHomework.where((h) => h.deadline.hour == 0 ? _sameDate(h.deadline, now) : h.deadline.isAfter(now)).forEach((homework) {
    items.add(DateWidget(
      key: homework.id,
      date: homework.deadline.year != 0 ? homework.deadline : homework.date,
      widget: mobile.HomeworkViewable(homework),
    ));
  });
  return items;
}

bool _sameDate(DateTime a, DateTime b) => (a.year == b.year && a.month == b.month && a.day == b.day);
