import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepository {
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

  // ================== AUTH CORE (using DatabaseService + DatabaseUser) ==================
  Future<Database> get _db async => await DatabaseService.instance.database;

  Future<void> register(String email, String password) async {
    final db = await _db;
    final exists = await DatabaseUser.getUserByEmail(
      db,
      email.trim().toLowerCase(),
    );
    if (exists != null) throw Exception('Email already registered.');

    await DatabaseUser.insertUser(db, {
      'email': email.trim().toLowerCase(),
      'password': password,
      'username': '',
      'fullname': '',
      'day_of_birth': '',
      'gender': '',
      'phone_number': '',
      'country': '',
      'avatar_path': '',
      'pin': null,
    });
  }

  Future<bool> verifyCredentials(String email, String password) async {
    final db = await _db;
    final user = await DatabaseUser.getUserByEmail(
      db,
      email.trim().toLowerCase(),
    );
    if (user == null) return false;
    return (user['password'] as String) == password;
  }

  Future<bool> emailExists(String email) async {
    final db = await _db;
    final user = await DatabaseUser.getUserByEmail(
      db,
      email.trim().toLowerCase(),
    );
    return user != null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _db;
    return await DatabaseUser.getUserByEmail(db, email.trim().toLowerCase());
  }

  Future<void> updateProfile({
    required String currentEmail,
    String? newEmail,
    String? username,
    String? avatarPath,
    String? fullname,
    String? dob,
    String? gender,
    String? phoneNumber,
    String? country,
    String? pin,
    String? interest,
  }) async {
    final db = await _db;
    final updates = <String, Object?>{};
    final current = currentEmail.trim().toLowerCase();

    if (newEmail != null && newEmail.trim().toLowerCase() != current) {
      if (!isValidGmail(newEmail))
        throw Exception('Email must be a valid @gmail.com address.');
      final taken = await emailExists(newEmail);
      if (taken) throw Exception('Email is already used by another account.');
      updates['email'] = newEmail.trim().toLowerCase();
    }
    if (username != null) updates['username'] = username;
    if (avatarPath != null) updates['avatar_path'] = avatarPath;
    if (fullname != null) updates['fullname'] = fullname;
    if (dob != null) updates['day_of_birth'] = dob;
    if (gender != null) updates['gender'] = gender;
    if (phoneNumber != null) updates['phone_number'] = phoneNumber;
    if (country != null) updates['country'] = country;
    if (pin != null) updates['pin'] = pin;
    if (interest != null) updates['interest'] = interest;

    if (updates.isEmpty) return;
    final count = await DatabaseUser.updateUserByEmail(db, current, updates);
    if (count == 0) throw Exception('User not found.');
  }

  Future<void> changePassword(String email, String newPassword) async {
    final db = await _db;
    final user = await DatabaseUser.getUserByEmail(
      db,
      email.trim().toLowerCase(),
    );
    if (user == null) throw Exception('User not found');
    await DatabaseUser.updateUserByEmail(db, email.trim().toLowerCase(), {
      'password': newPassword,
    });
  }
}
