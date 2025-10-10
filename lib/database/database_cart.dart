import 'package:sqflite/sqflite.dart';

class DatabaseCart {
  static const table = 'cart';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        course_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        price TEXT NOT NULL,
        instructor TEXT NOT NULL,
        image TEXT NOT NULL,
        added_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (course_id) REFERENCES courses(idx)
      );
    ''');
  }

  // Insert cart item (copy course details)
  static Future<int> addToCart(Database db, Map<String, dynamic> data) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getUserCart(
    Database db,
    int userId,
  ) async {
    return await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'added_at DESC',
    );
  }

  static Future<int> removeFromCart(Database db, int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearUserCart(Database db, int userId) async {
    await db.delete(table, where: 'user_id = ?', whereArgs: [userId]);
  }
}
