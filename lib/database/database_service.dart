import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'database_user.dart';
import 'database_course.dart';
import 'database_cart.dart';
import 'database_mycourse.dart';
import 'database_notification.dart';
import 'database_history.dart';

class DatabaseService {
  static const _dbName = 'app_database.db';
  static const _dbVersion = 2;

  static Database? _database;
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  bool _initialEmitsDone = false;

  // Reactive controllers
  final _usersController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get usersStream => _usersController.stream;

  final _coursesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get coursesStream =>
      _coursesController.stream;

  final _cartController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get cartStream => _cartController.stream;

  final _notificationsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get notificationsStream =>
      _notificationsController.stream;

  // DATABASE GETTER
  Future<Database> get database async {
    print(
      'DatabaseService: database getter called; cached=${_database != null}',
    );

    if (_database != null) {
      try {
        if (!_database!.isOpen) {
          print('DatabaseService: cached DB closed, reopening.');
          _database = null;
        }
      } catch (_) {
        _database = null;
      }
    }

    final wasNull = _database == null;

    _database ??= await _initDatabase();
    print('DatabaseService: database opened.');

    if (wasNull && !_initialEmitsDone) {
      _initialEmitsDone = true;
      try {
        await emitUsers();
        await emitCourses();
        await emitCarts();
        await emitNotifications();
      } catch (_) {}
    }

    return _database!;
  }

  // INIT
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    print('DatabaseService: _initDatabase path=$path');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: (db, oldV, newV) async {
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

  // ON CREATE
  Future<void> _onCreate(Database db, int version) async {
    print('DatabaseService: _onCreate start (version=$version)');

    await DatabaseUser.createTable(db);
    await DatabaseCourse.createTable(db);
    await DatabaseCart.createTable(db);
    await DatabaseMyCourse.createTable(db);
    await DatabaseNotification.createTable(db);
    await DatabaseHistory.createTable(db);

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
  }
}
