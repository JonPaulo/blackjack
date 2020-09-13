import 'package:flutter/services.dart';
import 'stats_dto.dart';
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
    print("CREATING TABLES");
    await db.execute(await rootBundle.loadString(CREATETABLE));
  }

  void saveJournalEntry({StatsDTO dto}) {
    db.transaction((txn) async {
      await txn.rawInsert(
        await rootBundle.loadString(SQL_INSERT),
        [
          dto.id,
          dto.playerWins,
          dto.computerWins,
          dto.roundsPlayed,
        ],
      );
    });
  }

  void updateData({StatsDTO dto}) {
    db.transaction((txn) async {
      await txn.rawInsert(
        await rootBundle.loadString(SQL_INSERT),
        [
          dto.playerWins,
          dto.computerWins,
          dto.roundsPlayed,
        ],
      );
    });
  }

  Future<void> updateData2({StatsDTO dto}) async {

    // Update the given Dog.
    await db.update(
      DATABASE_FILENAME,
      dto.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dto.id],
    );
  }
}
