// import 'package:flutter/foundation.dart';
// import 'package:refilc/api/providers/database_provider.dart';
// import 'package:refilc/api/providers/status_provider.dart';
// import 'package:refilc/api/providers/user_provider.dart';
// import 'package:refilc/models/settings.dart';
// import 'package:refilc/helpers/notification_helper.i18n.dart';
// import 'package:refilc/models/user.dart';
// import 'package:refilc/utils/navigation_service.dart';
// import 'package:refilc/utils/service_locator.dart';
// import 'package:refilc_kreta_api/client/api.dart';
// import 'package:refilc_kreta_api/client/client.dart';
// import 'package:refilc_kreta_api/models/absence.dart';
// import 'package:refilc_kreta_api/models/grade.dart';
// import 'package:refilc_kreta_api/models/lesson.dart';
// import 'package:refilc_kreta_api/models/week.dart';
// import 'package:refilc_kreta_api/providers/grade_provider.dart';
// import 'package:refilc_kreta_api/providers/timetable_provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'
//     hide Message;
// import 'package:i18n_extension/i18n_extension.dart';
// import 'package:intl/intl.dart';
// import 'package:refilc_kreta_api/models/message.dart';

// if you want to add a new category, also add it to the DB or else the app will probably crash
enum LastSeenCategory {
  grade,
  surprisegrade,
  absence,
  message,
  lesson
} // didn't know a better place for this

// class NotificationsHelper {
//   late DatabaseProvider database;
//   late SettingsProvider settingsProvider;
//   late UserProvider userProvider;
//   late KretaClient kretaClient;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   String dayTitle(DateTime date) {
//     try {
//       String dayTitle =
//           DateFormat("EEEE", I18n.locale.languageCode).format(date);
//       dayTitle = dayTitle[0].toUpperCase() +
//           dayTitle.substring(1); // capitalize string
//       return dayTitle;
//     } catch (e) {
//       return "Unknown";
//     }
//   }

//   @pragma('vm:entry-point')
//   void backgroundJob() async {
//     // initialize providers
//     database = DatabaseProvider();
//     await database.init();
//     settingsProvider = await database.query.getSettings(database);
//     userProvider = await database.query.getUsers(settingsProvider);

//     if (userProvider.id != null && settingsProvider.notificationsEnabled) {
//       List<User> users = userProvider.getUsers();

//       // Process notifications for each user asynchronously
//       await Future.forEach(users, (User user) async {
//         // Create a new instance of userProvider for each user
//         UserProvider userProviderForUser =
//             await database.query.getUsers(settingsProvider);
//         userProviderForUser.setUser(user.id);

//         // Refresh kreta login for current user
//         final status = StatusProvider();
//         KretaClient kretaClientForUser = KretaClient(
//           user: userProviderForUser,
//           settings: settingsProvider,
//           database: database,
//           status: status,
//         );
//         await kretaClientForUser.refreshLogin();

//         // Process notifications for current user
//         if (settingsProvider.notificationsGradesEnabled) {
//           await gradeNotification(userProviderForUser, kretaClientForUser);
//         }
//         if (settingsProvider.notificationsAbsencesEnabled) {
//           await absenceNotification(userProviderForUser, kretaClientForUser);
//         }
//         if (settingsProvider.notificationsMessagesEnabled) {
//           await messageNotification(userProviderForUser, kretaClientForUser);
//         }
//         if (settingsProvider.notificationsLessonsEnabled) {
//           await lessonNotification(userProviderForUser, kretaClientForUser);
//         }
//       });
//     }
//   }

// /*

// ezt a kódot nagyon szépen megírta az AI, picit szerkesztgettem is rajta //pearoo what did you do - zypherift
// nem lesz tőle használhatatlan az app, de kikommenteltem, mert még a végén kima bántani fog

//    Future<void> liveNotification(UserProvider currentuserProvider, KretaClient currentKretaClient) async {
//     // create a permanent live notification that has a progress bar on how much is left from the current lesson, the title is the name of the class
//     // get current lesson
//     TimetableProvider timetableProvider = TimetableProvider(
//         user: currentuserProvider,
//         database: database,
//         kreta: currentKretaClient);
//     await timetableProvider.restoreUser();
//     await timetableProvider.fetch(week: Week.current());
//     List<Lesson> apilessons = timetableProvider.getWeek(Week.current()) ?? [];
//     Lesson? currentLesson;
//     for (Lesson lesson in apilessons) {
//       if (lesson.date.isBefore(DateTime.now()) &&
//           lesson.end.isAfter(DateTime.now())) {
//         currentLesson = lesson;
//         break;
//       }
//     }
//     if (currentLesson == null) {
//       return;
//     }
//         final elapsedTime = DateTime.now()
//                 .difference(currentLesson.start)
//                 .inSeconds
//                 .toDouble();
//         final maxTime = currentLesson.end
//             .difference(currentLesson.start)
//             .inSeconds
//             .toDouble();

