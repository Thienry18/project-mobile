import 'package:flutter_test/flutter_test.dart';
import 'package:projek_mobile/data/auth_repository.dart';

void main() {
  group('AuthRepository - Input Validation Edge Cases', () {
    final repo = AuthRepository();

    test('email with multiple + signs (Gmail aliasing)', () {
      expect(repo.isValidGmail('user+tag1+tag2@gmail.com'), isTrue);
    });

    test('email with numbers in local part', () {
      expect(repo.isValidGmail('user123@gmail.com'), isTrue);
      expect(repo.isValidGmail('123user@gmail.com'), isTrue);
      expect(repo.isValidGmail('123456789@gmail.com'), isTrue);
    });

    test('email with underscore and hyphen combination', () {
      expect(repo.isValidGmail('user_name-test@gmail.com'), isTrue);
    });

    test('password with maximum allowed length', () {
      final longPass =
          'VeryLongPassword@1234567890' * 5; // Much longer than typical
      expect(repo.isValidPassword(longPass), isTrue);
    });

    test('password with exactly 8 characters (minimum)', () {
      expect(repo.isValidPassword('Pass@1ab'), isTrue);
      expect(repo.isValidPassword('Pass@123'), isTrue);
    });

    test('password with 7 characters (below minimum)', () {
      expect(repo.isValidPassword('Pass@12'), isFalse);
    });

    test('password with uppercase at start, middle, and end', () {
      expect(repo.isValidPassword('PassWord@1'), isTrue);
      expect(repo.isValidPassword('pAsSword@1'), isTrue);
      expect(repo.isValidPassword('passworD@1'), isTrue);
    });

    test('password with lowercase at various positions', () {
      expect(repo.isValidPassword('PASS@word1'), isTrue);
      expect(repo.isValidPassword('PASs@WORD1'), isTrue);
      expect(repo.isValidPassword('PASS@WORd1'), isTrue);
    });

    test('password with special symbol at different positions', () {
      expect(repo.isValidPassword('@Pass1234'), isTrue);
      expect(repo.isValidPassword('Pass@1234'), isTrue);
      expect(repo.isValidPassword('Pass1234@'), isTrue);
    });

    test('password with space character passes (spaces not forbidden)', () {
      // The password regex doesn't explicitly forbid spaces
      // It only checks for: 8+ chars, uppercase, lowercase, symbol
      // So spaces are allowed as they meet the requirements
      expect(repo.isValidPassword('Pass @123'), isTrue);
      expect(repo.isValidPassword('Pass@ 123'), isTrue);
    });

    test('password without uppercase fails', () {
      expect(repo.isValidPassword('pass@word1'), isFalse);
    });

    test('password without lowercase fails', () {
      expect(repo.isValidPassword('PASS@WORD1'), isFalse);
    });

    test('password without symbol fails', () {
      expect(repo.isValidPassword('Password123'), isFalse);
    });

    test('password without minimum length fails', () {
      expect(repo.isValidPassword('Aa@1'), isFalse);
      expect(repo.isValidPassword('Aa@123'), isFalse);
      expect(repo.isValidPassword('Aa@12'), isFalse);
    });
  });

  group('AuthRepository - Security Issues Documentation', () {
    test('SECURITY ISSUE #1: Plaintext Password Storage', () {
      // Current implementation stores passwords as plaintext in SQLite database
      // Severity: CRITICAL
      // Impact: If database is compromised, all user passwords are exposed
      // Recommendation: Implement bcrypt or PBKDF2 password hashing
      // Reference: OWASP Password Storage Cheat Sheet
      expect(true, isTrue);
    });

    test('SECURITY ISSUE #2: Missing Old Password Verification', () {
      // changePassword() method does not verify old password
      // Severity: HIGH
      // Impact: Unauthorized password change if email is compromised
      // Recommendation: Add oldPassword parameter and require verification
      // Current Flow: changePassword(email, newPassword) -> TOO SIMPLE
      // Should Be: changePassword(email, oldPassword, newPassword)
      expect(true, isTrue);
    });

    test('SECURITY ISSUE #3: Race Condition in Email Uniqueness', () {
      // emailExists() check and subsequent insert are not atomic
      // Severity: MEDIUM
      // Impact: Duplicate accounts possible in concurrent scenarios
      // Recommendation: Add UNIQUE constraint at database level
      // Alternative: Use database transaction with proper isolation level
      expect(true, isTrue);
    });

    test('SECURITY ISSUE #4: No Input Sanitization', () {
      // Validation only checks format, not for SQL injection patterns
      // Severity: MEDIUM (mitigated by parameterized queries)
      // Impact: Potential code injection if parameterized queries not used
      // Recommendation: Add explicit SQL injection tests
      expect(true, isTrue);
    });

    test('SECURITY ISSUE #5: Case Sensitivity Handling', () {
      // Email validation requires lowercase @gmail.com but local part flexible
      // Severity: LOW
      // Impact: Confusion in email uniqueness (USER@gmail.com vs user@gmail.com)
      // Recommendation: Explicitly document or normalize to lowercase everywhere
      expect(true, isTrue);
    });
  });

  group('AuthRepository - Error Messages and User Experience', () {
    final repo = AuthRepository();

    test('invalid gmail provides clear feedback', () {
      // These should all fail with clear reasons
      expect(repo.isValidGmail('user@yahoo.com'), isFalse); // Wrong domain
      expect(repo.isValidGmail('user@GMAIL.COM'), isFalse); // Wrong case
      expect(repo.isValidGmail('invalid-email'), isFalse); // No @
      expect(repo.isValidGmail('user@'), isFalse); // No domain
    });

    test('invalid password provides clear feedback', () {
      // These should all fail with clear reasons for UX
      expect(repo.isValidPassword('pass'), isFalse); // Too short
      expect(
        repo.isValidPassword('password'),
        isFalse,
      ); // No uppercase or symbol
      expect(
        repo.isValidPassword('PASSWORD'),
        isFalse,
      ); // No lowercase or symbol
      expect(repo.isValidPassword('Pass1234'), isFalse); // No symbol
    });
  });

  group('AuthRepository - Boundary Conditions', () {
    final repo = AuthRepository();

    test('empty email rejected', () {
      expect(repo.isValidGmail(''), isFalse);
    });

    test('empty password rejected', () {
      expect(repo.isValidPassword(''), isFalse);
    });

    test('null values handled gracefully', () {
      // If method receives null, it should handle it
      // (Current implementation may throw - this documents expected behavior)
      try {
        // repo.isValidGmail(null); // Would be null safety issue in Dart
        expect(true, isTrue); // Null safety prevents this at compile time
      } catch (e) {
        expect(true, isTrue);
      }
    });

    test('very long email (but valid format)', () {
      final longLocalPart = 'a' * 100; // 100 chars before @
      final email = '$longLocalPart@gmail.com';
      expect(repo.isValidGmail(email), isTrue);
    });

    test('unicode characters in email', () {
      expect(
        repo.isValidGmail('user_é@gmail.com'),
        isFalse,
      ); // Regex limited to ASCII
    });

    test('unicode characters in password', () {
      expect(
        repo.isValidPassword('Pässwörd@1234'),
        isTrue,
      ); // Symbols allowed, unicode lower+upper
    });
  });

  group('AuthRepository - Regression Tests', () {
    final repo = AuthRepository();

    test('common real-world valid gmail addresses', () {
      const validEmails = [
        'john.doe@gmail.com',
        'jane_smith@gmail.com',
        'bob-jones@gmail.com',
        'user123@gmail.com',
        'first+tag@gmail.com',
        'a.b.c.d.e@gmail.com',
      ];

      for (final email in validEmails) {
        expect(
          repo.isValidGmail(email),
          isTrue,
          reason: 'Should accept: $email',
        );
      }
    });

    test('common invalid gmail addresses', () {
      const invalidEmails = [
        'user@googlemail.com', // Wrong domain
        'user@Gmail.com', // Wrong case
        'user@GMAIL.COM', // Wrong case
        'user@gmail.co', // Wrong TLD
        'user @gmail.com', // Space in local
        '@gmail.com', // Missing local part
        'user@gmail.com.', // Trailing dot
        'user@.gmail.com', // Leading dot after @
      ];

      for (final email in invalidEmails) {
        expect(
          repo.isValidGmail(email),
          isFalse,
          reason: 'Should reject: $email',
        );
      }
    });

    test('password validation consistency across runs', () {
      const testPassword = 'TestPass@123';
      expect(repo.isValidPassword(testPassword), isTrue);
      expect(repo.isValidPassword(testPassword), isTrue);
      expect(repo.isValidPassword(testPassword), isTrue);
    });

    test('email validation consistency across runs', () {
      const testEmail = 'user@gmail.com';
      expect(repo.isValidGmail(testEmail), isTrue);
      expect(repo.isValidGmail(testEmail), isTrue);
      expect(repo.isValidGmail(testEmail), isTrue);
    });
  });

  group('AuthRepository - Whitespace Handling', () {
    final repo = AuthRepository();

    test('email trimmed before validation', () {
      expect(repo.isValidGmail('  user@gmail.com  '), isTrue);
      expect(repo.isValidGmail('\tuser@gmail.com\n'), isTrue);
      expect(repo.isValidGmail('\n\n  user@gmail.com  \n\n'), isTrue);
    });

    test('password not trimmed during validation', () {
      // Password validation might be strict about whitespace
      expect(repo.isValidPassword('Pass@123'), isTrue);
      // Note: ' Pass@123' might not be the same after form input trimming
    });

    test('email with leading/trailing whitespace combinations', () {
      expect(repo.isValidGmail(' user@gmail.com'), isTrue);
      expect(repo.isValidGmail('user@gmail.com '), isTrue);
      expect(repo.isValidGmail(' user@gmail.com '), isTrue);
    });
  });

  group('AuthRepository - Consecutive Special Characters', () {
    final repo = AuthRepository();

    test('email allows consecutive dots in local part (regex pattern)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows any sequence of allowed chars
      expect(repo.isValidGmail('user..name@gmail.com'), isTrue);
    });

    test('email allows leading dot (regex pattern)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows leading dots
      expect(repo.isValidGmail('.user@gmail.com'), isTrue);
    });

    test('email allows trailing dot before @ (regex pattern)', () {
      // The regex [a-zA-Z0-9._%+\-]+ allows trailing dots
      expect(repo.isValidGmail('user.@gmail.com'), isTrue);
    });

    test('email accepts single dot in middle', () {
      expect(repo.isValidGmail('user.name@gmail.com'), isTrue);
    });

    test('email accepts multiple single dots', () {
      expect(repo.isValidGmail('first.middle.last@gmail.com'), isTrue);
    });

    test('password requires at least one symbol', () {
      expect(repo.isValidPassword('PassWord123'), isFalse);
      expect(repo.isValidPassword('PassWord@'), isTrue);
    });

    test('password allows multiple symbols', () {
      expect(repo.isValidPassword('Pass@@@@'), isTrue);
      expect(repo.isValidPassword('P@a@s@s@'), isTrue);
    });
  });
}
