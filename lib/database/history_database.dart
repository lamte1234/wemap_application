import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wemap_application/services/record_service.dart';

class HistoryDatabase {
  static const DB_NAME = 'history.db';
  static const DB_VERSION = 2;
  static Database _database;

  HistoryDatabase._internal();
  static final HistoryDatabase instance = HistoryDatabase._internal();

  Database get database => _database;

  static const initScripts = [RecordService.CREATE_TABLE_QUERY];
  static const migrationScripts = [RecordService.CREATE_TABLE_QUERY];

  init() async {
    print(join(await getDatabasesPath(), DB_NAME));
    _database = await openDatabase(
      join(await getDatabasesPath(), DB_NAME), version: DB_VERSION,
      onCreate: (db, version) {
        initScripts.forEach((script) async => await db.execute(script));
      },
      onUpgrade: (db, oldVersion, newVersion) {
        migrationScripts.forEach((script) async => await db.execute(script));
      }
    );
  }
}