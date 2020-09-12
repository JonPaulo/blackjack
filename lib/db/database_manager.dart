import 'package:flutter/services.dart';
import 'journal_entry_dto.dart';
import 'package:sqflite/sqflite.dart';

const String CREATETABLE = 'assets/schema_create.sql.txt';
const String INSERTENTRY = 'assets/schema_insert.sql.txt';

class DatabaseManager {
  static const String DATABASE_FILENAME = 'blackjack.sqlite3.db';
  static const String SQL_CREATE_SCHEMA = CREATETABLE;
  static const String SQL_INSERT = INSERTENTRY;
  static DatabaseManager _instance;

  final Database db;

  DatabaseManager._({Database database}) : db = database;

  factory DatabaseManager.getInstance() {
    assert(_instance != null);

    return _instance;
  }

  static Future initialize() async {
    final db = await openDatabase(DATABASE_FILENAME, version: 1,
        onCreate: (Database db, int version) async {
      createTables(db, SQL_CREATE_SCHEMA);
    });
    _instance = DatabaseManager._(database: db);
  }

  static void createTables(Database db, String sql) async {
    await db.execute(await rootBundle.loadString(CREATETABLE));
  }

  void saveJournalEntry({JournalEntryDTO dto}) {
    db.transaction((txn) async {
      await txn.rawInsert(
        await rootBundle.loadString(SQL_INSERT),
        [
          dto.title,
          dto.body,
          dto.rating,
          dto.date.toString(),
        ],
      );
    });
  }
}
