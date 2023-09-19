import 'package:refilc/utils/format.dart';
import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_mobile_ui/common/widgets/missed_exam/missed_exam_viewable.dart';

List<DateWidget> getWidgets(List<Lesson> providerLessons) {
  List<DateWidget> items = [];
  List<Lesson> missedExams = [];

  for (var lesson in providerLessons) {
    final desc = lesson.description.toLowerCase().specialChars();
    // Check if lesson description includes hints for an exam written during the lesson
    if (!lesson.studentPresence &&
        (lesson.exam != "" ||
            desc.contains("dolgozat") ||
            desc.contains("feleles") ||
            desc.contains("temazaro") ||
            desc.contains("szamonkeres") ||
            desc == "tz") &&
        !(desc.contains("felkeszules") || desc.contains("gyakorlas"))) {
      missedExams.add(lesson);
    }
  }

  if (missedExams.isNotEmpty) {
    missedExams.sort((a, b) => -a.date.compareTo(b.date));

    items.add(DateWidget(
      date: missedExams.first.date,
      widget: MissedExamViewable(missedExams),
    ));
  }

  return items;
}
