import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AuthRepository {
  static const _dbName = 'projek_mobile.db';
  static const _dbVersion =
      2; // versi > 1 agar onUpgrade jalan untuk kolom baru
  static const _table = 'users';

  Database? _db;

  // ================== PUBLIC HELPERS (VALIDATION) ==================
  bool isValidGmail(String email) {
    final re = RegExp(r'^[a-zA-Z0-9._%+\-]+@gmail\.com$');
    return re.hasMatch(email.trim());
  }

  /// Minimal 8, ada uppercase, lowercase, dan symbol.
  bool isValidPassword(String password) {
    if (password.length < 8) return false;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasSymbol = RegExp(
      r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+;]',
    ).hasMatch(password);
    return hasUpper && hasLower && hasSymbol;
  }

  // ================== DB INIT ==================
  Future<Database> get _database async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath(); // dari sqflite (tanpa path_provider)
    final fullPath = p.join(dir, _dbName);
    _db = await openDatabase(
      fullPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_table(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          username TEXT,
          avatar_path TEXT,
          created_at TEXT
        );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // tambahkan kolom jika db lama belum punya
        if (oldVersion < 2) {
          try {
            await db.execute('ALTER TABLE $_table ADD COLUMN username TEXT;');
          } catch (_) {}
          try {
            await db.execute(
              'ALTER TABLE $_table ADD COLUMN avatar_path TEXT;',
            );
          } catch (_) {}
        }
      },
    );
    return _db!;
  }

  // ================== AUTH CORE ==================
  Future<void> register(String email, String password) async {
    final db = await _database;

    // Pastikan unik
    final exists = await emailExists(email);
    if (exists) {
      throw Exception('Email already registered.');
    }

    await db.insert(_table, {
      'email': email.trim().toLowerCase(),
      'password': password, // NOTE: demo plain-text; idealnya hashed
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<bool> verifyCredentials(String email, String password) async {
    final db = await _database;
    final res = await db.query(
      _table,
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<bool> emailExists(String email) async {
    final db = await _database;
    final res = await db.query(
      _table,
      columns: const ['id'],
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _database;
    final res = await db.query(
      _table,
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return res.first;
  }

  /// Update sebagian/semua kolom profil berdasarkan email sekarang.
  /// - Validasi email baru (jika diisi): harus @gmail.com dan unik.
  Future<void> updateProfile({
    required String currentEmail,
    String? newEmail,
    String? username,
    String? avatarPath,
  }) async {
    final db = await _database;
    final current = currentEmail.trim().toLowerCase();
    final updates = <String, Object?>{};

    if (newEmail != null && newEmail.trim().toLowerCase() != current) {
      if (!isValidGmail(newEmail)) {
        throw Exception('Email must be a valid @gmail.com address.');
      }
      final taken = await emailExists(newEmail);
      if (taken) throw Exception('Email is already used by another account.');
      updates['email'] = newEmail.trim().toLowerCase();
    }

    if (username != null && username.trim().isNotEmpty) {
      updates['username'] = username.trim();
    }

    if (avatarPath != null && avatarPath.trim().isNotEmpty) {
      updates['avatar_path'] = avatarPath.trim();
    }

    if (updates.isEmpty) return;

    final count = await db.update(
      _table,
      updates,
      where: 'email = ?',
      whereArgs: [current],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    if (count == 0) {
      throw Exception('User not found.');
    }
  }
}
