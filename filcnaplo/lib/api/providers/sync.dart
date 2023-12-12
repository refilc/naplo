// ignore_for_file: use_build_context_synchronously

import 'dart:io';

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
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:home_widget/home_widget.dart';

// Mutex
bool lock = false;

Future<void> syncAll(BuildContext context) {
  if (lock) return Future.value();
  // Lock
  lock = true;

  // ignore: avoid_print
  print("INFO Syncing all");

  UserProvider user = Provider.of<UserProvider>(context, listen: false);
  StatusProvider statusProvider =
      Provider.of<StatusProvider>(context, listen: false);

  List<Future<void>> tasks = [];
  int taski = 0;

  Future<void> syncStatus(Future<void> future) async {
    await future.onError((error, stackTrace) => null);
    taski++;
    statusProvider.triggerSync(current: taski, max: tasks.length);
  }

  tasks = [
    syncStatus(Provider.of<GradeProvider>(context, listen: false).fetch()),
    syncStatus(Provider.of<TimetableProvider>(context, listen: false)
        .fetch(week: Week.current())),
    syncStatus(Provider.of<ExamProvider>(context, listen: false).fetch()),
    syncStatus(Provider.of<HomeworkProvider>(context, listen: false)
        .fetch(from: DateTime.now().subtract(const Duration(days: 30)))),
    syncStatus(Provider.of<MessageProvider>(context, listen: false).fetchAll()),
    syncStatus(
        Provider.of<MessageProvider>(context, listen: false).fetchAllRecipients()),
    syncStatus(Provider.of<NoteProvider>(context, listen: false).fetch()),
    syncStatus(Provider.of<EventProvider>(context, listen: false).fetch()),
    syncStatus(Provider.of<AbsenceProvider>(context, listen: false).fetch()),

    // Sync student
    syncStatus(() async {
      if (user.user == null) return;
      Map? studentJson = await Provider.of<KretaClient>(context, listen: false)
          .getAPI(KretaAPI.student(user.instituteCode!));
      if (studentJson == null) return;
      Student student = Student.fromJson(studentJson);

      user.user?.name = student.name;

      // Store user
      await Provider.of<DatabaseProvider>(context, listen: false)
          .store
          .storeUser(user.user!);
    }()),
  ];

  Future<bool?> updateWidget() async {
    try {
      return HomeWidget.updateWidget(name: 'widget_timetable.WidgetTimetable');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
    return false;
  }

  return Future.wait(tasks).then((value) {
    // Unlock
    lock = false;

    // Update Widget
    if (Platform.isAndroid) updateWidget();
  });
}
