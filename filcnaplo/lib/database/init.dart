import 'package:filcnaplo/database/struct.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDB() async {
  // await deleteDatabase('app.db'); // for debugging
  var db = await openDatabase('app.db');

  var settingsDB = await createSettingsTable(db);

  // Create table Users
  await db.execute("CREATE TABLE IF NOT EXISTS users (id TEXT NOT NULL, name TEXT, username TEXT, password TEXT, institute_code TEXT, student TEXT)");
  await db.execute("CREATE TABLE IF NOT EXISTS user_data ("
      "id TEXT NOT NULL, grades TEXT, timetable TEXT, exams TEXT, homework TEXT, messages TEXT, notes TEXT, events TEXT, absences TEXT)");

  if ((await db.rawQuery("SELECT COUNT(*) FROM settings"))[0].values.first == 0) {
    // Set default values for table Settings
    await db.insert("settings", SettingsProvider.defaultSettings().toMap());
  }

  await migrateDB(db, settingsDB.struct.keys);

  return db;
}

Future<DatabaseStruct> createSettingsTable(Database db) async {
  var settingsDB = DatabaseStruct({
    "language": String, "start_page": int, "rounding": int, "theme": int, "accent_color": int, "news": int, "news_state": int, "developer_mode": int,
    "update_channel": int, "config": String, // general
    "grade_color1": int, "grade_color2": int, "grade_color3": int, "grade_color4": int, "grade_color5": int, // grade colors
    "vibration_strength": int, "ab_weeks": int, "swap_ab_weeks": int,
    "notifications": int, "notifications_bitfield": int, "notification_poll_interval": int, // notifications
  });

  // Create table Settings
  await db.execute("CREATE TABLE IF NOT EXISTS settings ($settingsDB)");

  return settingsDB;
}

Future<void> migrateDB(Database db, Iterable<String> keys) async {
  var settings = (await db.query("settings"))[0];

  bool migrationRequired = keys.any((key) => !settings.containsKey(key) || settings[key] == null);

  if (migrationRequired) {
    var defaultSettings = SettingsProvider.defaultSettings();
    var settingsCopy = Map<String, dynamic>.from(settings);

    // Delete settings
    await db.execute("drop table settings");

    // Fill missing columns
    keys.forEach((key) {
      if (!keys.contains(key)) {
        print("debug: dropping $key");
        settingsCopy.remove(key);
      }

      if (!settings.containsKey(key) || settings[key] == null) {
        print("DEBUG: migrating $key");
        settingsCopy[key] = defaultSettings.toMap()[key];
      }
    });

    // Recreate settings
    await createSettingsTable(db);
    await db.insert("settings", settingsCopy);

    print("INFO: Database migrated");
  }
}