//         final showMinutes = maxTime - elapsedTime > 60;
//     // create a live notification
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'LIVE',
//       'Élő óra',
//       channelDescription: 'Értesítés az aktuális óráról',
//       importance: Importance.max,
//       priority: Priority.max,
//       color: settingsProvider.customAccentColor,
//       ticker: 'Élő óra',
//       maxProgress: maxTime.toInt(),
//       progress: elapsedTime.toInt(),
//     );
//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//       currentLesson.id.hashCode,
//       currentLesson.name,
//       "body_live".i18n.fill(
//         [
//           currentLesson.lessonIndex,
//           currentLesson.name,
//           dayTitle(currentLesson.date),
//           DateFormat("HH:mm").format(currentLesson.start),
//           DateFormat("HH:mm").format(currentLesson.end),
//         ],
//       ),
//       notificationDetails,
//       payload: "timetable",
//     );

//   }
//  */
//   Future<void> gradeNotification(
//       UserProvider currentuserProvider, KretaClient currentKretaClient) async {
//     // fetch grades
//     GradeProvider gradeProvider = GradeProvider(
//         settings: settingsProvider,
//         user: currentuserProvider,
//         database: database,
//         kreta: currentKretaClient);
//     await gradeProvider.fetch();
//     database.userQuery
//         .getGrades(userId: currentuserProvider.id!)
//         .then((grades) async {
//       DateTime lastSeenGrade = await database.userQuery.lastSeen(
//           userId: currentuserProvider.id!, category: LastSeenCategory.grade);

//       // loop through grades and see which hasn't been seen yet
//       for (Grade grade in grades) {
//         // if grade is not a normal grade (1-5), don't show it
//         if ([1, 2, 3, 4, 5].contains(grade.value.value)) {
//           // if the grade was added over a week ago, don't show it to avoid notification spam
//           if (grade.date.isAfter(lastSeenGrade) &&
//               DateTime.now().difference(grade.date).inDays < 7) {
//             // send notificiation about new grade
//             AndroidNotificationDetails androidNotificationDetails =
//                 AndroidNotificationDetails(
//               'GRADES',
//               'Jegyek',
//               channelDescription: 'Értesítés jegyek beírásakor',
//               importance: Importance.max,
//               priority: Priority.max,
//               color: settingsProvider.customAccentColor,
//               ticker: 'Jegyek',
//             );
//             NotificationDetails notificationDetails =
//                 NotificationDetails(android: androidNotificationDetails);
//             if (currentuserProvider.getUsers().length == 1) {
//               await flutterLocalNotificationsPlugin.show(
//                   grade.id.hashCode,
//                   "title_grade".i18n,
//                   "body_grade".i18n.fill(
//                     [
//                       grade.subject.isRenamed &&
//                               settingsProvider.renamedSubjectsEnabled
//                           ? grade.subject.renamedTo!
//                           : grade.subject.name,
//                       grade.value.value.toString()
//                     ],
//                   ),
//                   notificationDetails,
//                   payload: "grades");
//             } else if (settingsProvider.gradeOpeningFun) {
//               // if surprise grades are enabled, show a notification without the grade
//               await flutterLocalNotificationsPlugin.show(
//                   grade.id.hashCode,
//                   "title_grade".i18n,
//                   "body_grade_surprise".i18n.fill(
//                     [
//                       grade.subject.isRenamed &&
//                               settingsProvider.renamedSubjectsEnabled
//                           ? grade.subject.renamedTo!
//                           : grade.subject.name,
//                       grade.value.value.toString()
//                     ],
//                   ),
//                   notificationDetails,
//                   payload: "grades");
//             } else {
//               // multiple users are added, also display student name
//               await flutterLocalNotificationsPlugin.show(
//                   grade.id.hashCode,
//                   "title_grade".i18n,
//                   "body_grade_multiuser".i18n.fill(
//                     [
//                       currentuserProvider.displayName!,
//                       grade.subject.isRenamed &&
//                               settingsProvider.renamedSubjectsEnabled
//                           ? grade.subject.renamedTo!
//                           : grade.subject.name,
//                       grade.value.value.toString()
//                     ],
//                   ),
//                   notificationDetails,
//                   payload: "grades");
//             }
//           }
//         }
//       }
//       // set grade seen status
//       database.userStore.storeLastSeen(DateTime.now(),
//           userId: currentuserProvider.id!, category: LastSeenCategory.grade);
//     });
//   }

