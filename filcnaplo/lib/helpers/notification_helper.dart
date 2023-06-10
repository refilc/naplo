import 'dart:math';
import 'dart:ui';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/database/init.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/helpers/notification_helper.i18n.dart';
import 'package:filcnaplo/theme/colors/accent.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/category.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {
  void backgroundJob() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    DatabaseProvider database = DatabaseProvider();
    var db = await initDB(database);
    await database.init();
    SettingsProvider settingsProvider =
        await database.query.getSettings(database);
    UserProvider userProvider = await database.query.getUsers(settingsProvider);
    if(userProvider.id != null) {
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
    for (Grade grade in grades) {
      if (grade.seenDate.isAfter(lastSeenGrade)) {
        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails('GRADES', 'Jegyek',
                channelDescription: 'Értesítés jegyek beírásakor',
                importance: Importance.max,
                priority: Priority.max,
                color: const Color(0xFF3D7BF4),
                ticker: 'ticker');
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            Random().nextInt(432234*2), "title".i18n, "body".i18n.fill([grade.value.value.toString(), grade.subject.name.toString()]), notificationDetails);
      }
    }
    gradeProvider.seenAll();
    }
  }
}
