import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// Mutex
bool lock = false;

Future<void> syncAll(BuildContext context) {
  if (lock) return Future.value();
  // Lock
  lock = true;

  print("INFO Syncing all");

  UserProvider user = Provider.of<UserProvider>(context, listen: false);
  StatusProvider statusProvider = Provider.of<StatusProvider>(context, listen: false);

  List<Future<void>> tasks = [];
  int taski = 0;

  Future<void> _syncStatus(Future<void> future) async {
    await future.onError((error, stackTrace) => null);
    taski++;
    statusProvider.triggerSync(current: taski, max: tasks.length);
  }

  tasks = [
    _syncStatus(Provider.of<GradeProvider>(context, listen: false).fetch()),
    _syncStatus(Provider.of<TimetableProvider>(context, listen: false).fetch(week: Week.current())),
    _syncStatus(Provider.of<ExamProvider>(context, listen: false).fetch()),
    _syncStatus(Provider.of<HomeworkProvider>(context, listen: false).fetch(from: DateTime.now().subtract(Duration(days: 30)))),
    _syncStatus(Provider.of<MessageProvider>(context, listen: false).fetchAll()),
    _syncStatus(Provider.of<NoteProvider>(context, listen: false).fetch()),
    _syncStatus(Provider.of<EventProvider>(context, listen: false).fetch()),
    _syncStatus(Provider.of<AbsenceProvider>(context, listen: false).fetch()),

    // Sync student
    _syncStatus(() async {
      if (user.user == null) return;
      Map? studentJson = await Provider.of<KretaClient>(context, listen: false).getAPI(KretaAPI.student(user.instituteCode!));
      if (studentJson == null) return;
      Student student = Student.fromJson(studentJson);

      user.user?.name = student.name;

      // Store user
      await Provider.of<DatabaseProvider>(context, listen: false).store.storeUser(user.user!);
    }()),
  ];

  return Future.wait(tasks)
      // Unlock
      .then((value) => lock = false);
}
