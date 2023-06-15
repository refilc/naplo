import 'dart:ui';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/helpers/notification_helper.i18n.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class NotificationsHelper {
  late DatabaseProvider database;
  late SettingsProvider settingsProvider;
  late UserProvider userProvider;
  late KretaClient kretaClient;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @pragma('vm:entry-point')
  void backgroundJob() async {
    // initialize providers
    database = DatabaseProvider();
    await database.init();
    settingsProvider =
        await database.query.getSettings(database);
    userProvider = await database.query.getUsers(settingsProvider);

    if (userProvider.id != null && settingsProvider.notificationsEnabled) {
      // refresh kreta login
      final status = StatusProvider();
      kretaClient = KretaClient(
          user: userProvider, settings: settingsProvider, status: status);
      kretaClient.refreshLogin();
      gradeNotification();
      absenceNotification();
    }
  }
  
  void gradeNotification() async {
    // fetch grades
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
        if (grade.seenDate.isAfter(lastSeenGrade) && grade.date.difference(DateTime.now()).inDays * -1 < 7) {
          // send notificiation about new grade
          const AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails('GRADES', 'Jegyek',
                  channelDescription: 'Értesítés jegyek beírásakor',
                  importance: Importance.max,
                  priority: Priority.max,
                  color: const Color(0xFF3D7BF4),
                  ticker: 'Jegyek');
          const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
          if(userProvider.getUsers().length == 1) {
          await flutterLocalNotificationsPlugin.show(
              grade.id.hashCode,
              "title_grade".i18n,
              "body_grade".i18n.fill([
                grade.value.value.toString(),
                grade.subject.isRenamed &&
                        settingsProvider.renamedSubjectsEnabled
                    ? grade.subject.renamedTo!
                    : grade.subject.name
              ]),
              notificationDetails);
        } else { // multiple users are added, also display student name
          await flutterLocalNotificationsPlugin.show(
              grade.id.hashCode,
              "title_grade".i18n,
              "body_grade_multiuser".i18n.fill([
                userProvider.displayName!,
                grade.value.value.toString(),
                grade.subject.isRenamed &&
                        settingsProvider.renamedSubjectsEnabled
                    ? grade.subject.renamedTo!
                    : grade.subject.name
              ]),
              notificationDetails);
        }
        } 
      }
      // set grade seen status
      gradeProvider.seenAll();
  }
  void absenceNotification() async {
    List? absenceJson = await kretaClient.getAPI(KretaAPI.absences(userProvider.instituteCode ?? ""));
    List<Absence> storedAbsences = await database.userQuery.getAbsences(userId: userProvider.id!);
    if(absenceJson == null) {
      return;
    }
    List<Absence> absences = absenceJson.map((e) => Absence.fromJson(e)).toList();
    if(absences != storedAbsences) {
      absences.removeWhere((element) => storedAbsences.contains(element));
      for(Absence absence in absences) {
        const AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails('ABSENCES', 'Hiányzások',
                  channelDescription: 'Értesítés hiányzások beírásakor',
                  importance: Importance.max,
                  priority: Priority.max,
                  color: const Color(0xFF3D7BF4),
                  ticker: 'Hiányzások');
          const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
          if(userProvider.getUsers().length == 1) {
          await flutterLocalNotificationsPlugin.show(
              absence.id.hashCode,
              "title_absence".i18n,
              "body_absence".i18n.fill([
                DateFormat("yyyy-MM-dd").format(absence.date),
                absence.subject.isRenamed &&
                        settingsProvider.renamedSubjectsEnabled
                    ? absence.subject.renamedTo!
                    : absence.subject.name
              ]),
              notificationDetails);
        } else {
          await flutterLocalNotificationsPlugin.show(
              absence.id.hashCode,
              "title_absence".i18n,
              "body_absence_multiuser".i18n.fill([
                userProvider.displayName!,
                DateFormat("yyyy-MM-dd").format(absence.date),
                absence.subject.isRenamed &&
                        settingsProvider.renamedSubjectsEnabled
                    ? absence.subject.renamedTo!
                    : absence.subject.name
              ]),
              notificationDetails);
        }
      }
    }
  }
}
