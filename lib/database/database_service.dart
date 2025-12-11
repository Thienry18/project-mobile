import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'database_user.dart';
import 'database_course.dart';
import 'database_cart.dart';
import 'database_mycourse.dart';
import 'database_notification.dart';
import 'database_history.dart';
<<<<<<< HEAD

class DatabaseService {
  static const _dbName = 'app_database.db';
  static const _dbVersion = 2;
=======
// Seed data

class DatabaseService {
  static const _dbName = 'app_database.db';
  static const _dbVersion = 2; // bumped to add user avatar/pin columns
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57

  static Database? _database;
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();
<<<<<<< HEAD

  bool _initialEmitsDone = false;

  // Reactive controllers
  final _usersController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get usersStream => _usersController.stream;

=======
  bool _initialEmitsDone = false;
  // Streams for reactive UI
  // Broadcast so multiple listeners can subscribe
  final _usersController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get usersStream => _usersController.stream;
  // Courses stream
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  final _coursesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get coursesStream =>
      _coursesController.stream;

<<<<<<< HEAD
=======
  // Cart stream (all cart rows; consumers filter by user_id)
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  final _cartController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get cartStream => _cartController.stream;

<<<<<<< HEAD
=======
  // Notifications stream
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  final _notificationsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get notificationsStream =>
      _notificationsController.stream;

<<<<<<< HEAD
  // DATABASE GETTER
  Future<Database> get database async {
=======
  // Getter utama
  Future<Database> get database async {
    // Debug: log when database getter is invoked
    // ignore: avoid_print
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    print(
      'DatabaseService: database getter called; cached=${_database != null}',
    );

<<<<<<< HEAD
    if (_database != null) {
      try {
        if (!_database!.isOpen) {
          print('DatabaseService: cached DB closed, reopening.');
          _database = null;
        }
      } catch (_) {
=======
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
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
        _database = null;
      }
    }

    final wasNull = _database == null;
<<<<<<< HEAD

    _database ??= await _initDatabase();
    print('DatabaseService: database opened.');

=======
    // debug
    // ignore: avoid_print
    print('DatabaseService: opening database...');
    _database ??= await _initDatabase();
    // ignore: avoid_print
    print('DatabaseService: database opened');

    // After the DB is opened for the first time, emit initial snapshots once.
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    if (wasNull && !_initialEmitsDone) {
      _initialEmitsDone = true;
      try {
        await emitUsers();
<<<<<<< HEAD
        await emitCourses();
        await emitCarts();
=======
      } catch (_) {}
      try {
        await emitCourses();
      } catch (_) {}
      try {
        await emitCarts();
      } catch (_) {}
      try {
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
        await emitNotifications();
      } catch (_) {}
    }

    return _database!;
  }

<<<<<<< HEAD
  // INIT
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
=======
  // ====================== INIT DATABASE ======================
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    // debug: show path about to be opened
    // ignore: avoid_print
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
    print('DatabaseService: _initDatabase path=$path');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: (db, oldV, newV) async {
<<<<<<< HEAD
=======
        // If we upgrade from v1 -> v2, ensure new columns exist in users table
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
        if (oldV < 2) {
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseUser.table} ADD COLUMN avatar_path TEXT;',
            );
          } catch (_) {}
<<<<<<< HEAD

=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseUser.table} ADD COLUMN pin TEXT;',
            );
          } catch (_) {}
<<<<<<< HEAD

=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
          try {
            await db.execute(
              'ALTER TABLE ${DatabaseUser.table} ADD COLUMN interest TEXT;',
            );
          } catch (_) {}
        }
<<<<<<< HEAD

=======
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
        await _onUpgrade(db, oldV, newV);
      },
    );
  }

<<<<<<< HEAD
  // ON CREATE
  Future<void> _onCreate(Database db, int version) async {
    print('DatabaseService: _onCreate start (version=$version)');

=======
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
    await DatabaseHistory.createTable(db);
<<<<<<< HEAD

    print('✅ All tables created successfully.');
    print('DatabaseService: _onCreate end.');
  }

  // ON UPGRADE
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('⚙️ Upgrading database from v$oldVersion → v$newVersion...');
  }

  // CLOSE
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      print('🧹 Database closed.');
    }
  }

  // RESET
  Future<void> resetDatabase() async {
    final path = p.join(await getDatabasesPath(), _dbName);

    if (_database != null) {
      try {
        if (_database!.isOpen) await _database!.close();
      } catch (_) {}
      _database = null;
    }

    await deleteDatabase(path);
    print('🗑️ Database reset complete.');
  }

  // STREAM EMITTERS
  Future<void> emitUsers() async {
    final db = await database;
    _usersController.add(await DatabaseUser.getAllUsers(db));
  }

  Future<void> emitCourses() async {
    final db = await database;
    _coursesController.add(await DatabaseCourse.getAllCourses(db));
  }

  Future<void> emitCarts() async {
    final db = await database;
    _cartController.add(await db.query(DatabaseCart.table));
  }

  Future<void> emitNotifications() async {
    final db = await database;
    _notificationsController.add(
      await db.query(DatabaseNotification.table, orderBy: 'created_at DESC'),
    );
=======
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
>>>>>>> be7823f0cb885709fde4a5a2246c8ccdb8d51f57
  }
}
