import 'package:sqflite/sqflite.dart';
import 'package:projek_mobile/database/database_service.dart';

class DatabaseNotification {
  static const table = 'notifications';

<<<<<<< HEAD
  // ===================== CREATE TABLE =====================
=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
  // ===================== INSERT BASIC =====================
=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
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
=======
  static Future<int> insertNotificationForApp(Map<String, dynamic> data) async {
    final db = await DatabaseService.instance.database;
    final res = await insertNotification(db, data);
    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}
    return res;
  }

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
  // ===================== MARK AS READ =====================
=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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
<<<<<<< HEAD

    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}

    return res;
  }

  // ===================== DELETE =====================
=======
    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}
    return res;
  }

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  static Future<int> deleteNotification(Database db, int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteNotificationForApp(int id) async {
    final db = await DatabaseService.instance.database;
    final res = await deleteNotification(db, id);
<<<<<<< HEAD

    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}

    return res;
  }

  // ===================== CLEAR ALL =====================
=======
    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}
    return res;
  }

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  static Future<void> clearAll(Database db, int userId) async {
    await db.delete(table, where: 'user_id = ?', whereArgs: [userId]);
  }

  static Future<void> clearAllForApp(int userId) async {
    final db = await DatabaseService.instance.database;
<<<<<<< HEAD
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
=======
    final res = await clearAll(db, userId);
    try {
      await DatabaseService.instance.emitNotifications();
    } catch (_) {}
    return res;
  }

  /// Reactive stream that emits notifications for a given user id
  static Stream<List<Map<String, dynamic>>> watchNotificationsForUser(
    int userId,
  ) {
    return DatabaseService.instance.notificationsStream.map((rows) {
      return rows.where((r) => (r['user_id'] as int?) == userId).toList();
    });
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  }
}
