import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/database/init.dart';
import 'package:refilc/helpers/notification_helper.dart';
import 'package:refilc/models/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refilc/app.dart';
import 'package:flutter/services.dart';
import 'package:refilc/utils/service_locator.dart';
import 'package:refilc_mobile_ui/screens/error_screen.dart';
import 'package:refilc_mobile_ui/screens/error_report_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shake_flutter/models/shake_report_configuration.dart';
import 'package:shake_flutter/shake_flutter.dart';

import 'helpers/live_activity_helper.dart';

// days without touching grass: 5,843 (16 yrs)

void main() async {
  // Initalize
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  // ignore: deprecated_member_use
  binding.renderView.automaticSystemUiAdjustment = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // navigation
  setupLocator();

  // Startup
  Startup startup = Startup();
  await startup.start();

  // Custom error page
  ErrorWidget.builder = errorBuilder;

  BackgroundFetch.registerHeadlessTask(backgroundHeadlessTask);

  // shakebugs initialization
  // Shake.setInvokeShakeOnScreenshot(true);
  Shake.start('Y44AwzfY6091xO2Nr0w59RHSpNxJhhiSFGs4enmoJwelN82ZRzTLE5X');

  // pre-cache required icons
  const todaySvg = SvgAssetLoader('assets/svg/menu_icons/today_selected.svg');
  const gradesSvg = SvgAssetLoader('assets/svg/menu_icons/grades_selected.svg');
  const timetableSvg =
      SvgAssetLoader('assets/svg/menu_icons/timetable_selected.svg');
  const notesSvg = SvgAssetLoader('assets/svg/menu_icons/notes_selected.svg');
  const absencesSvg =
      SvgAssetLoader('assets/svg/menu_icons/absences_selected.svg');

  svg.cache
      .putIfAbsent(todaySvg.cacheKey(null), () => todaySvg.loadBytes(null));
  svg.cache
      .putIfAbsent(gradesSvg.cacheKey(null), () => gradesSvg.loadBytes(null));
  svg.cache.putIfAbsent(
      timetableSvg.cacheKey(null), () => timetableSvg.loadBytes(null));
  svg.cache
      .putIfAbsent(notesSvg.cacheKey(null), () => notesSvg.loadBytes(null));
  svg.cache.putIfAbsent(
      absencesSvg.cacheKey(null), () => absencesSvg.loadBytes(null));

  // Run App
  runApp(App(
    database: startup.database,
    settings: startup.settings,
    user: startup.user,
  ));
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

    // Set all notification categories to seen to avoid having notifications that the user has already seen in the app
    NotificationsHelper().setAllCategoriesSeen(user);

    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    // Notifications setup
    if (!kIsWeb) {
      initPlatformState();
      initAdditionalBackgroundFetch();
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    }

    // Get permission to show notifications
    if (kIsWeb) {
      // do nothing
    } else if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: false,
            badge: true,
            sound: true,
          );
    } else if (Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: false,
            badge: true,
            sound: true,
          );
    } else if (Platform.isLinux) {
      // no permissions are needed on linux
    }

    // Platform specific settings
    if (!kIsWeb) {
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: false,
      );
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_notification');
      const LinuxInitializationSettings initializationSettingsLinux =
          LinuxInitializationSettings(defaultActionName: 'Open notification');
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux,
      );

      // Initialize notifications
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            NotificationsHelper().onDidReceiveNotificationResponse,
      );
    }

    // if (Platform.isAndroid || Platform.isIOS) {
    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    // }
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
            // silent report to shakebugs
            ShakeReportConfiguration configuration = ShakeReportConfiguration();
            configuration.blackBoxData = true;
            configuration.activityHistoryData = true;
            configuration.screenshot = true;
            configuration.video = false;
            Shake.silentReport(
              configuration: configuration,
              description:
                  'Silent Report #${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}',
            );
            // show error report screen
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
  int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
          startOnBoot: true), (String taskId) async {
    // <-- Event handler
    if (kDebugMode) {
      print("[BackgroundFetch] Event received $taskId");
    }
    if (taskId == "com.transistorsoft.refilcliveactivity") {
      if (!Platform.isIOS) return;
      LiveActivityHelper().backgroundJob();
    } else {
      NotificationsHelper().backgroundJob();
    }
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    // <-- Task timeout handler.
    if (kDebugMode) {
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    }
    BackgroundFetch.finish(taskId);
  });
  if (kDebugMode) {
    print('[BackgroundFetch] configure success: $status');
  }
  BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.transistorsoft.refilcnotification",
      delay: 900000, // 15 minutes
      periodic: true,
      forceAlarmManager: true,
      stopOnTerminate: false,
      enableHeadless: true));
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
  if (taskId == "com.transistorsoft.refilcliveactivity") {
    if (!Platform.isIOS) return;
    LiveActivityHelper().backgroundJob();
  } else {
    NotificationsHelper().backgroundJob();
  }
  BackgroundFetch.finish(task.taskId);
}

Future<void> initAdditionalBackgroundFetch() async {
  int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 1, // 1 minute
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
          startOnBoot: true), (String taskId) async {
    // <-- Event handler

    if (kDebugMode) {
      print("[BackgroundFetch] Event received $taskId");
    }
    LiveActivityHelper liveActivityHelper = LiveActivityHelper();
    liveActivityHelper.backgroundJob();

    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    // <-- Task timeout handler.
    if (kDebugMode) {
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    }
    BackgroundFetch.finish(taskId);
  });
  if (kDebugMode) {
    print('[BackgroundFetch] configure success: $status');
  }
  BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.transistorsoft.refilcliveactivity",
      delay: 300000, // 5 minute
      periodic: true,
      forceAlarmManager: true,
      stopOnTerminate: false,
      enableHeadless: true));
}
