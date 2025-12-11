import 'package:sqflite/sqflite.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/models/explore_model.dart';

class DatabaseCart {
  static const table = 'cart';

<<<<<<< HEAD
  // ===================== CREATE TABLE =====================
=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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
        FOREIGN KEY (course_id) REFERENCES courses(idx),
        UNIQUE(user_id, course_id) ON CONFLICT REPLACE
      );
    ''');
  }

<<<<<<< HEAD
  // ===================== BASIC INSERT =====================
=======
  // Insert cart item (copy course details)
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  static Future<int> addToCart(Database db, Map<String, dynamic> data) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

<<<<<<< HEAD
  // ===================== UPSERT (AVOID DUPLICATE user_id + course_id) =====================
=======
  // Insert or replace by checking existing (user_id + course_id)
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  static Future<int> upsertCartItem(
    Database db,
    Map<String, dynamic> data,
  ) async {
    final userId = data['user_id'] as int?;
    final courseId = data['course_id'] as int?;
<<<<<<< HEAD

    if (userId == null || courseId == null) {
      throw ArgumentError("user_id and course_id are required for upsert");
=======
    if (userId == null || courseId == null) {
      throw ArgumentError('user_id and course_id are required for upsert');
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    }

    final existing = await db.query(
      table,
      where: 'user_id = ? AND course_id = ?',
      whereArgs: [userId, courseId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final id = existing.first['id'] as int;
<<<<<<< HEAD
=======
      // Update the existing row
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
      await db.update(table, data, where: 'id = ?', whereArgs: [id]);
      return id;
    }

    return await addToCart(db, data);
  }

<<<<<<< HEAD
  // ===================== GET CART FOR USER =====================
=======
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

  static Future<int> countUserCart(Database db, int userId) async {
    final res = await db.rawQuery(
<<<<<<< HEAD
      'SELECT COUNT(*) AS n FROM $table WHERE user_id = ?',
=======
      'SELECT COUNT(*) as n FROM $table WHERE user_id = ?',
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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

<<<<<<< HEAD
  // ===================== TOTAL PRICE (with parsing text price) =====================
  static Future<double> getUserCartTotal(Database db, int userId) async {
    final rows = await getUserCart(db, userId);
    double total = 0.0;

    for (final r in rows) {
      final priceText = (r['price'] as String?) ?? '';
      final cleaned = priceText
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^0-9.]'), '');

      total += double.tryParse(cleaned) ?? 0.0;
    }

    return total;
  }

  // ===================== DELETE =====================
=======
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

<<<<<<< HEAD
  // ===================== CONVENIENCE WRAPPERS (USE DB AUTOMATICALLY) =====================

  static Future<int> addCourseForUser(int userId, Course course) async {
    final db = await DatabaseService.instance.database;

=======
  // ===================== Convenience wrappers (obtain Database internally) =====================

  static Future<int> addCourseForUser(int userId, Course course) async {
    final db = await DatabaseService.instance.database;
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    final data = {
      'user_id': userId,
      'course_id': course.index,
      'title': course.title,
      'price': course.price,
      'instructor': course.instructor,
      'image': course.images,
      'added_at': DateTime.now().millisecondsSinceEpoch,
    };
<<<<<<< HEAD

    final res = await upsertCartItem(db, data);

    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}

=======
    // Use upsert to avoid creating duplicate cart rows for the same user+course
    final res = await upsertCartItem(db, data);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    return res;
  }

  static Future<int> upsertCourseForUser(int userId, Course course) async {
<<<<<<< HEAD
    return addCourseForUser(userId, course);
=======
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
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  }

  static Future<List<Map<String, dynamic>>> getUserCartMapsForUser(
    int userId,
  ) async {
    final db = await DatabaseService.instance.database;
    return getUserCart(db, userId);
  }

<<<<<<< HEAD
  static Stream<List<Map<String, dynamic>>> watchUserCartForUser(int userId) {
    return DatabaseService.instance.cartStream.map(
      (rows) => rows.where((r) => (r['user_id'] as int?) == userId).toList(),
    );
=======
  /// Reactive stream that emits cart rows for a given userId
  static Stream<List<Map<String, dynamic>>> watchUserCartForUser(int userId) {
    return DatabaseService.instance.cartStream.map((rows) {
      return rows.where((r) => (r['user_id'] as int?) == userId).toList();
    });
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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
<<<<<<< HEAD
    await clearUserCart(db, userId);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
=======
    final res = await clearUserCart(db, userId);
    try {
      await DatabaseService.instance.emitCarts();
    } catch (_) {}
    return res;
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
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
}
