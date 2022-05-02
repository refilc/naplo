import 'package:filcnaplo_kreta_api/models/category.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';

enum SubjectLessonCountUpdateState { ready, updating }

class SubjectLessonCount {
  DateTime lastUpdated;
  Map<Subject, int> subjects;
  SubjectLessonCountUpdateState state;

  SubjectLessonCount({required this.lastUpdated, required this.subjects, this.state = SubjectLessonCountUpdateState.ready});

  factory SubjectLessonCount.fromMap(Map json) {
    return SubjectLessonCount(
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(json["last_updated"] ?? 0),
      subjects: ((json["subjects"] as Map?) ?? {}).map(
        (key, value) => MapEntry(
          Subject(id: key, name: "", category: Category.fromJson({})),
          value,
        ),
      ),
    );
  }

  Map toMap() {
    return {
      "last_updated": lastUpdated.millisecondsSinceEpoch,
      "subjects": subjects.map((key, value) => MapEntry(key.id, value)),
    };
  }
}
