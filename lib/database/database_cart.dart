import 'package:sqflite/sqflite.dart';
<<<<<<< HEAD
=======
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/models/explore_model.dart';
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57

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
<<<<<<< HEAD
        FOREIGN KEY (course_id) REFERENCES courses(idx)
=======
        FOREIGN KEY (course_id) REFERENCES courses(idx),
        UNIQUE(user_id, course_id) ON CONFLICT REPLACE
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
=======
  // Insert or replace by checking existing (user_id + course_id)
  static Future<int> upsertCartItem(
    Database db,
    Map<String, dynamic> data,
  ) async {
    final userId = data['user_id'] as int?;
    final courseId = data['course_id'] as int?;
    if (userId == null || courseId == null) {
      throw ArgumentError('user_id and course_id are required for upsert');
    }

    final existing = await db.query(
      table,
      where: 'user_id = ? AND course_id = ?',
      whereArgs: [userId, courseId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final id = existing.first['id'] as int;
      // Update the existing row
      await db.update(table, data, where: 'id = ?', whereArgs: [id]);
      return id;
    }

    return await addToCart(db, data);
  }

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
=======
  static Future<int> countUserCart(Database db, int userId) async {
    final res = await db.rawQuery(
      'SELECT COUNT(*) as n FROM $table WHERE user_id = ?',
      [userId],
    );
    final n = res.first['n'];
    if (n is int) return n;
    if (n is num) return n.toInt();
    return 0;
  }

  static Future<bool> existsInCart(
    Database db,
    int userId,
    int courseId,
  ) async {
    final res = await db.rawQuery(
      'SELECT 1 FROM $table WHERE user_id = ? AND course_id = ? LIMIT 1',
      [userId, courseId],
    );
    return res.isNotEmpty;
  }

  // Total price calculation: price stored as TEXT, so fetch rows and parse.
  static Future<double> getUserCartTotal(Database db, int userId) async {
    final rows = await getUserCart(db, userId);
    double total = 0.0;
    for (final r in rows) {
      final priceText = (r['price'] as String?) ?? '';
      // Remove non-digit except dot and comma, convert comma to dot
      final cleaned = priceText
          .replaceAll(',', '.')
          .replaceAll(RegExp(r"[^0-9.]"), '');
      final value = double.tryParse(cleaned) ?? 0.0;
      total += value;
    }
    return total;
  }

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  static Future<int> removeFromCart(Database db, int id) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearUserCart(Database db, int userId) async {
    await db.delete(table, where: 'user_id = ?', whereArgs: [userId]);
  }
<<<<<<< HEAD
=======

  static Future<int> removeByUserCourse(
    Database db,
    int userId,
    int courseId,
  ) async {
    return await db.delete(
      table,
      where: 'user_id = ? AND course_id = ?',
      whereArgs: [userId, courseId],
    );
  }

  // ===================== Convenience wrappers (obtain Database internally) =====================

  static Future<int> addCourseForUser(int userId, Course course) async {
    final db = await DatabaseService.instance.database;
    final data = {
      'user_id': userId,
      'course_id': course.index,
      'title': course.title,
      'price': course.price,
      'instructor': course.instructor,
      'image': course.images,
      'added_at': DateTime.now().millisecondsSinceEpoch,
    };
    // Use upsert to avoid creating duplicate cart rows for the same user+course
    final res = await upsertCartItem(db, data);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
    return res;
  }

  static Future<int> upsertCourseForUser(int userId, Course course) async {
    final db = await DatabaseService.instance.database;
    final data = {
      'user_id': userId,
      'course_id': course.index,
      'title': course.title,
      'price': course.price,
      'instructor': course.instructor,
      'image': course.images,
      'added_at': DateTime.now().millisecondsSinceEpoch,
    };
    final res = await upsertCartItem(db, data);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
    return res;
  }

  static Future<List<Map<String, dynamic>>> getUserCartMapsForUser(
    int userId,
  ) async {
    final db = await DatabaseService.instance.database;
    return getUserCart(db, userId);
  }

  /// Reactive stream that emits cart rows for a given userId
  static Stream<List<Map<String, dynamic>>> watchUserCartForUser(int userId) {
    return DatabaseService.instance.cartStream.map((rows) {
      return rows.where((r) => (r['user_id'] as int?) == userId).toList();
    });
  }

  static Future<int> removeFromCartById(int id) async {
    final db = await DatabaseService.instance.database;
    final res = await removeFromCart(db, id);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
    return res;
  }

  static Future<void> clearUserCartForUser(int userId) async {
    final db = await DatabaseService.instance.database;
    final res = await clearUserCart(db, userId);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
    return res;
  }

  static Future<int> countUserCartForUser(int userId) async {
    final db = await DatabaseService.instance.database;
    return countUserCart(db, userId);
  }

  static Future<double> getUserCartTotalForUser(int userId) async {
    final db = await DatabaseService.instance.database;
    return getUserCartTotal(db, userId);
  }

  static Future<bool> existsInCartForUser(int userId, int courseId) async {
    final db = await DatabaseService.instance.database;
    return existsInCart(db, userId, courseId);
  }

  static Future<int> removeByUserCourseForUser(int userId, int courseId) async {
    final db = await DatabaseService.instance.database;
    final res = await removeByUserCourse(db, userId, courseId);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
    return res;
  }
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
}
