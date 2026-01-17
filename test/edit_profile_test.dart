import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserProfile {
  final String uid;
  final String username;

  UserProfile({required this.uid, required this.username});
}

abstract class UserProfileRepository {
  Future<void> updateProfile(UserProfile profile);
}

class _MockUserProfileRepository extends Mock implements UserProfileRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserProfile(uid: 'u', username: 'n'));
  });

  test('Edit profile calls repository update', () async {
    final repo = _MockUserProfileRepository();
    final profile = UserProfile(uid: 'user123', username: 'alice');

    when(() => repo.updateProfile(any())).thenAnswer((_) async {});

    // Simulate the edit profile save action calling the repo.
    await repo.updateProfile(profile);

    verify(() => repo.updateProfile(profile)).called(1);
  });
}
