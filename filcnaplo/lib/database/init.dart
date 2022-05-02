// ignore_for_file: avoid_print

import 'dart:io';

import 'package:filcnaplo/database/struct.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const settingsDB = DatabaseStruct("settings", {
  "language": String, "start_page": int, "rounding": int, "theme": int, "accent_color": int, "news": int, "news_state": int, "developer_mode": int,
  "update_channel": int, "config": String, // general
  "grade_color1": int, "grade_color2": int, "grade_color3": int, "grade_color4": int, "grade_color5": int, // grade colors
  "vibration_strength": int, "ab_weeks": int, "swap_ab_weeks": int,
  "notifications": int, "notifications_bitfield": int, "notification_poll_interval": int, // notifications
  "x_filc_id": String, "graph_class_avg": int, "presentation_mode": int, "bell_delay": int, "bell_delay_enabled": int,
});
const usersDB = DatabaseStruct(
    "users", {"id": String, "name": String, "username": String, "password": String, "institute_code": String, "student": String, "role": int});
const userDataDB = DatabaseStruct("user_data", {
  "id": String, "grades": String, "timetable": String, "exams": String, "homework": String, "messages": String, "notes": String,
  "events": String, "absences": String, "group_averages": String,
  // "subject_lesson_count": String, // non kreta data
});

Future<void> createTable(Database db, DatabaseStruct struct) => db.execute("CREATE TABLE IF NOT EXISTS ${struct.table} ($struct)");

Future<Database> initDB() async {
  Database db;

  if (Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase("app.db");
  } else {
    db = await openDatabase("app.db");
  }

  await createTable(db, settingsDB);
  await createTable(db, usersDB);
  await createTable(db, userDataDB);

  if ((await db.rawQuery("SELECT COUNT(*) FROM settings"))[0].values.first == 0) {
    // Set default values for table Settings
    await db.insert("settings", SettingsProvider.defaultSettings().toMap());
  }

  // Migrate Databases
  try {
    await migrateDB(
      db,
      struct: settingsDB,
      defaultValues: SettingsProvider.defaultSettings().toMap(),
    );
    await migrateDB(
      db,
      struct: usersDB,
      defaultValues: {"role": 0},
    );
    await migrateDB(db, struct: userDataDB, defaultValues: {
      "grades": "[]", "timetable": "[]", "exams": "[]", "homework": "[]", "messages": "[]", "notes": "[]", "events": "[]", "absences": "[]",
      "group_averages": "[]",
      // "subject_lesson_count": "{}", // non kreta data
    });
  } catch (error) {
    print("ERROR: migrateDB: $error");
  }

  return db;
}

Future<void> migrateDB(
  Database db, {
  required DatabaseStruct struct,
  required Map<String, Object?> defaultValues,
}) async {
  var originalRows = await db.query(struct.table);

  if (originalRows.isEmpty) {
    await db.execute("drop table ${struct.table}");
    await createTable(db, struct);
    return;
  }

  List<Map<String, dynamic>> migrated = [];

  // go through each row and add missing keys or delete non existing keys
  await Future.forEach<Map<String, Object?>>(originalRows, (original) async {
    bool migrationRequired = struct.struct.keys.any((key) => !original.containsKey(key) || original[key] == null) ||
        original.keys.any((key) => !struct.struct.containsKey(key));

    if (migrationRequired) {
      print("INFO: Migrating ${struct.table}");
      var copy = Map<String, Object?>.from(original);

      // Fill missing columns
      for (var key in struct.struct.keys) {
        if (!original.containsKey(key) || original[key] == null) {
          print("DEBUG: migrating $key");
          copy[key] = defaultValues[key];
        }
      }

      for (var key in original.keys) {
        if (!struct.struct.keys.contains(key)) {
          print("DEBUG: dropping $key");
          copy.remove(key);
        }
      }

      migrated.add(copy);
    }
  });

  // replace the old table with the migrated one
  if (migrated.isNotEmpty) {
    // Delete table
    await db.execute("drop table ${struct.table}");

    // Recreate table
    await createTable(db, struct);
    await Future.forEach(migrated, (Map<String, Object?> copy) async {
      await db.insert(struct.table, copy);
    });

    print("INFO: Database migrated");
  }
}
