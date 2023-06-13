import 'dart:math';
import 'dart:ui';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/helpers/notification_helper.i18n.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {
  @pragma('vm:entry-point')
  void backgroundJob() async {
    // initialize providers
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    DatabaseProvider database = DatabaseProvider();
    await database.init();
    SettingsProvider settingsProvider =
        await database.query.getSettings(database);
    UserProvider userProvider = await database.query.getUsers(settingsProvider);

    if (userProvider.id != null && settingsProvider.notificationsEnabled) {
      // refresh grades
      final status = StatusProvider();
      final kretaClient = KretaClient(
          user: userProvider, settings: settingsProvider, status: status);
      kretaClient.refreshLogin();
      GradeProvider gradeProvider = GradeProvider(
          settings: settingsProvider,
          user: userProvider,
          database: database,
          kreta: kretaClient);
      gradeProvider.fetch();
      List<Grade> grades =
          await database.userQuery.getGrades(userId: userProvider.id ?? "");
      DateTime lastSeenGrade =
          await database.userQuery.lastSeenGrade(userId: userProvider.id ?? "");

      // loop through grades and see which hasn't been seen yet
      for (Grade grade in grades) {
        // if the grade was added over a week ago, don't show it to avoid notification spam
        if (grade.seenDate.isAfter(lastSeenGrade) &&
            grade.date.difference(DateTime.now()).inDays * -1 < 7) {
          // send notificiation about new grade
          const AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails('GRADES', 'Jegyek',
                  channelDescription: 'Értesítés jegyek beírásakor',
                  importance: Importance.max,
                  priority: Priority.max,
                  color: Color(0xFF3D7BF4),
                  ticker: 'Jegyek');
          const NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          await flutterLocalNotificationsPlugin.show(
              // probably shouldn't use a random int
              Random().nextInt(432234 * 2),
              "title".i18n,
              "body".i18n.fill([
                grade.value.value.toString(),
                grade.subject.isRenamed &&
                        settingsProvider.renamedSubjectsEnabled
                    ? grade.subject.renamedTo!
                    : grade.subject.name
              ]),
              notificationDetails);
        }
      }
      // set grade seen status
      gradeProvider.seenAll();
    }
  }
}
