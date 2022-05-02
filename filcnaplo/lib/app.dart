import 'dart:io';
import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/api/providers/news_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo/models/config.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_mobile_ui/common/system_chrome.dart';
import 'package:filcnaplo_mobile_ui/screens/login/login_route.dart';
import 'package:filcnaplo_mobile_ui/screens/login/login_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/navigation/navigation_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_route.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class App extends StatelessWidget {
  final SettingsProvider settings;
  final UserProvider user;
  final DatabaseProvider database;

  App({Key? key, required this.database, required this.settings, required this.user}) : super(key: key) {
    if (user.getUsers().isNotEmpty) user.setUser(user.getUsers().first.id);
  }

  @override
  Widget build(BuildContext context) {
    setSystemChrome(context);

    // Set high refresh mode #28
    if (Platform.isAndroid) FlutterDisplayMode.setHighRefreshRate();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FilcAPI.getConfig(settings).then((Config? config) {
        if (config != null) settings.update(context, database: database, config: config);
      });
    });

    CorePalette? corePalette;

    return I18n(
      initialLocale: Locale(settings.language, settings.language.toUpperCase()),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(create: (_) => settings),
          ChangeNotifierProvider<UserProvider>(create: (_) => user),
          ChangeNotifierProvider<StatusProvider>(create: (context) => StatusProvider()),
          Provider<KretaClient>(create: (context) => KretaClient(context: context, userAgent: settings.config.userAgent)),
          Provider<DatabaseProvider>(create: (context) => database),
          ChangeNotifierProvider<ThemeModeObserver>(create: (context) => ThemeModeObserver(initialTheme: settings.theme)),
          ChangeNotifierProvider<NewsProvider>(create: (context) => NewsProvider(context: context)),
          ChangeNotifierProvider<UpdateProvider>(create: (context) => UpdateProvider(context: context)),

          // User data providers
          ChangeNotifierProvider<GradeProvider>(create: (context) => GradeProvider(context: context)),
          ChangeNotifierProvider<TimetableProvider>(create: (context) => TimetableProvider(context: context)),
          ChangeNotifierProvider<ExamProvider>(create: (context) => ExamProvider(context: context)),
          ChangeNotifierProvider<HomeworkProvider>(create: (context) => HomeworkProvider(context: context)),
          ChangeNotifierProvider<MessageProvider>(create: (context) => MessageProvider(context: context)),
          ChangeNotifierProvider<NoteProvider>(create: (context) => NoteProvider(context: context)),
          ChangeNotifierProvider<EventProvider>(create: (context) => EventProvider(context: context)),
          ChangeNotifierProvider<AbsenceProvider>(create: (context) => AbsenceProvider(context: context)),

          ChangeNotifierProvider<GradeCalculatorProvider>(create: (context) => GradeCalculatorProvider(context)),
        ],
        child: Consumer<ThemeModeObserver>(
          builder: (context, themeMode, child) {
            return FutureBuilder<CorePalette?>(
              future: DynamicColorPlugin.getCorePalette(),
              builder: (context, snapshot) {
                corePalette = snapshot.data;
                return MaterialApp(
                  builder: (context, child) {
                    // Limit font size scaling to 1.0
                    double textScaleFactor = min(MediaQuery.of(context).textScaleFactor, 1.0);

                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
                      child: SafeArea(
                        top: false,
                        child: child ?? Container(),
                      ),
                    );
                  },
                  title: "Filc Napló",
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme(context, palette: corePalette),
                  darkTheme: AppTheme.darkTheme(context, palette: corePalette),
                  themeMode: themeMode.themeMode,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en', 'EN'),
                    Locale('hu', 'HU'),
                    Locale('de', 'DE'),
                  ],
                  localeListResolutionCallback: (locales, supported) {
                    Locale locale = const Locale('hu', 'HU');

                    for (var loc in locales ?? []) {
                      if (supported.contains(loc)) {
                        locale = loc;
                        break;
                      }
                    }

                    return locale;
                  },
                  onGenerateRoute: (settings) => rootNavigator(settings),
                  initialRoute: user.getUsers().isNotEmpty ? "navigation" : "login",
                );
              },
            );
          },
        ),
      ),
    );
  }

  Route? rootNavigator(RouteSettings route) {
    // if platform == android || platform == ios
    switch (route.name) {
      case "login_back":
        return CupertinoPageRoute(builder: (context) => const LoginScreen(back: true));
      case "login":
        return _rootRoute(const LoginScreen());
      case "navigation":
        return _rootRoute(const NavigationScreen());
      case "login_to_navigation":
        return loginRoute(const NavigationScreen());
      case "settings":
        return settingsRoute(const SettingsScreen());
    }
    return null;
    // else if platform == windows || ...
  }

  Route _rootRoute(Widget widget) {
    return PageRouteBuilder(pageBuilder: (context, _, __) => widget);
  }
}