//   Future<void> absenceNotification(
//       UserProvider currentuserProvider, KretaClient currentKretaClient) async {
//     // get absences from api
//     List? absenceJson = await currentKretaClient
//         .getAPI(KretaAPI.absences(currentuserProvider.instituteCode ?? ""));
//     if (absenceJson == null) {
//       return;
//     }
//     DateTime lastSeenAbsence = await database.userQuery.lastSeen(
//         userId: currentuserProvider.id!, category: LastSeenCategory.absence);
//     // format api absences
//     List<Absence> absences =
//         absenceJson.map((e) => Absence.fromJson(e)).toList();
//     for (Absence absence in absences) {
//       if (absence.date.isAfter(lastSeenAbsence)) {
//         AndroidNotificationDetails androidNotificationDetails =
//             AndroidNotificationDetails(
//           'ABSENCES',
//           'Hiányzások',
//           channelDescription: 'Értesítés hiányzások beírásakor',
//           importance: Importance.max,
//           priority: Priority.max,
//           color: settingsProvider.customAccentColor,
//           ticker: 'Hiányzások',
//         );
//         NotificationDetails notificationDetails =
//             NotificationDetails(android: androidNotificationDetails);
//         if (currentuserProvider.getUsers().length == 1) {
//           await flutterLocalNotificationsPlugin.show(
//               absence.id.hashCode,
//               "title_absence"
//                   .i18n, // https://discord.com/channels/1111649116020285532/1153273625206591528
//               "body_absence".i18n.fill(
//                 [
//                   DateFormat("yyyy-MM-dd").format(absence.date),
//                   absence.subject.isRenamed &&
//                           settingsProvider.renamedSubjectsEnabled
//                       ? absence.subject.renamedTo!
//                       : absence.subject.name
//                 ],
//               ),
//               notificationDetails,
//               payload: "absences");
//         } else {
//           await flutterLocalNotificationsPlugin.show(
//               absence.id.hashCode,
//               "title_absence"
//                   .i18n, // https://discord.com/channels/1111649116020285532/1153273625206591528
//               "body_absence_multiuser".i18n.fill(
//                 [
//                   currentuserProvider.displayName!,
//                   DateFormat("yyyy-MM-dd").format(absence.date),
//                   absence.subject.isRenamed &&
//                           settingsProvider.renamedSubjectsEnabled
//                       ? absence.subject.renamedTo!
//                       : absence.subject.name
//                 ],
//               ),
//               notificationDetails,
//               payload: "absences");
//         }
//       }
//     }
//     await database.userStore.storeLastSeen(DateTime.now(),
//         userId: currentuserProvider.id!, category: LastSeenCategory.absence);
//   }

//   Future<void> messageNotification(
//       UserProvider currentuserProvider, KretaClient currentKretaClient) async {
//     // get messages from api
//     List? messageJson =
//         await currentKretaClient.getAPI(KretaAPI.messages("beerkezett"));
//     if (messageJson == null) {
//       return;
//     }
//     // format api messages to correct format
//     // Parse messages
//     List<Message> messages = [];
//     await Future.wait(List.generate(messageJson.length, (index) {
//       return () async {
//         Map message = messageJson.cast<Map>()[index];
//         Map? innerMessageJson = await currentKretaClient
//             .getAPI(KretaAPI.message(message["azonosito"].toString()));
//         await Future.delayed(const Duration(seconds: 1));
//         if (innerMessageJson != null) {
//           messages.add(
//               Message.fromJson(innerMessageJson, forceType: MessageType.inbox));
//         }
//       }();
//     }));

//     DateTime lastSeenMessage = await database.userQuery.lastSeen(
//         userId: currentuserProvider.id!, category: LastSeenCategory.message);

