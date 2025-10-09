import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'database_user.dart';
import 'database_course.dart';
import 'database_cart.dart';
import 'database_mycourse.dart';
import 'database_notification.dart';

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

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await DatabaseUser.createTable(db);
    await DatabaseCourse.createTable(db);
    await DatabaseCart.createTable(db);
    await DatabaseMyCourse.createTable(db);
    await DatabaseNotification.createTable(db);
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
}
