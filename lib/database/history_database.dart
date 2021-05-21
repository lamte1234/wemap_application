import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wemap_application/services/record_service.dart';

class HistoryDatabase {
  static const DB_NAME = 'db.history';
  static const DB_VERSION = 1;
  static Database _database;

  HistoryDatabase._internal();
  static final HistoryDatabase instance = HistoryDatabase._internal();

  Database get database => _database;

  static const initScripts = [RecordService.CREATE_TABLE_QUERY];
  static const migrationScripts = [RecordService.CREATE_TABLE_QUERY];

  init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        initScripts.forEach((script) async => await db.execute(script));
      },
      version: DB_VERSION,
      onUpgrade: (db, oldVersion, newVersion) {
        migrationScripts.forEach((script) async => await db.execute(script));
      }
    );
  }
}