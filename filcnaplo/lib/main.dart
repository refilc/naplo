import 'package:background_fetch/background_fetch.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/database/init.dart';
import 'package:filcnaplo/helpers/notification_helper.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/app.dart';
import 'package:flutter/services.dart';
import 'package:filcnaplo_mobile_ui/screens/error_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/error_report_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  // Initalize
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Startup
  Startup startup = Startup();
  await startup.start();

  // Custom error page
  ErrorWidget.builder = errorBuilder;

  BackgroundFetch.registerHeadlessTask(backgroundHeadlessTask);

  // Run App
  runApp(App(
      database: startup.database,
      settings: startup.settings,
      user: startup.user));
}

class Startup {
  late SettingsProvider settings;
  late UserProvider user;
  late DatabaseProvider database;

  Future<void> start() async {
    database = DatabaseProvider();
    var db = await initDB(database);
    await db.close();
    await database.init();
    settings = await database.query.getSettings(database);
    user = await database.query.getUsers(settings);

    // Notifications setup
    initPlatformState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Get permission to show notifications
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
    alert: false,
    badge: true,
    sound: true,
    );
    await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
    alert: false,
    badge: true,
    sound: true,
    );

    // Platform specific settings
    final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: false,
  );
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');
    final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin
  );

  // Initialize notifications
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  }
}

bool errorShown = false;
String lastException = '';

Widget errorBuilder(FlutterErrorDetails details) {
  return Builder(builder: (context) {
    if (Navigator.of(context).canPop()) Navigator.pop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!errorShown && details.exceptionAsString() != lastException) {
        errorShown = true;
        lastException = details.exceptionAsString();
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) {
          if (kReleaseMode) {
            return ErrorReportScreen(details);
          } else {
            return ErrorScreen(details);
          }
        })).then((_) => errorShown = false);
      }
    });

    return Container();
  });
}
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
        startOnBoot: true
    ), (String taskId) async {  // <-- Event handler
      print("[BackgroundFetch] Event received $taskId");
      NotificationsHelper().backgroundJob();
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.refilcnotification",
        delay: 900000, // 15 minutes
        periodic: true,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true
    ));
  }

@pragma('vm:entry-point')
void backgroundHeadlessTask(HeadlessTask task) {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    if (kDebugMode) {
      print("[BackgroundFetch] Headless task timed-out: $taskId");
    }
    BackgroundFetch.finish(taskId);
    return;
  }  
  if (kDebugMode) {
    print('[BackgroundFetch] Headless event received.');
  }
  NotificationsHelper().backgroundJob();
  BackgroundFetch.finish(task.taskId);
}