//     for (Message message in messages) {
//       if (message.date.isAfter(lastSeenMessage)) {
//         AndroidNotificationDetails androidNotificationDetails =
//             AndroidNotificationDetails(
//           'MESSAGES',
//           'Üzenetek',
//           channelDescription: 'Értesítés kapott üzenetekkor',
//           importance: Importance.max,
//           priority: Priority.max,
//           color: settingsProvider.customAccentColor,
//           ticker: 'Üzenetek',
//         );
//         NotificationDetails notificationDetails =
//             NotificationDetails(android: androidNotificationDetails);
//         if (currentuserProvider.getUsers().length == 1) {
//           await flutterLocalNotificationsPlugin.show(
//             message.id.hashCode,
//             message.author,
//             message.content.replaceAll(RegExp(r'<[^>]*>'), ''),
//             notificationDetails,
//             payload: "messages",
//           );
//         } else {
//           await flutterLocalNotificationsPlugin.show(
//             message.id.hashCode,
//             "(${currentuserProvider.displayName!}) ${message.author}",
//             message.content.replaceAll(RegExp(r'<[^>]*>'), ''),
//             notificationDetails,
//             payload: "messages",
//           );
//         }
//       }
//     }
//     await database.userStore.storeLastSeen(DateTime.now(),
//         userId: currentuserProvider.id!, category: LastSeenCategory.message);
//   }

//   Future<void> lessonNotification(
//       UserProvider currentuserProvider, KretaClient currentKretaClient) async {
//     // get lessons from api
//     TimetableProvider timetableProvider = TimetableProvider(
//         user: currentuserProvider,
//         database: database,
//         kreta: currentKretaClient);
//     await timetableProvider.restoreUser();
//     await timetableProvider.fetch(week: Week.current());
//     List<Lesson> apilessons = timetableProvider.getWeek(Week.current()) ?? [];

//     DateTime lastSeenLesson = await database.userQuery.lastSeen(
//         userId: currentuserProvider.id!, category: LastSeenCategory.lesson);
//     Lesson? latestLesson;

