import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:projek_mobile/models/explore_model.dart';

class DbHelper {
  static const _dbName = 'explore_courses.db';
  static const _dbVersion = 2;
  static const courseTable = 'courses';
  static const userTable = 'users';

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
        // Courses
        await db.execute('''
          CREATE TABLE $courseTable (
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
          'CREATE INDEX IF NOT EXISTS idx_bestseller ON $courseTable(is_bestseller, rating_number DESC);',
        );
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_category_title ON $courseTable(category, title);',
        );

        // Users
        await _createUsersTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createUsersTable(db);
        }
      },
    );
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $userTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON $userTable(email);',
    );
  }

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
    _db = null;
  }

  // =============== COURSES (tetap seperti sebelumnya) ===============
  Future<int> count() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as n FROM $courseTable');
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
          courseTable,
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
      courseTable,
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
      courseTable,
      where: 'LOWER(title) LIKE ? OR LOWER(category) LIKE ?',
      whereArgs: ['%$key%', '%$key%'],
      limit: 5,
    );
    return rows.map(Course.fromMap).toList();
  }

  Future<List<Course>> getAll({int? limit, int? offset}) async {
    final db = await database;
    final rows = await db.query(
      courseTable,
      orderBy: 'title ASC',
      limit: limit,
      offset: offset,
    );
    return rows.map(Course.fromMap).toList();
  }

  // ==================== USERS (baru) ====================
  Future<int> createUser({
    required String email,
    required String passwordHash,
  }) async {
    final db = await database;
    return db.insert(userTable, {
      'email': email,
      'password_hash': passwordHash,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final rows = await db.query(
      userTable,
      where: 'LOWER(email) = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }
}
