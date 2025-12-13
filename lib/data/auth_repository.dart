import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    // First, create a Firebase Auth user so that subsequent Firestore writes
    // from the client are authenticated. If Firebase creation succeeds but
    // local DB insert fails, delete the Firebase user to keep state consistent.
    UserCredential? created;
    try {
      created = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Map common Firebase errors to friendly messages
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already registered.');
      }
      throw Exception('Firebase Auth error: ${e.message}');
    }

    final db = await _db;
    final exists = await DatabaseUser.getUserByEmail(
      db,
      email.trim().toLowerCase(),
    );
    if (exists != null) {
      // rollback Firebase user
      try {
        final u = created.user;
        if (u != null) await u.delete();
      } catch (_) {}
      throw Exception('Email already registered.');
    }

    try {
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
      // Notify listeners that users changed
      try {
        await DatabaseService.instance.emitUsers();
      } catch (_) {}
    } catch (e) {
      // rollback Firebase user if local DB fails
      try {
        final u = created.user;
        if (u != null) await u.delete();
      } catch (_) {}
      rethrow;
    }
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
    // Debug: log current target email and all users to help diagnose mismatches
    try {
      final all = await DatabaseUser.getAllUsers(db);
      // ignore: avoid_print
      print('AuthRepository.updateProfile: current=$current');
      // ignore: avoid_print
      print(
        'AuthRepository.updateProfile: users=${all.map((u) => u['email']).toList()}',
      );
    } catch (_) {}

    final count = await DatabaseUser.updateUserByEmail(db, current, updates);
    if (count == 0) {
      // additional debug info
      // ignore: avoid_print
      print('AuthRepository.updateProfile: update count=0 for email=$current');
      throw Exception('User not found.');
    }
    // Emit users snapshot for listeners (profile changed)
    try {
      await DatabaseService.instance.emitUsers();
    } catch (_) {}
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
    // Emit users snapshot so any UI depending on user list/profile updates
    try {
      await DatabaseService.instance.emitUsers();
    } catch (_) {}
  }

  /// Return a stream of the user row for the given email (updates when DB emits)
  Stream<Map<String, dynamic>?> watchUserByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    return DatabaseService.instance.usersStream.map((users) {
      try {
        final found = users.firstWhere(
          (u) => (u['email'] as String?) == normalized,
          orElse: () => {},
        );
        return found.isNotEmpty ? found : null;
      } catch (_) {
        return null;
      }
    });
  }
}
