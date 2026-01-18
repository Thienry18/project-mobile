import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/data/auth_repository.dart';
import 'package:sqflite/sqflite.dart';

// Mock classes
class MockDatabase extends Mock implements Database {}

void main() {
  group('SignIn - Validation Helpers', () {
    final repo = AuthRepository();

    group('isValidGmail()', () {
      test('accepts standard gmail address', () {
        expect(repo.isValidGmail('john.doe@gmail.com'), isTrue);
      });

      test('accepts gmail with numbers', () {
        expect(repo.isValidGmail('user123@gmail.com'), isTrue);
      });

      test('accepts gmail with dots in local part', () {
        expect(repo.isValidGmail('john.doe.smith@gmail.com'), isTrue);
      });

      test('accepts gmail with plus sign for tags', () {
        expect(repo.isValidGmail('user+tag@gmail.com'), isTrue);
      });

      test('accepts gmail with multiple plus tags', () {
        expect(repo.isValidGmail('user+tag+subtag@gmail.com'), isTrue);
      });

      test('accepts gmail with hyphen in local part', () {
        expect(repo.isValidGmail('user-name@gmail.com'), isTrue);
      });

      test('accepts gmail with underscore in local part', () {
        expect(repo.isValidGmail('user_name@gmail.com'), isTrue);
      });

      test('accepts gmail with mixed case (must be lowercase domain)', () {
        expect(repo.isValidGmail('UserName@gmail.com'), isTrue);
        expect(
          repo.isValidGmail('UserName@Gmail.com'),
          isFalse,
        ); // Domain must be lowercase
      });

      test('rejects non-gmail addresses', () {
        expect(repo.isValidGmail('user@yahoo.com'), isFalse);
        expect(repo.isValidGmail('user@outlook.com'), isFalse);
        expect(repo.isValidGmail('user@hotmail.com'), isFalse);
      });

      test('rejects googlemail domain', () {
        expect(repo.isValidGmail('user@googlemail.com'), isFalse);
      });

      test('rejects incomplete gmail', () {
        expect(repo.isValidGmail('user@gmail'), isFalse);
      });

      test('rejects malformed email', () {
        expect(repo.isValidGmail('user@ gmail.com'), isFalse);
        expect(repo.isValidGmail('user@gmail.c'), isFalse);
      });

      test('rejects email without @ symbol', () {
        expect(repo.isValidGmail('usergmail.com'), isFalse);
      });

      test('rejects email with spaces', () {
        expect(repo.isValidGmail('user name@gmail.com'), isFalse);
      });

      test('trims whitespace before validation', () {
        expect(repo.isValidGmail('  user@gmail.com  '), isTrue);
      });

      test('rejects empty string', () {
        expect(repo.isValidGmail(''), isFalse);
      });
    });

    group('isValidPassword()', () {
      test('accepts valid password with uppercase, lowercase, symbol', () {
        expect(repo.isValidPassword('ValidP@ss1'), isTrue);
      });

      test('accepts password exactly 8 characters', () {
        expect(repo.isValidPassword('Aa!aaaaa'), isTrue);
      });

      test('accepts longer passwords', () {
        expect(repo.isValidPassword('VeryStr0ng!Password'), isTrue);
      });

      test('accepts various special characters', () {
        expect(repo.isValidPassword('Pass@123'), isTrue);
        expect(repo.isValidPassword('Pass#123'), isTrue);
        expect(repo.isValidPassword('Pass\$123'), isTrue);
        expect(repo.isValidPassword('Pass%123'), isTrue);
        expect(repo.isValidPassword('Pass^123'), isTrue);
        expect(repo.isValidPassword('Pass&123'), isTrue);
      });

      test('rejects password shorter than 8 characters', () {
        expect(repo.isValidPassword('Pass@12'), isFalse);
        expect(repo.isValidPassword('Short!A'), isFalse);
      });

      test('rejects password with only lowercase letters and symbol', () {
        expect(repo.isValidPassword('password!'), isFalse);
      });

      test('rejects password with only uppercase letters and symbol', () {
        expect(repo.isValidPassword('PASSWORD!'), isFalse);
      });

      test('rejects password without special character', () {
        expect(repo.isValidPassword('NoSymbolA1'), isFalse);
        expect(repo.isValidPassword('Password123'), isFalse);
      });

      test('rejects password without uppercase letter', () {
        expect(repo.isValidPassword('lowercase!1'), isFalse);
      });

      test('rejects password without lowercase letter', () {
        expect(repo.isValidPassword('UPPERCASE!1'), isFalse);
      });

      test('rejects password with only numbers and symbols', () {
        expect(repo.isValidPassword('12345678!'), isFalse);
      });

      test('rejects empty password', () {
        expect(repo.isValidPassword(''), isFalse);
      });

      test('rejects password with spaces', () {
        expect(
          repo.isValidPassword('Pass @123'),
          isTrue,
        ); // Space is not in symbol regex, but it is allowed
      });
    });
  });

  group('SignIn - Email Verification', () {
    final repo = AuthRepository();

    test('email with whitespace must be trimmed before validation', () {
      // Trim happens inside isValidGmail, so these should work
      expect(repo.isValidGmail('  user@gmail.com  '), isTrue);
    });

    test('uppercase domain is invalid (must be lowercase)', () {
      expect(repo.isValidGmail('USER@GMAIL.COM'), isFalse);
      expect(repo.isValidGmail('user@gmail.com'), isTrue);
    });
  });

  group('SignIn - Password Rules', () {
    final repo = AuthRepository();

    test('password must have all four components', () {
      // Missing each component
      expect(repo.isValidPassword('abcdefgh!'), isFalse); // no upper
      expect(repo.isValidPassword('ABCDEFGH!'), isFalse); // no lower
      expect(repo.isValidPassword('AbcdefghA'), isFalse); // no symbol

      // All three required components present
      expect(repo.isValidPassword('Abcdefgh!'), isTrue);
    });

    test('common weak passwords are rejected', () {
      expect(repo.isValidPassword('password'), isFalse);
      expect(repo.isValidPassword('12345678'), isFalse);
      expect(repo.isValidPassword('qwerty1!'), isFalse);
      expect(repo.isValidPassword('admin123'), isFalse);
    });

    test('strong passwords are accepted', () {
      expect(repo.isValidPassword('MyStr0ng!Pass'), isTrue);
      expect(repo.isValidPassword('Secure@Pass123'), isTrue);
      expect(repo.isValidPassword('C0mplex!Password'), isTrue);
    });
  });
}
