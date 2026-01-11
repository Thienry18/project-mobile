import 'package:sqflite/sqflite.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ===================== BASIC CRUD =====================

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
    return await getOrCreateDemoUserId(db);
  }

  /// Resolve the application user id for the currently-signed-in app user.
  ///
  /// The method prefers a real user found by `user_email` saved in
  /// `SharedPreferences`. If not found, it falls back to the demo user id.
  static Future<int> getOrCreateUserIdForCurrentAppUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final db = await DatabaseService.instance.database;

    if (email != null && email.isNotEmpty) {
      final existing = await getUserByEmail(db, email.trim().toLowerCase());
      if (existing != null) return existing['id'] as int;

      // Create a minimal user row for this email so local tables can be
      // associated with the correct account.
      final data = {
        'username': prefs.getString('user_username') ?? '',
        'fullname': prefs.getString('user_username') ?? '',
        'day_of_birth': '',
        'gender': '',
        'phone_number': '',
        'country': '',
        'email': email.trim().toLowerCase(),
        'password': '',
      };
      return await insertUser(db, data);
    }

    return await getOrCreateDemoUserId(db);
  }

  static Future<bool> hasAnyUser(Database db) async {
    final rows = await getAllUsers(db);
    return rows.isNotEmpty;
  }
}
