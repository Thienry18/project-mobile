import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ==================== MOCK CLASSES ====================
class MockDatabase extends Mock implements Database {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockDatabaseService extends Mock implements DatabaseService {}

// ==================== TEST FIXTURES ====================
Map<String, dynamic> createTestUserData({
  String email = 'testuser@gmail.com',
  String password = 'TestPass123!',
  String username = 'testuser',
  String fullname = 'Test User',
  String dayOfBirth = '1990-01-01',
  String gender = 'male',
  String phoneNumber = '08123456789',
  String country = 'Indonesia',
  String avatarPath = '',
  String? pin,
}) => {
  'email': email,
  'password': password,
  'username': username,
  'fullname': fullname,
  'day_of_birth': dayOfBirth,
  'gender': gender,
  'phone_number': phoneNumber,
  'country': country,
  'avatar_path': avatarPath,
  'pin': pin,
};

void main() {
  group('SignUp - Validation', () {
    final repo = AuthRepository();

    group('Gmail Validation', () {
      test('accepts standard gmail', () {
        expect(repo.isValidGmail('user@gmail.com'), isTrue);
      });

      test('rejects non-gmail domains', () {
        expect(repo.isValidGmail('user@yahoo.com'), isFalse);
        expect(repo.isValidGmail('user@gmail'), isFalse);
      });

      test('validates multiple test cases', () {
        final valid = [
          'user@gmail.com',
          'a.b_c-1+2@gmail.com',
          'TestUser123@gmail.com',
          'user+tag@gmail.com',
        ];
        for (final e in valid) {
          expect(repo.isValidGmail(e), isTrue, reason: 'Should accept $e');
        }
      });

      test('rejects invalid emails', () {
        final invalid = [
          'user@yahoo.com',
          'user@gmail',
          'user@ gmail.com',
          'user+test@googlemail.com',
          'not-an-email',
          'user@gmail.co',
        ];
        for (final e in invalid) {
          expect(repo.isValidGmail(e), isFalse, reason: 'Should reject $e');
        }
      });
    });

    group('Password Validation', () {
      test('enforces minimum requirements', () {
        expect(repo.isValidPassword('Abcdef1!'), isTrue);
        expect(repo.isValidPassword('short!A'), isFalse);
        expect(repo.isValidPassword('alllowercase!'), isFalse);
        expect(repo.isValidPassword('ALLUPPERCASE!'), isFalse);
        expect(repo.isValidPassword('NoSymbolA'), isFalse);
        expect(repo.isValidPassword('Aa!aaaaa'), isTrue);
      });

      test('requires uppercase, lowercase, symbol and 8+ chars', () {
        expect(repo.isValidPassword('password!'), isFalse); // no upper
        expect(repo.isValidPassword('PASSWORD!'), isFalse); // no lower
        expect(repo.isValidPassword('Password'), isFalse); // no symbol
        expect(repo.isValidPassword('Pass@123'), isTrue); // all present
      });

      test('accepts common strong passwords', () {
        expect(repo.isValidPassword('MySecure@Pass1'), isTrue);
        expect(repo.isValidPassword('Strong#2024Pass'), isTrue);
      });
    });

    group('Combined Validation', () {
      test('both email and password must be valid', () {
        expect(repo.isValidGmail('user@gmail.com'), isTrue);
        expect(repo.isValidPassword('Secure@Pass123'), isTrue);
      });

      test('invalid email fails even with valid password', () {
        expect(repo.isValidGmail('user@yahoo.com'), isFalse);
        expect(repo.isValidPassword('Secure@Pass123'), isTrue);
      });

      test('invalid password fails even with valid email', () {
        expect(repo.isValidGmail('user@gmail.com'), isTrue);
        expect(repo.isValidPassword('weakpass'), isFalse);
      });
    });
  });

  group('SignUp - Registration Logic Preparation', () {
    final repo = AuthRepository();

    test('valid credentials pass validation', () {
      const email = 'newuser@gmail.com';
      const password = 'NewPass@123';

      expect(repo.isValidGmail(email), isTrue);
      expect(repo.isValidPassword(password), isTrue);
    });

    test('email is normalized during validation', () {
      expect(repo.isValidGmail('  user@gmail.com  '), isTrue);
      expect(
        repo.isValidGmail('USER@GMAIL.COM'),
        isFalse,
      ); // Domain must be lowercase
    });

    test('user data structure has all required fields', () {
      final userData = createTestUserData();

      expect(userData, containsPair('email', 'testuser@gmail.com'));
      expect(userData, containsPair('password', 'TestPass123!'));
      expect(userData, containsPair('username', 'testuser'));
      expect(userData, containsPair('fullname', 'Test User'));
      expect(userData, containsPair('day_of_birth', '1990-01-01'));
      expect(userData, containsPair('gender', 'male'));
      expect(userData, containsPair('phone_number', '08123456789'));
      expect(userData, containsPair('country', 'Indonesia'));
      expect(userData, containsPair('avatar_path', ''));
      expect(userData, containsPair('pin', null));
    });

    test('test fixture has all fields initialized', () {
      final user = createTestUserData();
      final requiredFields = [
        'email',
        'password',
        'username',
        'fullname',
        'day_of_birth',
        'gender',
        'phone_number',
        'country',
        'avatar_path',
        'pin',
      ];
      for (final field in requiredFields) {
        expect(
          user.containsKey(field),
          isTrue,
          reason: 'Should have $field field',
        );
      }
    });

    test(
      'password should be encrypted not plaintext (note: currently plaintext)',
      () {
        // This test documents current behavior: passwords are stored as plaintext
        // TODO: Consider using bcrypt or similar for password hashing
        final user = createTestUserData(password: 'TestPass@123');
        expect(
          user['password'],
          equals('TestPass@123'),
        ); // Currently plaintext - SECURITY CONCERN
      },
    );

    test('email normalization rules', () {
      const email1 = 'USER@GMAIL.COM';
      const email2 = 'user@gmail.com';
      const email3 = '  user@gmail.com  ';

      // Whitespace trimmed, but domain must be lowercase
      expect(repo.isValidGmail(email1), isFalse); // Uppercase domain invalid
      expect(repo.isValidGmail(email2), isTrue);
      expect(
        repo.isValidGmail(email3),
        isTrue,
      ); // Whitespace trimmed internally
    });
  });

  group('SignUp - User Data Integrity', () {
    test('fixture can be customized for different scenarios', () {
      final admin = createTestUserData(
        email: 'admin@gmail.com',
        username: 'admin',
        fullname: 'Administrator',
      );
      expect(admin['email'], 'admin@gmail.com');
      expect(admin['username'], 'admin');
      expect(admin['fullname'], 'Administrator');
    });

    test('default fixture creates valid user profile', () {
      final user = createTestUserData();
      expect(user['email'], isNotEmpty);
      expect(user['password'], isNotEmpty);
      expect(user['username'], isNotEmpty);
    });

    test('pin field can be null or set', () {
      final withoutPin = createTestUserData();
      expect(withoutPin['pin'], isNull);

      final withPin = createTestUserData(pin: '1234');
      expect(withPin['pin'], '1234');
    });
  });

  group('SignUp - Email Edge Cases', () {
    final repo = AuthRepository();

    test('email with consecutive dots (regex allows)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows consecutive dots
      expect(repo.isValidGmail('user..name@gmail.com'), isTrue);
    });

    test('email with leading/trailing dots (regex allows)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows leading and trailing dots
      expect(repo.isValidGmail('.user@gmail.com'), isTrue);
      expect(repo.isValidGmail('user.@gmail.com'), isTrue);
    });

    test('email with numbers and symbols mixed', () {
      expect(repo.isValidGmail('user123+tag@gmail.com'), isTrue);
    });

    test('very long email (but valid)', () {
      final longEmail =
          'verylongemailaddresswithnumberandstuff123456789@gmail.com';
      expect(repo.isValidGmail(longEmail), isTrue);
    });
  });

  group('SignUp - Password Edge Cases', () {
    final repo = AuthRepository();

    test('password with exactly 8 characters minimum', () {
      expect(repo.isValidPassword('Aa!aaaaa'), isTrue);
      expect(repo.isValidPassword('Aa!aaaa'), isFalse);
    });

    test('password with consecutive symbols', () {
      expect(repo.isValidPassword('Aa!!aaaa'), isTrue);
    });

    test('password with numbers at beginning and end', () {
      expect(repo.isValidPassword('1Pass@999'), isTrue);
    });

    test('password with uppercase at beginning and lowercase at end', () {
      expect(repo.isValidPassword('Passwordexample!'), isTrue);
    });

    test('password with common weak patterns rejected', () {
      expect(repo.isValidPassword('Password123'), isFalse); // no symbol
      expect(repo.isValidPassword('Qwerty@123'), isTrue); // has symbol
    });
  });
}
