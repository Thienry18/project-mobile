import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:projek_mobile/models/explore_model.dart';

class DbHelper {
  static const _dbName = 'explore_courses.db';
  static const _dbVersion = 1;
  static const table = 'courses';

  static final DbHelper instance = DbHelper._();
  DbHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
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
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
  }

  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as n FROM $table');
    return (result.first['n'] as int?) ?? 0;
  }

  Future<void> insertAll(List<Course> courses) async {
    final db = await database;
    final batch = db.batch();
    for (final c in courses) {
      batch.insert(
        table,
        c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Course>> getTrendingTop5() async {
    final db = await database;
    final result = await db.query(
      table,
      where: 'is_bestseller = ?',
      whereArgs: [1],
      orderBy: 'rating_number DESC',
      limit: 5,
    );
    return result.map((e) => Course.fromMap(e)).toList();
  }

  Future<List<Course>> getRecommendedForYou(String category) async {
    final db = await database;
    final key = category.toLowerCase();
    final result = await db.query(
      table,
      where: 'LOWER(title) LIKE ? OR LOWER(category) LIKE ?',
      whereArgs: ['%$key%', '%$key%'],
      limit: 5,
    );
    return result.map((e) => Course.fromMap(e)).toList();
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(table);
  }
}
