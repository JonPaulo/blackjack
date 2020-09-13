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

  void addData({StatsDTO dto}) {
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

  Future<void> updateData({StatsDTO dto}) async {
    // Update the given Dog.
    await db.update(
      "blackjack",
      dto.toMap(),
      // where: "id = 1",
      // Pass the id as a whereArg to prevent SQL injection.
      // whereArgs: [1],
    );
  }

  Future<List<Map>> getStats() async {
    // Query the table for current blackjack stats.
    final List<Map<String, dynamic>> maps = await db.query('blackjack',
    where: "id = ?",
    whereArgs: [1]);

    // Convert the List<Map<String, dynamic> into a List.
    return maps;
  }

  Future<void> clearStats() async {
    // Remove the Dog from the Database.
    await db.delete(
      'blackjack',
      where: "id = 1",
      // Pass the id as a whereArg to prevent SQL injection.
      whereArgs: [1],
    );
  }
}
