import 'package:flutter_test/flutter_test.dart';
import 'package:projek_mobile/data/auth_repository.dart';

void main() {
  group('SignIn logic (validation helpers)', () {
    final repo = AuthRepository();

    test('isValidGmail accepts proper gmail addresses', () {
      expect(repo.isValidGmail('john.doe@gmail.com'), isTrue);
      expect(repo.isValidGmail('user+tag@gmail.com'), isFalse);
    });

    test('isValidPassword enforces rules', () {
      expect(repo.isValidPassword('StrongP@ss1'), isTrue);
      expect(repo.isValidPassword('weakpass'), isFalse);
    });
  });
}