//     for (Lesson lesson in apilessons) {
//       if ((lesson.status?.name != "Elmaradt" ||
//               lesson.substituteTeacher?.name != "") &&
//           lesson.date.isAfter(latestLesson?.start ?? DateTime(1970))) {
//         latestLesson = lesson;
//       }
//       if (lesson.date.isAfter(lastSeenLesson)) {
//         AndroidNotificationDetails androidNotificationDetails =
//             AndroidNotificationDetails(
//           'LESSONS',
//           'Órák',
//           channelDescription: 'Értesítés órák elmaradásáról, helyettesítésről',
//           importance: Importance.max,
//           priority: Priority.max,
//           color: settingsProvider.customAccentColor,
//           ticker: 'Órák',
//         );
//         NotificationDetails notificationDetails =
//             NotificationDetails(android: androidNotificationDetails);
//         if (currentuserProvider.getUsers().length == 1) {
//           if (lesson.status?.name == "Elmaradt") {
//             switch (I18n.localeStr) {
//               case "en_en":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                       lesson.id.hashCode,
//                       "title_lesson".i18n,
//                       "body_lesson_canceled".i18n.fill(
//                         [
//                           lesson.lessonIndex,
//                           lesson.name,
//                           dayTitle(lesson.date)
//                         ],
//                       ),
//                       notificationDetails,
//                       payload: "timetable");
//                   break;
//                 }
//               case "hu_hu":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                       lesson.id.hashCode,
//                       "title_lesson".i18n,
//                       "body_lesson_canceled".i18n.fill(
//                         [
//                           dayTitle(lesson.date),
//                           lesson.lessonIndex,
//                           lesson.name
//                         ],
//                       ),
//                       notificationDetails,
//                       payload: "timetable");
//                   break;
//                 }
//               default:
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                       lesson.id.hashCode,
//                       "title_lesson".i18n,
//                       "body_lesson_canceled".i18n.fill(
//                         [
//                           lesson.lessonIndex,
//                           lesson.name,
//                           dayTitle(lesson.date)
//                         ],
//                       ),
//                       notificationDetails,
//                       payload: "timetable");
//                   break;
//                 }
//             }
//           } else if (lesson.substituteTeacher?.name != "" &&
//               lesson.substituteTeacher != null) {
//             switch (I18n.localeStr) {
//               case "en_en":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_substituted".i18n.fill(
//                       [
//                         lesson.lessonIndex,
//                         lesson.name,
//                         dayTitle(lesson.date),
//                         ((lesson.substituteTeacher?.isRenamed ?? false)
//                                 ? lesson.substituteTeacher?.renamedTo!
//                                 : lesson.substituteTeacher?.name) ??
//                             '',
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//               case "hu_hu":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_substituted".i18n.fill(
//                       [
//                         dayTitle(lesson.date),
//                         lesson.lessonIndex,
//                         lesson.name,
//                         ((lesson.substituteTeacher?.isRenamed ?? false)
//                                 ? lesson.substituteTeacher?.renamedTo!
//                                 : lesson.substituteTeacher?.name) ??
//                             '',
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//               default:
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_substituted".i18n.fill(
//                       [
//                         lesson.lessonIndex,
//                         lesson.name,
//                         dayTitle(lesson.date),
//                         ((lesson.substituteTeacher?.isRenamed ?? false)
//                                 ? lesson.substituteTeacher?.renamedTo!
//                                 : lesson.substituteTeacher?.name) ??
//                             '',
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//             }
//           }
//         } else {
//           if (lesson.status?.name == "Elmaradt") {
//             switch (I18n.localeStr) {
//               case "en_en":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_canceled_multiuser".i18n.fill(
//                       [
//                         currentuserProvider.displayName!,
//                         lesson.lessonIndex,
//                         lesson.name,
//                         dayTitle(lesson.date)
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//               case "hu_hu":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_canceled_multiuser".i18n.fill(
//                       [
//                         currentuserProvider.displayName!,
//                         dayTitle(lesson.date),
//                         lesson.lessonIndex,
//                         lesson.name
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//               default:
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_canceled_multiuser".i18n.fill(
//                       [
//                         currentuserProvider.displayName!,
//                         lesson.lessonIndex,
//                         lesson.name,
//                         dayTitle(lesson.date)
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//             }
//           } else if (lesson.substituteTeacher?.name != "") {
//             switch (I18n.localeStr) {
//               case "en_en":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_substituted_multiuser".i18n.fill(
//                       [
//                         currentuserProvider.displayName!,
//                         lesson.lessonIndex,
//                         lesson.name,
//                         dayTitle(lesson.date),
//                         ((lesson.substituteTeacher?.isRenamed ?? false)
//                                 ? lesson.substituteTeacher?.renamedTo!
//                                 : lesson.substituteTeacher?.name) ??
//                             '',
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//               case "hu_hu":
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_substituted_multiuser".i18n.fill(
//                       [
//                         currentuserProvider.displayName!,
//                         dayTitle(lesson.date),
//                         lesson.lessonIndex,
//                         lesson.name,
//                         ((lesson.substituteTeacher?.isRenamed ?? false)
//                                 ? lesson.substituteTeacher?.renamedTo!
//                                 : lesson.substituteTeacher?.name) ??
//                             '',
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//               default:
//                 {
//                   await flutterLocalNotificationsPlugin.show(
//                     lesson.id.hashCode,
//                     "title_lesson".i18n,
//                     "body_lesson_substituted_multiuser".i18n.fill(
//                       [
//                         currentuserProvider.displayName!,
//                         lesson.lessonIndex,
//                         lesson.name,
//                         dayTitle(lesson.date),
//                         (lesson.substituteTeacher?.isRenamed ?? false)
//                             ? lesson.substituteTeacher!.renamedTo!
//                             : lesson.substituteTeacher!.name
//                       ],
//                     ),
//                     notificationDetails,
//                     payload: "timetable",
//                   );
//                   break;
//                 }
//             }
//           }
//         }
//       }
//     }
//     // lesson.date does not contain time, only the date
//     await database.userStore.storeLastSeen(
//         latestLesson?.start ?? DateTime.now(),
//         userId: currentuserProvider.id!,
//         category: LastSeenCategory.lesson);
//   }

//   // Called when the user taps a notification
//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     switch (payload) {
//       case "timetable":
//         locator<NavigationService>().navigateTo("timetable");
//         break;
//       case "grades":
//         locator<NavigationService>().navigateTo("grades");
//         break;
//       case "messages":
//         locator<NavigationService>().navigateTo("messages");
//         break;
//       case "absences":
//         locator<NavigationService>().navigateTo("absences");
//         break;
//       case "settings":
//         locator<NavigationService>().navigateTo("settings");
//         break;
//       default:
//         break;
//     }
//   }

//   // Set all notification categories to seen
//   Future<void> setAllCategoriesSeen(UserProvider userProvider) async {
//     if (userProvider.id != null) {
//       for (LastSeenCategory category in LastSeenCategory.values) {
//         await database.userStore.storeLastSeen(DateTime.now(),
//             userId: userProvider.id!, category: category);
//       }
//     }
//   }
// }
