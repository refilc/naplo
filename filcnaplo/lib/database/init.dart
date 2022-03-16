// ignore_for_file: avoid_print

import 'dart:io';

import 'package:filcnaplo/database/struct.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initDB() async {
  Database db;

  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase("app.db");
  } else {
    db = await openDatabase("app.db");
  }

  // Create table Users
  var usersDB = await createUsersTable(db);
  await db.execute("CREATE TABLE IF NOT EXISTS user_data ("
      "id TEXT NOT NULL, grades TEXT, timetable TEXT, exams TEXT, homework TEXT, messages TEXT, notes TEXT, events TEXT, absences TEXT)");

  // Create table Settings
  var settingsDB = await createSettingsTable(db);

  if ((await db.rawQuery("SELECT COUNT(*) FROM settings"))[0].values.first == 0) {
    // Set default values for table Settings
    await db.insert("settings", SettingsProvider.defaultSettings().toMap());
  }

  // Migrate Databases
  try {
    await migrateDB(db, "settings", settingsDB.struct.keys, SettingsProvider.defaultSettings().toMap(), createSettingsTable);
    await migrateDB(db, "users", usersDB.struct.keys, {"role": 0}, createUsersTable);
  } catch (error) {
    print("ERROR: migrateDB: $error");
  }

  return db;
}

Future<DatabaseStruct> createSettingsTable(Database db) async {
  var settingsDB = DatabaseStruct({
    "language": String, "start_page": int, "rounding": int, "theme": int, "accent_color": int, "news": int, "news_state": int, "developer_mode": int,
    "update_channel": int, "config": String, // general
    "grade_color1": int, "grade_color2": int, "grade_color3": int, "grade_color4": int, "grade_color5": int, // grade colors
    "vibration_strength": int, "ab_weeks": int, "swap_ab_weeks": int,
    "notifications": int, "notifications_bitfield": int, "notification_poll_interval": int, // notifications
    "x_filc_id": String, "graph_class_avg": int,
  });

  // Create table Settings
  await db.execute("CREATE TABLE IF NOT EXISTS settings ($settingsDB)");

  return settingsDB;
}

Future<DatabaseStruct> createUsersTable(Database db) async {
  var usersDB = DatabaseStruct(
      {"id": String, "name": String, "username": String, "password": String, "institute_code": String, "student": String, "role": int});

  // Create table Users
  await db.execute("CREATE TABLE IF NOT EXISTS users ($usersDB)");

  return usersDB;
}

Future<void> migrateDB(
  Database db,
  String table,
  Iterable<String> keys,
  Map<String, Object?> defaultValues,
  Future<DatabaseStruct> Function(Database) create,
) async {
  var originalRows = await db.query(table);

  if (originalRows.isEmpty) {
    await db.execute("drop table $table");
    await create(db);
    return;
  }

  List<Map<String, dynamic>> migrated = [];

  // go through each row and add missing keys or delete non existing keys
  await Future.forEach<Map<String, Object?>>(originalRows, (original) async {
    bool migrationRequired = keys.any((key) => !original.containsKey(key) || original[key] == null);

    if (migrationRequired) {
      print("INFO: Migrating $table");
      var copy = Map<String, Object?>.from(original);

      // Fill missing columns
      for (var key in keys) {
        if (!keys.contains(key)) {
          print("DEBUG: dropping $key");
          copy.remove(key);
        }

        if (!original.containsKey(key) || original[key] == null) {
          print("DEBUG: migrating $key");
          copy[key] = defaultValues[key];
        }
      }

      migrated.add(copy);
    }
  });

  // replace the old table with the migrated one
  if (migrated.isNotEmpty) {
    // Delete table
    await db.execute("drop table $table");

    // Recreate table
    await create(db);
    await Future.forEach(migrated, (Map<String, Object?> copy) async {
      await db.insert(table, copy);
    });

    print("INFO: Database migrated");
  }
}
