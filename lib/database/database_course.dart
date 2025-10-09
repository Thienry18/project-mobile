import 'package:sqflite/sqflite.dart';

class DatabaseCourse {
  static const table = 'courses';

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
  }

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

  static Future<List<Map<String, dynamic>>> getAllCourses(Database db) async {
    return await db.query(table, orderBy: 'title ASC');
  }

  static Future<int> deleteCourse(Database db, int id) async {
    return await db.delete(table, where: 'idx = ?', whereArgs: [id]);
  }
}
