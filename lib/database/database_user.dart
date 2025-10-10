import 'package:sqflite/sqflite.dart';
import 'package:projek_mobile/database/database_service.dart';

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

  // ===================== Convenience helpers =====================

  // Return the id of the first user, or create a demo user and return its id.
  static Future<int> getOrCreateDemoUserId(Database db) async {
    final rows = await getAllUsers(db);
    if (rows.isNotEmpty) return rows.first['id'] as int;

    final demo = {
      'username': 'demo',
      'fullname': 'Demo User',
      'day_of_birth': '2000-01-01',
      'gender': 'other',
      'phone_number': '-',
      'country': '-',
      'email': 'demo@example.com',
      'password': 'demo',
    };
    return await insertUser(db, demo);
  }

  static Future<int> getOrCreateDemoUserIdForApp() async {
    final db = await DatabaseService.instance.database;
    return getOrCreateDemoUserId(db);
  }

  // Returns true if there is at least one non-demo user.
  static Future<bool> hasAnyUser(Database db) async {
    final rows = await getAllUsers(db);
    return rows.isNotEmpty;
  }
}
