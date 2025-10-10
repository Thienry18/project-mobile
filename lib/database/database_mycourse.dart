import 'package:sqflite/sqflite.dart';

class DatabaseMyCourse {
  static const table = 'mycourse';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        course_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        instructor TEXT NOT NULL,
        image TEXT NOT NULL,
        price TEXT NOT NULL,
        purchased_at INTEGER NOT NULL,
        progress REAL DEFAULT 0.0,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (course_id) REFERENCES courses(idx)
      );
    ''');
  }

  // Insert purchased course (snapshot dari course)
  static Future<int> addMyCourse(Database db, Map<String, dynamic> data) async {
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getMyCourses(
    Database db,
    int userId,
  ) async {
    return await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'purchased_at DESC',
    );
  }

  static Future<int> updateProgress(
    Database db,
    int id,
    double progress,
  ) async {
    return await db.update(
      table,
      {'progress': progress},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
