import 'package:sqflite/sqflite.dart';

class DatabaseUser {
  static const table = 'users';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        fullname TEXT NOT NULL,
        day_of_birth TEXT NOT NULL,
        gender TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        country TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      );
    ''');
  }

  // CRUD
  static Future<int> insertUser(Database db, Map<String, dynamic> data) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllUsers(Database db) async {
    return await db.query(table);
  }

  static Future<Map<String, dynamic>?> getUserByEmail(
    Database db,
    String email,
  ) async {
    final res = await db.query(
      table,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return res.isNotEmpty ? res.first : null;
  }

  static Future<int> updateUser(
    Database db,
    int id,
    Map<String, dynamic> data,
  ) async {
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteUser(Database db, int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
