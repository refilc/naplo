import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/database/init.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/app.dart';
import 'package:flutter/services.dart';
import 'package:filcnaplo_mobile_ui/screens/error_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/error_report_screen.dart';

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

  // Run App
  runApp(App(database: startup.database, settings: startup.settings, user: startup.user));
}

class Startup {
  late SettingsProvider settings;
  late UserProvider user;
  late DatabaseProvider database;

  Future<void> start() async {
    var db = await initDB();
    await db.close();
    database = DatabaseProvider();
    await database.init();
    settings = await database.query.getSettings();
    user = await database.query.getUsers();
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
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) {
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
