import 'dart:io';

import 'package:refilc/database/query.dart';
import 'package:refilc/database/store.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  // late Database _database;
  late DatabaseQuery query;
  late UserDatabaseQuery userQuery;
  late DatabaseStore store;
  late UserDatabaseStore userStore;

  Future<void> init() async {
    Database db;

    if (Platform.isLinux || Platform.isWindows) {
      db = await databaseFactoryFfi.openDatabase("app.db");
    } else {
      db = await openDatabase("app.db");
    }

    query = DatabaseQuery(db: db);
    store = DatabaseStore(db: db);
    userQuery = UserDatabaseQuery(db: db);
    userStore = UserDatabaseStore(db: db);
  }
}
