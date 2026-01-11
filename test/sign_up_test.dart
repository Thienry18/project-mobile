import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projek_mobile/l10n/app_localizations.dart';
import 'package:projek_mobile/screens/sign_up.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SignUp Widget', () {
    Future<void> pumpSignUp(WidgetTester tester) async {
      import 'package:flutter_test/flutter_test.dart';
      import 'package:projek_mobile/data/auth_repository.dart';

      void main() {
        group('AuthRepository validation', () {
          final repo = AuthRepository();

          test('valid gmail addresses pass', () {
            final good = [
              'user@gmail.com',
              'a.b_c-1+2@gmail.com',
              'TestUser123@gmail.com',
            ];
            for (final e in good) expect(repo.isValidGmail(e), isTrue, reason: e);
          });

          test('invalid gmail addresses fail', () {
            final bad = [
              'user@yahoo.com',
              'user@gmail',
              'user@ gmail.com',
              'user+test@googlemail.com',
              'not-an-email',
              'user@gmail.co',
            ];
            for (final e in bad) expect(repo.isValidGmail(e), isFalse, reason: e);
          });

          test('password policy: must be >=8 with upper, lower and symbol', () {
            expect(repo.isValidPassword('Abcdef1!'), isTrue);
            expect(repo.isValidPassword('short!A'), isFalse); // too short
            expect(repo.isValidPassword('alllowercase!'), isFalse); // no upper
            expect(repo.isValidPassword('ALLUPPERCASE!'), isFalse); // no lower
            expect(repo.isValidPassword('NoSymbolA'), isFalse); // no symbol
            expect(repo.isValidPassword('Aa!aaaaa'), isTrue);
          });
        });
      }
      await tester.tap(cb);
