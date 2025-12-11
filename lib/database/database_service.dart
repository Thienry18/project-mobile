<<<<<<< HEAD
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
=======
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
import 'database_user.dart';
import 'database_course.dart';
import 'database_cart.dart';
import 'database_mycourse.dart';
import 'database_notification.dart';
<<<<<<< HEAD

class DatabaseService {
  static const _dbName = 'app_database.db';
  static const _dbVersion = 1;
  static Database? _database;

  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

=======
import 'database_history.dart';
// Seed data

class DatabaseService {
  static const _dbName = 'app_database.db';
  static const _dbVersion = 2; // bumped to add user avatar/pin columns

  static Database? _database;
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();
  bool _initialEmitsDone = false;
  // Streams for reactive UI
  // Broadcast so multiple listeners can subscribe
  final _usersController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get usersStream => _usersController.stream;
  // Courses stream
  final _coursesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get coursesStream =>
      _coursesController.stream;

  // Cart stream (all cart rows; consumers filter by user_id)
  final _cartController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get cartStream => _cartController.stream;

  // Notifications stream
  final _notificationsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get notificationsStream =>
      _notificationsController.stream;

  // Getter utama
  Future<Database> get database async {
    // Debug: log when database getter is invoked
    // ignore: avoid_print
    print(
      'DatabaseService: database getter called; cached=${_database != null}',
    );

    // If we have a cached Database but it's closed, clear it so we reopen.
    if (_database != null) {
      try {
        if (!_database!.isOpen) {
          // ignore: avoid_print
          print('DatabaseService: cached database is closed; reopening');
          _database = null;
        }
      } catch (_) {
        // If checking isOpen throws, reset and reopen.
        // ignore: avoid_print
        print('DatabaseService: error checking isOpen, clearing cache');
        _database = null;
      }
    }

    final wasNull = _database == null;
    // debug
    // ignore: avoid_print
    print('DatabaseService: opening database...');
    _database ??= await _initDatabase();
    // ignore: avoid_print
    print('DatabaseService: database opened');

    // After the DB is opened for the first time, emit initial snapshots once.
    if (wasNull && !_initialEmitsDone) {
      _initialEmitsDone = true;
      try {
        await emitUsers();
      } catch (_) {}
      try {
        await emitCourses();
      } catch (_) {}
      try {
        await emitCarts();
      } catch (_) {}
      try {
        await emitNotifications();
      } catch (_) {}
    }

    return _database!;
  }

  // ====================== INIT DATABASE ======================
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

<<<<<<< HEAD
=======
    // debug: show path about to be opened
    // ignore: avoid_print
    print('DatabaseService: _initDatabase path=$path');

>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
<<<<<<< HEAD
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
=======
      onUpgrade: (db, oldV, newV) async {
        // If we upgrade from v1 -> v2, ensure new columns exist in users table
        if (oldV < 2) {
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseUser.table} ADD COLUMN avatar_path TEXT;',
            );
          } catch (_) {}
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseUser.table} ADD COLUMN pin TEXT;',
            );
          } catch (_) {}
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseUser.table} ADD COLUMN interest TEXT;',
            );
          } catch (_) {}
        }
        await _onUpgrade(db, oldV, newV);
      },
    );
  }

  // ====================== ON CREATE ======================
  Future<void> _onCreate(Database db, int version) async {
    // debug
    // ignore: avoid_print
    print('DatabaseService: _onCreate start (version=$version)');
    // Create tables using the provided `db` instance. The helper
    // createTable methods expect a `Database` (or DatabaseExecutor),
    // so call them with `db` here instead of a Transaction.
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    await DatabaseUser.createTable(db);
    await DatabaseCourse.createTable(db);
    await DatabaseCart.createTable(db);
    await DatabaseMyCourse.createTable(db);
    await DatabaseNotification.createTable(db);
<<<<<<< HEAD
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // handle upgrade logic di sini
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }
=======
    await DatabaseHistory.createTable(db);
    // Note: course seeding is performed by the app startup code
    // (ExploreRepository.seedIfEmpty) which runs before user interaction.
    // Avoid re-seeding here to prevent long DB operations during runtime.
    // debug
    // ignore: avoid_print
    print('✅ All tables created successfully.');
    // debug
    // ignore: avoid_print
    print('DatabaseService: _onCreate end');
    // Note: initial emits are performed by the database getter after the
    // database is opened to avoid calling the getter recursively during
    // onCreate (which may cause nested openDatabase calls).
  }

  // ====================== ON UPGRADE ======================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Contoh: jika nanti versi berubah, tambahkan perubahan di sini.
    // if (oldVersion < 2) await DatabaseUser.addNewColumn(db);
    print('⚙️ Upgrading database from v$oldVersion to v$newVersion...');
  }

  // ====================== CLOSE ======================
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      try {
        await db.close();
        // ignore: avoid_print
        print('🧹 Database closed successfully.');
      } catch (e) {
        // ignore: avoid_print
        print('DatabaseService.close: error closing DB: $e');
      }
    }
  }

  // ====================== HELPER ======================
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    // Close existing DB if open, then delete file.
    try {
      if (_database != null) {
        try {
          if (_database!.isOpen) {
            // ignore: avoid_print
            print(
              'DatabaseService.resetDatabase: closing open DB before delete',
            );
            await _database!.close();
          }
        } catch (e) {
          // ignore: avoid_print
          print('DatabaseService.resetDatabase: error closing DB: $e');
        }
        _database = null;
      }
    } catch (_) {}

    try {
      await deleteDatabase(path);
      // ignore: avoid_print
      print('🗑️ Database reset completed.');
    } catch (e) {
      // ignore: avoid_print
      print('DatabaseService.resetDatabase: deleteDatabase failed: $e');
      rethrow;
    }
  }

  // Emit current users list to the usersStream
  Future<void> emitUsers() async {
    try {
      final db = await database;
      final rows = await DatabaseUser.getAllUsers(db);
      _usersController.add(rows);
    } catch (e, st) {
      _usersController.addError(e, st);
    }
  }

  Future<void> emitCourses() async {
    try {
      final db = await database;
      final rows = await DatabaseCourse.getAllCourses(db);
      _coursesController.add(rows);
    } catch (e, st) {
      _coursesController.addError(e, st);
    }
  }

  Future<void> emitCarts() async {
    try {
      final db = await database;
      final rows = await db.query(DatabaseCart.table, orderBy: 'added_at DESC');
      _cartController.add(rows);
    } catch (e, st) {
      _cartController.addError(e, st);
    }
  }

  Future<void> emitNotifications() async {
    try {
      final db = await database;
      final rows = await db.query(
        DatabaseNotification.table,
        orderBy: 'created_at DESC',
      );
      _notificationsController.add(rows);
    } catch (e, st) {
      _notificationsController.addError(e, st);
    }
  }

  // IMPORTANT: do not close controllers unless app is shutting down
  void disposeStreams() {
    try {
      _usersController.close();
    } catch (_) {}
  }
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
}
