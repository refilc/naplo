import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/helpers/notification_helper.i18n.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';

class NotificationsHelper {
  late DatabaseProvider database;
  late SettingsProvider settingsProvider;
  late UserProvider userProvider;
  late KretaClient kretaClient;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<T> combineLists<T, K>(
    List<T> list1,
    List<T> list2,
    K Function(T) keyExtractor,
  ) {
    Set<K> uniqueKeys = <K>{};
    List<T> combinedList = [];

    for (T item in list1) {
      K key = keyExtractor(item);
      if (!uniqueKeys.contains(key)) {
        uniqueKeys.add(key);
        combinedList.add(item);
      }
    }

    for (T item in list2) {
      K key = keyExtractor(item);
      if (!uniqueKeys.contains(key)) {
        uniqueKeys.add(key);
        combinedList.add(item);
      }
    }

    return combinedList;
  }

  String dayTitle(DateTime date) {
    try {
      return DateFormat("EEEE", I18n.locale.languageCode).format(date);
    } catch (e) {
      return "Unknown";
    }
  }

  @pragma('vm:entry-point')
  void backgroundJob() async {
    // initialize providers
    database = DatabaseProvider();
    await database.init();
    settingsProvider = await database.query.getSettings(database);
    userProvider = await database.query.getUsers(settingsProvider);

    if (userProvider.id != null && settingsProvider.notificationsEnabled) {
      // refresh kreta login
      final status = StatusProvider();
      kretaClient = KretaClient(
          user: userProvider, settings: settingsProvider, status: status);
      kretaClient.refreshLogin();
      if (settingsProvider.notificationsGradesEnabled) gradeNotification();
      if (settingsProvider.notificationsAbsencesEnabled) absenceNotification();
      if (settingsProvider.notificationsMessagesEnabled) messageNotification();
      if (settingsProvider.notificationsLessonsEnabled) lessonNotification();
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
      // if grade is not a normal grade (1-5), don't show it
      if ([1, 2, 3, 4, 5].contains(grade.value.value)) {
        // if the grade was added over a week ago, don't show it to avoid notification spam
        if (grade.seenDate.isAfter(lastSeenGrade) &&
            grade.date.difference(DateTime.now()).inDays * -1 < 7) {
          // send notificiation about new grade
          AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'GRADES',
            'Jegyek',
            channelDescription: 'Értesítés jegyek beírásakor',
            importance: Importance.max,
            priority: Priority.max,
            color: settingsProvider.customAccentColor,
            ticker: 'Jegyek',
          );
          NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          if (userProvider.getUsers().length == 1) {
            await flutterLocalNotificationsPlugin.show(
              grade.id.hashCode,
              "title_grade".i18n,
              "body_grade".i18n.fill(
                [
                  grade.value.value.toString(),
                  grade.subject.isRenamed &&
                          settingsProvider.renamedSubjectsEnabled
                      ? grade.subject.renamedTo!
                      : grade.subject.name
                ],
              ),
              notificationDetails,
            );
          } else {
            // multiple users are added, also display student name
            await flutterLocalNotificationsPlugin.show(
              grade.id.hashCode,
              "title_grade".i18n,
              "body_grade_multiuser".i18n.fill(
                [
                  userProvider.displayName!,
                  grade.value.value.toString(),
                  grade.subject.isRenamed &&
                          settingsProvider.renamedSubjectsEnabled
                      ? grade.subject.renamedTo!
                      : grade.subject.name
                ],
              ),
              notificationDetails,
            );
          }
        }
      }
    }
    // set grade seen status
    gradeProvider.seenAll();
  }

  void absenceNotification() async {
    // get absences from api
    List? absenceJson = await kretaClient
        .getAPI(KretaAPI.absences(userProvider.instituteCode ?? ""));
    List<Absence> storedAbsences =
        await database.userQuery.getAbsences(userId: userProvider.id!);
    if (absenceJson == null) {
      return;
    }
    // format api absences to correct format while preserving isSeen value
    List<Absence> absences = absenceJson.map((e) {
      Absence apiAbsence = Absence.fromJson(e);
      Absence storedAbsence = storedAbsences.firstWhere(
          (stored) => stored.id == apiAbsence.id,
          orElse: () => apiAbsence);
      apiAbsence.isSeen = storedAbsence.isSeen;
      return apiAbsence;
    }).toList();
    List<Absence> modifiedAbsences = [];
    if (absences != storedAbsences) {
      // remove absences that are not new
      absences.removeWhere((element) => storedAbsences.contains(element));
      for (Absence absence in absences) {
        if (!absence.isSeen) {
          absence.isSeen = true;
          modifiedAbsences.add(absence);
          AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'ABSENCES',
            'Hiányzások',
            channelDescription: 'Értesítés hiányzások beírásakor',
            importance: Importance.max,
            priority: Priority.max,
            color: settingsProvider.customAccentColor,
            ticker: 'Hiányzások',
          );
          NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          if (userProvider.getUsers().length == 1) {
            await flutterLocalNotificationsPlugin.show(
              absence.id.hashCode,
              "title_absence".i18n,
              "body_absence".i18n.fill(
                [
                  DateFormat("yyyy-MM-dd").format(absence.date),
                  absence.subject.isRenamed &&
                          settingsProvider.renamedSubjectsEnabled
                      ? absence.subject.renamedTo!
                      : absence.subject.name
                ],
              ),
              notificationDetails,
            );
          } else {
            await flutterLocalNotificationsPlugin.show(
              absence.id.hashCode,
              "title_absence".i18n,
              "body_absence_multiuser".i18n.fill(
                [
                  userProvider.displayName!,
                  DateFormat("yyyy-MM-dd").format(absence.date),
                  absence.subject.isRenamed &&
                          settingsProvider.renamedSubjectsEnabled
                      ? absence.subject.renamedTo!
                      : absence.subject.name
                ],
              ),
              notificationDetails,
            );
          }
        }
      }
    }
    // combine modified absences and storedabsences list and save them to the database
    List<Absence> combinedAbsences = combineLists(
      modifiedAbsences,
      storedAbsences,
      (Absence absence) => absence.id,
    );
    await database.userStore
        .storeAbsences(combinedAbsences, userId: userProvider.id!);
  }

  void messageNotification() async {
    // get messages from api
    List? messageJson =
        await kretaClient.getAPI(KretaAPI.messages("beerkezett"));
    List<Message> storedmessages =
        await database.userQuery.getMessages(userId: userProvider.id!);
    if (messageJson == null) {
      return;
    }
    // format api messages to correct format while preserving isSeen value
    // Parse messages
    List<Message> messages = [];
    await Future.wait(List.generate(messageJson.length, (index) {
      return () async {
        Map message = messageJson.cast<Map>()[index];
        Map? innerMessageJson = await kretaClient
            .getAPI(KretaAPI.message(message["azonosito"].toString()));
        if (innerMessageJson != null) {
          messages.add(
              Message.fromJson(innerMessageJson, forceType: MessageType.inbox));
        }
      }();
    }));

    for (Message message in messages) {
      for (Message storedMessage in storedmessages) {
        if (message.id == storedMessage.id) {
          message.isSeen = storedMessage.isSeen;
        }
      }
    }
    List<Message> modifiedmessages = [];
    if (messages != storedmessages) {
      // remove messages that are not new
      messages.removeWhere((element) => storedmessages.contains(element));
      for (Message message in messages) {
        if (!message.isSeen) {
          message.isSeen = true;
          modifiedmessages.add(message);
          AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'MESSAGES',
            'Üzenetek',
            channelDescription: 'Értesítés kapott üzenetekkor',
            importance: Importance.max,
            priority: Priority.max,
            color: settingsProvider.customAccentColor,
            ticker: 'Üzenetek',
          );
          NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          if (userProvider.getUsers().length == 1) {
            await flutterLocalNotificationsPlugin.show(
              message.id.hashCode,
              message.author,
              message.content.replaceAll(RegExp(r'<[^>]*>'), ''),
              notificationDetails,
            );
          } else {
            await flutterLocalNotificationsPlugin.show(
              message.id.hashCode,
              "(${userProvider.displayName!}) ${message.author}",
              message.content.replaceAll(RegExp(r'<[^>]*>'), ''),
              notificationDetails,
            );
          }
        }
      }
    }
    // combine modified messages and storedmessages list and save them to the database
    List<Message> combinedmessages = combineLists(
      modifiedmessages,
      storedmessages,
      (Message message) => message.id,
    );
    await database.userStore
        .storeMessages(combinedmessages, userId: userProvider.id!);
  }

  void lessonNotification() async {
    // get lesson from api
    TimetableProvider timetableProvider = TimetableProvider(
        user: userProvider, database: database, kreta: kretaClient);
    List<Lesson> storedlessons =
        timetableProvider.lessons[Week.current()] ?? [];
    List? apilessons = timetableProvider.getWeek(Week.current()) ?? [];
    for (Lesson lesson in apilessons) {
      for (Lesson storedLesson in storedlessons) {
        if (lesson.id == storedLesson.id) {
          lesson.isSeen = storedLesson.isSeen;
        }
      }
    }
    List<Lesson> modifiedlessons = [];
    if (apilessons != storedlessons) {
      // remove lessons that are not new
      apilessons.removeWhere((element) => storedlessons.contains(element));
      for (Lesson lesson in apilessons) {
        if (!lesson.isSeen && lesson.isChanged) {
          lesson.isSeen = true;
          modifiedlessons.add(lesson);
          AndroidNotificationDetails androidNotificationDetails =
              AndroidNotificationDetails(
            'LESSONS',
            'Órák',
            channelDescription:
                'Értesítés órák elmaradásáról, helyettesítésről',
            importance: Importance.max,
            priority: Priority.max,
            color: settingsProvider.customAccentColor,
            ticker: 'Órák',
          );
          NotificationDetails notificationDetails =
              NotificationDetails(android: androidNotificationDetails);
          if (userProvider.getUsers().length == 1) {
            if (lesson.status?.name == "Elmaradt") {
              switch (I18n.localeStr) {
                case "en_en":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_canceled".i18n.fill(
                        [
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date)
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                case "hu_hu":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_canceled".i18n.fill(
                        [
                          dayTitle(lesson.date),
                          lesson.lessonIndex,
                          lesson.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                default:
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_canceled".i18n.fill(
                        [
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date)
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
              }
            } else if (lesson.substituteTeacher?.name != "") {
              switch (I18n.localeStr) {
                case "en_en":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_substituted".i18n.fill(
                        [
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date),
                          lesson.substituteTeacher!.isRenamed
                              ? lesson.substituteTeacher!.renamedTo!
                              : lesson.substituteTeacher!.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                case "hu_hu":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_substituted".i18n.fill(
                        [
                          dayTitle(lesson.date),
                          lesson.lessonIndex,
                          lesson.name,
                          lesson.substituteTeacher!.isRenamed
                              ? lesson.substituteTeacher!.renamedTo!
                              : lesson.substituteTeacher!.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                default:
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_substituted".i18n.fill(
                        [
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date),
                          lesson.substituteTeacher!.isRenamed
                              ? lesson.substituteTeacher!.renamedTo!
                              : lesson.substituteTeacher!.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
              }
            }
          } else {
            if (lesson.status?.name == "Elmaradt") {
              switch (I18n.localeStr) {
                case "en_en":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_canceled".i18n.fill(
                        [
                          userProvider.displayName!,
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date)
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                case "hu_hu":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_canceled".i18n.fill(
                        [
                          userProvider.displayName!,
                          dayTitle(lesson.date),
                          lesson.lessonIndex,
                          lesson.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                default:
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_canceled".i18n.fill(
                        [
                          userProvider.displayName!,
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date)
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
              }
            } else if (lesson.substituteTeacher?.name != "") {
              switch (I18n.localeStr) {
                case "en_en":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_substituted".i18n.fill(
                        [
                          userProvider.displayName!,
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date),
                          lesson.substituteTeacher!.isRenamed
                              ? lesson.substituteTeacher!.renamedTo!
                              : lesson.substituteTeacher!.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                case "hu_hu":
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_substituted".i18n.fill(
                        [
                          userProvider.displayName!,
                          dayTitle(lesson.date),
                          lesson.lessonIndex,
                          lesson.name,
                          lesson.substituteTeacher!.isRenamed
                              ? lesson.substituteTeacher!.renamedTo!
                              : lesson.substituteTeacher!.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
                default:
                  {
                    await flutterLocalNotificationsPlugin.show(
                      lesson.id.hashCode,
                      "title_lesson".i18n,
                      "body_lesson_substituted".i18n.fill(
                        [
                          userProvider.displayName!,
                          lesson.lessonIndex,
                          lesson.name,
                          dayTitle(lesson.date),
                          lesson.substituteTeacher!.isRenamed
                              ? lesson.substituteTeacher!.renamedTo!
                              : lesson.substituteTeacher!.name
                        ],
                      ),
                      notificationDetails,
                    );
                    break;
                  }
              }
            }
          }
        }
      }
      // combine modified lesson and storedlesson list and save them to the database
      List<Lesson> combinedlessons = combineLists(
        modifiedlessons,
        storedlessons,
        (Lesson message) => message.id,
      );
      Map<Week, List<Lesson>> timetableLessons = timetableProvider.lessons;
      timetableLessons[Week.current()] = combinedlessons;
      await database.userStore
          .storeLessons(timetableLessons, userId: userProvider.id!);
    }
  }
}
