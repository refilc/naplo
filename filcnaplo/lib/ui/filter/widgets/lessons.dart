import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson/changed_lesson_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Lesson> providerLessons) {
  List<DateWidget> items = [];
  providerLessons.where((l) => l.isChanged && l.start.isAfter(DateTime.now())).forEach((lesson) {
    items.add(DateWidget(
      key: lesson.id,
      date: DateTime(lesson.date.year, lesson.date.month, lesson.date.day, lesson.start.hour, lesson.start.minute),
      widget: mobile.ChangedLessonViewable(lesson),
    ));
  });
  return items;
}
