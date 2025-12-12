import 'package:sqflite/sqflite.dart';
import 'package:projek_mobile/database/database_service.dart';

class DatabaseNotification {
  static const table = 'notifications';

  // ===================== CREATE TABLE =====================
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        course_id INTEGER,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        course_title TEXT,
        course_image TEXT,
        course_price TEXT,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      );
    ''');
  }

  // ===================== INSERT BASIC =====================
  static Future<int> insertNotification(
    Database db,
    Map<String, dynamic> data,
  ) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Wrapper untuk insert + emit stream
  static Future<int> insertNotificationForApp(Map<String, dynamic> data) async {
    final db = await DatabaseService.instance.database;
    final res = await insertNotification(db, data);

    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}

    return res;
  }

  // ===================== GET USER NOTIFICATIONS =====================
  static Future<List<Map<String, dynamic>>> getUserNotifications(
    Database db,
    int userId,
  ) async {
    return await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // ===================== MARK AS READ =====================
  static Future<int> markAsRead(Database db, int id) async {
    return await db.update(
      table,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> markAsReadForApp(int id) async {
    final db = await DatabaseService.instance.database;
    final res = await markAsRead(db, id);

    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}

    return res;
  }

  // ===================== DELETE =====================
  static Future<int> deleteNotification(Database db, int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteNotificationForApp(int id) async {
    final db = await DatabaseService.instance.database;
    final res = await deleteNotification(db, id);

    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}

    return res;
  }

  // ===================== CLEAR ALL =====================
  static Future<void> clearAll(Database db, int userId) async {
    await db.delete(table, where: 'user_id = ?', whereArgs: [userId]);
  }

  static Future<void> clearAllForApp(int userId) async {
    final db = await DatabaseService.instance.database;
    await clearAll(db, userId);

    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}
  }

  // ===================== STREAM (REACTIVE) =====================
  static Stream<List<Map<String, dynamic>>> watchNotificationsForUser(
    int userId,
  ) {
    return DatabaseService.instance.notificationsStream.map(
      (rows) => rows.where((r) => (r['user_id'] as int?) == userId).toList(),
    );
  }
}
