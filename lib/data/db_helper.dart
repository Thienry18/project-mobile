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
    final dbPath = await getDatabasesPath(); // dari sqflite
    final path = p.join(
      dbPath,
      _dbName,
    ); // pakai package path (bukan path_provider)

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
          );
        ''');

        // (opsional) index untuk performa
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_bestseller ON $table(is_bestseller, rating_number DESC);',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_category_title ON $table(category, title);',
        );
      },
    );
  }

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
    _db = null;
  }

  // ---------- CRUD / Query ----------
  Future<int> count() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as n FROM $table');
    final n = res.first['n'];
    if (n is int) return n;
    if (n is num) return n.toInt();
    return 0;
  }

  Future<void> insertAll(List<Course> list) async {
    final db = await database;
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

  Future<List<Course>> getTrendingTop5() async {
    final db = await database;
    final rows = await db.query(
      table,
      where: 'is_bestseller = ?',
      whereArgs: [1],
      orderBy: 'rating_number DESC, title ASC',
      limit: 5,
    );
    return rows.map(Course.fromMap).toList();
  }

  Future<List<Course>> getRecommendedForYou(String category) async {
    final db = await database;
    final key = category.toLowerCase();
    final rows = await db.query(
      table,
      where: 'LOWER(title) LIKE ? OR LOWER(category) LIKE ?',
      whereArgs: ['%$key%', '%$key%'],
      limit: 5,
    );
    return rows.map(Course.fromMap).toList();
  }

  // >>> Tambahan: ambil SEMUA data (untuk list/filter/search)
  Future<List<Course>> getAll({int? limit, int? offset}) async {
    final db = await database;
    final rows = await db.query(
      table,
      orderBy: 'title ASC',
      limit: limit,
      offset: offset,
    );
    return rows.map(Course.fromMap).toList();
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(table);
  }
}
