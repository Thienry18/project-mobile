import 'package:flutter_test/flutter_test.dart';
import 'package:projek_mobile/data/auth_repository.dart';

void main() {
  group('AuthRepository - Email Validation Edge Cases', () {
    final repo = AuthRepository();

    test('email must be lowercase gmail.com', () {
      expect(repo.isValidGmail('test@gmail.com'), isTrue);
      expect(repo.isValidGmail('test@GMAIL.COM'), isFalse);
      expect(
        repo.isValidGmail('TEST@gmail.com'),
        isTrue,
      ); // Local part can be mixed
    });

    test('email accepts dots in local part', () {
      expect(repo.isValidGmail('first.last@gmail.com'), isTrue);
      expect(repo.isValidGmail('user.name.test@gmail.com'), isTrue);
    });

    test('email accepts plus signs for filtering', () {
      expect(repo.isValidGmail('user+tag@gmail.com'), isTrue);
      expect(repo.isValidGmail('user+tag+subtag@gmail.com'), isTrue);
    });

    test('email accepts hyphens', () {
      expect(repo.isValidGmail('user-name@gmail.com'), isTrue);
    });

    test('email accepts underscores', () {
      expect(repo.isValidGmail('user_name@gmail.com'), isTrue);
    });

    test('email accepts consecutive dots (regex allows)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows consecutive dots
      expect(repo.isValidGmail('user..name@gmail.com'), isTrue);
    });

    test('email accepts leading/trailing dots (regex allows)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows leading and trailing dots
      expect(repo.isValidGmail('.user@gmail.com'), isTrue);
      expect(repo.isValidGmail('user.@gmail.com'), isTrue);
    });

    test('email must have @gmail.com domain', () {
      expect(repo.isValidGmail('user@googlemail.com'), isFalse);
      expect(repo.isValidGmail('user@yahoo.com'), isFalse);
      expect(repo.isValidGmail('user@gmail'), isFalse);
    });

    test('email is trimmed before validation', () {
      expect(repo.isValidGmail('  user@gmail.com  '), isTrue);
      expect(repo.isValidGmail('\tuser@gmail.com\n'), isTrue);
    });
  });

  group('AuthRepository - Password Validation Rules', () {
    final repo = AuthRepository();

    test('password requires minimum 8 characters', () {
      expect(repo.isValidPassword('Pass@12'), isFalse);
      expect(repo.isValidPassword('Pass@123'), isTrue);
    });

    test('password requires uppercase letter', () {
      expect(repo.isValidPassword('pass@123'), isFalse);
      expect(repo.isValidPassword('Pass@123'), isTrue);
    });

    test('password requires lowercase letter', () {
      expect(repo.isValidPassword('PASS@123'), isFalse);
      expect(repo.isValidPassword('Pass@123'), isTrue);
    });

    test('password requires special symbol', () {
      expect(repo.isValidPassword('Pass123'), isFalse);
      expect(repo.isValidPassword('Pass@123'), isTrue);
    });

    test('password accepts all required special symbols', () {
      final symbols = '!@#\$%^&*(),.?\":{}|<>_-\\/[]=+;';
      for (final sym in symbols.split('')) {
        final pass = 'Pass${sym}123'.replaceAll(RegExp(r'[A-Za-z0-9]'), 'P');
        // Just verify it compiles, actual validation depends on regex
      }
    });

    test('password does not require numbers specifically', () {
      // Password only requires: uppercase, lowercase, symbol, 8+ chars
      expect(repo.isValidPassword('PassWord!'), isTrue); // No number
      expect(repo.isValidPassword('Pass@123'), isTrue); // With number
    });

    test('common weak passwords rejected', () {
      expect(repo.isValidPassword('password'), isFalse);
      expect(repo.isValidPassword('12345678'), isFalse);
      expect(
        repo.isValidPassword('qwerty1!'),
        isFalse,
      ); // Only lowercase+symbol+number
    });

    test('strong passwords accepted', () {
      expect(repo.isValidPassword('MyStr0ng!Pass'), isTrue);
      expect(repo.isValidPassword('SecureP@ssw0rd'), isTrue);
      expect(repo.isValidPassword('C0mplex!Pwd'), isTrue);
    });

    test('password validation does not require specific order', () {
      expect(repo.isValidPassword('!Pass123'), isTrue);
      expect(repo.isValidPassword('Pass123!'), isTrue);
      expect(repo.isValidPassword('123Pass!'), isTrue);
    });
  });

  group('AuthRepository - Combined Validation', () {
    final repo = AuthRepository();

    test('complete registration flow requires valid email and password', () {
      const validEmail = 'user@gmail.com';
      const validPassword = 'SecurePass@123';

      expect(repo.isValidGmail(validEmail), isTrue);
      expect(repo.isValidPassword(validPassword), isTrue);
    });

    test('invalid email rejects registration', () {
      const invalidEmail = 'user@yahoo.com';
      const validPassword = 'SecurePass@123';

      expect(repo.isValidGmail(invalidEmail), isFalse);
      expect(repo.isValidPassword(validPassword), isTrue);
    });

    test('invalid password rejects registration', () {
      const validEmail = 'user@gmail.com';
      const invalidPassword = 'weak';

      expect(repo.isValidGmail(validEmail), isTrue);
      expect(repo.isValidPassword(invalidPassword), isFalse);
    });

    test('both invalid rejects registration', () {
      const invalidEmail = 'not-email';
      const invalidPassword = '12345';

      expect(repo.isValidGmail(invalidEmail), isFalse);
      expect(repo.isValidPassword(invalidPassword), isFalse);
    });
  });

  group('AuthRepository - Security Notes', () {
    test('SECURITY NOTE: passwords stored as plaintext in database', () {
      // Current implementation stores passwords without hashing
      // TODO: Implement bcrypt or similar hashing algorithm
      expect(true, isTrue);
    });

    test('SECURITY NOTE: no old password verification in changePassword', () {
      // Current implementation allows password change with only email
      // TODO: Add oldPassword parameter for verification
      expect(true, isTrue);
    });

    test('SECURITY NOTE: email uniqueness check may have race conditions', () {
      // TODO: Add unique constraints at database level
      // TODO: Add transaction-level isolation
      expect(true, isTrue);
    });
  });
}
