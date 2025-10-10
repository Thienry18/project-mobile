import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'database_user.dart';
import 'database_course.dart';
import 'database_cart.dart';
import 'database_mycourse.dart';
import 'database_notification.dart';
import 'database_history.dart';
// Seed data
import '../data/explore_data.dart' show trendingCourses;

class DatabaseService {
  static const _dbName = 'app_database.db';
  static const _dbVersion = 2; // bumped to add user avatar/pin columns

  static Database? _database;
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();
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
    _database ??= await _initDatabase();
    return _database!;
  }

  // ====================== INIT DATABASE ======================
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
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
    // Create tables using the provided `db` instance. The helper
    // createTable methods expect a `Database` (or DatabaseExecutor),
    // so call them with `db` here instead of a Transaction.
    await DatabaseUser.createTable(db);
    await DatabaseCourse.createTable(db);
    await DatabaseCart.createTable(db);
    await DatabaseMyCourse.createTable(db);
    await DatabaseNotification.createTable(db);
    await DatabaseHistory.createTable(db);
    // Try to seed courses table with trending data (idempotent inside helper)
    try {
      await DatabaseCourse.insertTrendingCourses(db, trendingCourses);
      print('✅ Seeded courses into app_database.db');
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ Could not seed courses into app_database.db: $e');
    }
    print('✅ All tables created successfully.');

    // Emit initial snapshots for any listeners
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
      await db.close();
      print('🧹 Database closed successfully.');
    }
  }

  // ====================== HELPER ======================
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    await deleteDatabase(path);
    _database = null;
    print('🗑️ Database reset completed.');
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
}
