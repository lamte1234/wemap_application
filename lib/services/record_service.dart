import 'package:sqflite/sqflite.dart';
import 'package:wemap_application/database/history_database.dart';

import '../models/record_model.dart';

class RecordService {
  static const TABLE_NAME = 'records';
  static const CREATE_TABLE_QUERY = '''
    CREATE TABLE $TABLE_NAME (
      id INTEGER PRIMARY KEY NOT NULL,
      distance DOUBLE NOT NULL,
      totalTime DOUBLE NOT NULL,
      speed DOUBLE NOT NULL,
      dateTime TEXT NOT NULL
    )
  ''';

  static const DROP_TABLE_QUERY = '''
    DROP TABLE IF EXISTS $TABLE_NAME
  ''';

  static const LAST_INSERT_ID_QUERY = '''
    SELECT max(id) as last_insert_id FROM $TABLE_NAME
  ''';

  static int lastInsertId;

  Future<void> getLastInsertRowId() async {
    final Database db = HistoryDatabase.instance.database;
    var queryResult = await db.rawQuery(LAST_INSERT_ID_QUERY);
    lastInsertId = queryResult.first["last_insert_id"];
  }

  Future<void> insertRecord(record) async {
    final Database db = HistoryDatabase.instance.database;
    await db.insert(TABLE_NAME, record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteRecord(int recordId) async {
    final Database db = HistoryDatabase.instance.database;
    await db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [recordId]);
  }

  Future<void> updateRecord(record) async {
    final Database db = HistoryDatabase.instance.database;
    await db.update(TABLE_NAME, record.toMap(), where: 'id = ?', whereArgs: [record.id]);
  }

  Future<List<Record>> getAllRecords() async {
    final Database db = HistoryDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (index) {
      return Record(
        id: maps[index]["id"],
        distance: maps[index]["distance"],
        totalTime: maps[index]["totalTime"],
        speed: maps[index]["speed"],
        dateTime: maps[index]["dateTime"],
      );
    });
  }
}