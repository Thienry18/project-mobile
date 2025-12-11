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
        password TEXT NOT NULL,
        avatar_path TEXT,
        pin TEXT,
        interest TEXT
      );
    ''');
  }

<<<<<<< HEAD
  // ===================== BASIC CRUD =====================

=======
  // CRUD
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
=======
  // Convenience: update user by email (find id then update)
  static Future<int> updateUserByEmail(
    Database db,
    String email,
    Map<String, dynamic> data,
  ) async {
    final user = await getUserByEmail(db, email);
    if (user == null) return 0;
    final id = user['id'] as int;
    return updateUser(db, id, data);
  }

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
  // ===================== CONVENIENCE HELPERS =====================

  static Future<int> updateUserByEmail(
    Database db,
    String email,
    Map<String, dynamic> data,
  ) async {
    final user = await getUserByEmail(db, email);
    if (user == null) return 0;

    final id = user['id'] as int;
    return updateUser(db, id, data);
  }

  // Get first user or create demo user
=======
  // ===================== Convenience helpers =====================

  // Return the id of the first user, or create a demo user and return its id.
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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
<<<<<<< HEAD

=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    return await insertUser(db, demo);
  }

  static Future<int> getOrCreateDemoUserIdForApp() async {
    final db = await DatabaseService.instance.database;
<<<<<<< HEAD
    return await getOrCreateDemoUserId(db);
  }

=======
    return getOrCreateDemoUserId(db);
  }

  // Returns true if there is at least one non-demo user.
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  static Future<bool> hasAnyUser(Database db) async {
    final rows = await getAllUsers(db);
    return rows.isNotEmpty;
  }
}
