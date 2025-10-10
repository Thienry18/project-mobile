import 'package:projek_mobile/models/explore_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:projek_mobile/database/database_service.dart';

class DatabaseCourse {
  static const table = 'courses';

  // ===================== CREATE TABLE =====================
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        idx INTEGER PRIMARY KEY,
        images TEXT NOT NULL,
        title TEXT NOT NULL,
        duration TEXT NOT NULL,
        rating_text TEXT NOT NULL,
        rating_number REAL NOT NULL,
        price TEXT NOT NULL,
        is_bestseller INTEGER NOT NULL,
        category TEXT NOT NULL,
        instructor TEXT NOT NULL,
        language TEXT NOT NULL,
        subtitle TEXT NOT NULL
      );
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_bestseller ON $table(is_bestseller, rating_number DESC);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_category_title ON $table(category, title);',
    );
  }

  // ===================== INSERTIONS =====================

  static Future<int> insertCourse(
    Database db,
    Map<String, dynamic> data,
  ) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertTrendingCourses(
    Database db,
    List<Course> courses,
  ) async {
    // Cegah duplikasi data jika sudah ada
    final existing = await db.query(table);
    if (existing.isNotEmpty) {
      print('✅ Course data already exists, skipping insert.');
      return;
    }

    for (final course in courses) {
      final ratingParts = course.rating.split(' ');
      final ratingNumber = double.tryParse(ratingParts.first) ?? 0.0;

      await db.insert(table, {
        'idx': course.index,
        'images': course.images,
        'title': course.title,
        'duration': course.duration,
        'rating_text': course.rating,
        'rating_number': ratingNumber,
        'price': course.price,
        'is_bestseller': course.isBestseller ? 1 : 0,
        'category': course.category,
        'instructor': course.instructor,
        'language': course.language,
        'subtitle': course.subtitle,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    print('✅ ${courses.length} trending courses inserted successfully.');
    // Emit updated course list
    try {
      await DatabaseService.instance.emitCourses();
    } catch (_) {}
  }

  static Future<void> insertAll(Database db, List<Course> list) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final c in list) {
        batch.insert(
          table,
          c.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  // ===================== QUERIES =====================

  static Future<List<Map<String, dynamic>>> getAllCourses(Database db) async {
    return await db.query(table, orderBy: 'title ASC');
  }

  static Future<List<Course>> getAll(
    Database db, {
    int? limit,
    int? offset,
  }) async {
    final rows = await db.query(
      table,
      orderBy: 'title ASC',
      limit: limit,
      offset: offset,
    );
    return rows.map(Course.fromMap).toList();
  }

  static Future<List<Course>> getTrendingTop5(Database db) async {
    final rows = await db.query(
      table,
      where: 'is_bestseller = ?',
      whereArgs: [1],
      orderBy: 'rating_number DESC, title ASC',
      limit: 5,
    );
    return rows.map(Course.fromMap).toList();
  }

  static Future<List<Course>> getRecommendedForYou(
    Database db,
    String category,
  ) async {
    final key = category.toLowerCase();
    final rows = await db.query(
      table,
      where: 'LOWER(title) LIKE ? OR LOWER(category) LIKE ?',
      whereArgs: ['%$key%', '%$key%'],
      limit: 5,
    );
    return rows.map(Course.fromMap).toList();
  }

  static Future<Course?> getCourseById(Database db, int idx) async {
    final rows = await db.query(
      table,
      where: 'idx = ?',
      whereArgs: [idx],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Course.fromMap(rows.first);
  }

  // Convenience wrappers using DatabaseService
  static Future<Course?> getCourseByIdForApp(int idx) async {
    final db = await DatabaseService.instance.database;
    return getCourseById(db, idx);
  }

  static Future<List<Course>> getRecommendedForYouForApp(
    String category,
  ) async {
    final db = await DatabaseService.instance.database;
    return getRecommendedForYou(db, category);
  }

  static Future<int> count(Database db) async {
    final res = await db.rawQuery('SELECT COUNT(*) as n FROM $table');
    final n = res.first['n'];
    if (n is int) return n;
    if (n is num) return n.toInt();
    return 0;
  }

  // ===================== DELETIONS =====================

  static Future<int> deleteCourse(Database db, int id) async {
    return await db.delete(table, where: 'idx = ?', whereArgs: [id]);
  }

  // Convenience wrapper for app usage which emits after delete
  static Future<int> deleteCourseForApp(int id) async {
    final db = await DatabaseService.instance.database;
    final res = await deleteCourse(db, id);
    try {
      await DatabaseService.instance.emitCourses();
    } catch (_) {}
    return res;
  }
}
