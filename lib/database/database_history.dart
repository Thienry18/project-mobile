import 'package:sqflite/sqflite.dart';

class DatabaseHistory {
  static const table = 'history';

  // Creates a simple history table for purchased or other historical records.
  // Fields mirror a subset of mycourse plus a source field to indicate origin.
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        course_id INTEGER,
        title TEXT NOT NULL,
        image TEXT,
        price TEXT,
        status TEXT DEFAULT 'completed',
        source TEXT DEFAULT 'system',
        occurred_at INTEGER NOT NULL
      );
    ''');
  }

  // Insert a history row
  static Future<int> addHistory(Database db, Map<String, dynamic> data) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get history rows for a user ordered by occurred_at desc
  static Future<List<Map<String, dynamic>>> getHistory(
    Database db,
    int userId,
  ) async {
    return await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'occurred_at DESC',
    );
  }

  // Clear history for a user
  static Future<int> clearHistoryForUser(Database db, int userId) async {
    return await db.delete(table, where: 'user_id = ?', whereArgs: [userId]);
  }
}
