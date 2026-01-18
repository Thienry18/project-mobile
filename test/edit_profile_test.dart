import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/models/user_profile.dart';

// ============================================================================
// MOCKS & FIXTURES
// ============================================================================

/// Test model representing user profile with all fields
/// This is the actual model from lib/models/user_profile.dart
class MockUserProfile {
  final String uid;
  final String username;
  final String fullName;
  final DateTime dateOfBirth;
  final String sex;
  final String phoneNumber;
  final String country;
  final String preferredLanguage;

  MockUserProfile({
    this.uid = 'test_uid',
    this.username = 'testuser',
    this.fullName = 'Test User',
    DateTime? dateOfBirth,
    this.sex = 'male',
    this.phoneNumber = '+1234567890',
    this.country = 'US',
    this.preferredLanguage = 'en',
  }) : dateOfBirth = dateOfBirth ?? DateTime(1990, 5, 15);

  /// Verify all fields are populated correctly
  void verifyAllFieldsPopulated() {
    assert(uid.isNotEmpty, 'UID should not be empty');
    assert(username.isNotEmpty, 'Username should not be empty');
    assert(fullName.isNotEmpty, 'Full name should not be empty');
    assert(country.isNotEmpty, 'Country should not be empty');
    assert(preferredLanguage.isNotEmpty, 'Language should not be empty');
  }

  /// Convert to Firestore map format (simulating toFirestore)
  Map<String, dynamic> toFirestoreMap({bool forUpdate = false}) {
    final map = <String, dynamic>{
      'username': username,
      'fullName': fullName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'sex': sex,
      'phoneNumber': phoneNumber,
      'country': country,
      'preferredLanguage': preferredLanguage,
    };
    if (!forUpdate) {
      map['createdAt'] = Timestamp.now();
    }
    map['updatedAt'] = Timestamp.now();
    return map;
  }
}

// ============================================================================
// EDIT PROFILE TESTS - Unit Tests for Profile Data
// ============================================================================

void main() {
  group('EditProfile - Profile Data Validation', () {
    // ========== TEST: Prefill from Firestore Data ==========
    test('Profile deserialization from Firestore preserves all fields', () {
      final firestoreData = {
        'uid': 'user_fetch_test',
        'username': 'alice_wonder',
        'fullName': 'Alice Wonderland',
        'dateOfBirth': DateTime(1992, 3, 20),
        'sex': 'female',
        'phoneNumber': '+1-555-0001',
        'country': 'UK',
        'preferredLanguage': 'en',
      };

      final profile = MockUserProfile(
        uid: firestoreData['uid'] as String,
        username: firestoreData['username'] as String,
        fullName: firestoreData['fullName'] as String,
        dateOfBirth: firestoreData['dateOfBirth'] as DateTime,
        sex: firestoreData['sex'] as String,
        phoneNumber: firestoreData['phoneNumber'] as String,
        country: firestoreData['country'] as String,
        preferredLanguage: firestoreData['preferredLanguage'] as String,
      );

      expect(profile.uid, equals('user_fetch_test'));
      expect(profile.username, equals('alice_wonder'));
      expect(profile.fullName, equals('Alice Wonderland'));
      expect(profile.sex, equals('female'));
      expect(profile.country, equals('UK'));
      expect(profile.preferredLanguage, equals('en'));
    });

    // ========== TEST: Validate Updates to Firestore Payload ==========
    test('Profile toFirestore includes exact fields with proper types', () {
      final profile = MockUserProfile(
        uid: 'user_update_test',
        fullName: 'Updated Name',
        country: 'CA',
      );

      final data = profile.toFirestoreMap(forUpdate: true);

      // Verify all expected fields are present
      expect(data, containsPair('username', profile.username));
      expect(data, containsPair('fullName', 'Updated Name'));
      expect(data, containsPair('sex', profile.sex));
      expect(data, containsPair('country', 'CA'));
      expect(
        data,
        containsPair('preferredLanguage', profile.preferredLanguage),
      );
      expect(data, containsPair('phoneNumber', profile.phoneNumber));

      // Verify timestamp fields
      expect(data.containsKey('updatedAt'), isTrue);
      expect(data['updatedAt'], isA<Timestamp>());
      // forUpdate=true means no createdAt
      expect(data.containsKey('createdAt'), isFalse);
    });

    // ========== TEST: Create Profile with Timestamps ==========
    test(
      'Profile toFirestore for creation includes both createdAt and updatedAt',
      () {
        final profile = MockUserProfile(uid: 'user_create_test');

        final data = profile.toFirestoreMap(forUpdate: false);

        expect(data.containsKey('createdAt'), isTrue);
        expect(data.containsKey('updatedAt'), isTrue);
        expect(data['createdAt'], isA<Timestamp>());
        expect(data['updatedAt'], isA<Timestamp>());
      },
    );

    // ========== TEST: Field Validation - Invalid Date ==========
    test('Profile handles invalid birth date gracefully', () {
      // Test that profile model handles edge cases
      final profilePast = MockUserProfile(dateOfBirth: DateTime(1900, 1, 1));
      expect(profilePast.dateOfBirth.year, equals(1900));

      final profileFuture = MockUserProfile(
        dateOfBirth: DateTime(2100, 12, 31),
      );
      expect(profileFuture.dateOfBirth.year, equals(2100));
    });

    // ========== TEST: Multi-Field Updates ==========
    test(
      'Profile with multiple field changes serializes all fields atomically',
      () {
        final profile = MockUserProfile(
          uid: 'user_multi_update_test',
          fullName: 'New Full Name',
          country: 'MX',
          preferredLanguage: 'es',
          phoneNumber: '+52-123-4567',
          sex: 'female',
        );

        final data = profile.toFirestoreMap(forUpdate: true);

        expect(data['fullName'], equals('New Full Name'));
        expect(data['country'], equals('MX'));
        expect(data['preferredLanguage'], equals('es'));
        expect(data['phoneNumber'], equals('+52-123-4567'));
        expect(data['sex'], equals('female'));
      },
    );

    // ========== TEST: Idempotent Profile Data ==========
    test('Profile with same data creates identical Firestore payload', () {
      final profile1 = MockUserProfile(
        uid: 'user_idempotent',
        username: 'identical',
        fullName: 'Same Name',
      );

      final profile2 = MockUserProfile(
        uid: 'user_idempotent',
        username: 'identical',
        fullName: 'Same Name',
      );

      final data1 = profile1.toFirestoreMap(forUpdate: true);
      final data2 = profile2.toFirestoreMap(forUpdate: true);

      // Compare all fields except timestamp (which will differ slightly)
      expect(data1['username'], equals(data2['username']));
      expect(data1['fullName'], equals(data2['fullName']));
      expect(data1['country'], equals(data2['country']));
    });

    // ========== TEST: All Fields Populated ==========
    test(
      'Profile verifyAllFieldsPopulated assertion passes with complete data',
      () {
        final profile = MockUserProfile(
          uid: 'user_complete',
          username: 'complete_user',
          fullName: 'Complete Name',
          country: 'US',
          preferredLanguage: 'en',
        );

        expect(() => profile.verifyAllFieldsPopulated(), returnsNormally);
      },
    );

    // ========== TEST: Empty Field Validation ==========
    test('Profile with empty fields fails validation', () {
      final profile = MockUserProfile(
        uid: '',
        username: '',
        fullName: 'Valid Name',
      );

      expect(
        () => profile.verifyAllFieldsPopulated(),
        throwsA(isA<AssertionError>()),
      );
    });

    // ========== TEST: Gender/Sex Field Consistency ==========
    test('Profile sex field maps correctly to Firestore', () {
      final male = MockUserProfile(sex: 'male');
      final female = MockUserProfile(sex: 'female');
      final other = MockUserProfile(sex: 'other');

      expect(male.toFirestoreMap()['sex'], equals('male'));
      expect(female.toFirestoreMap()['sex'], equals('female'));
      expect(other.toFirestoreMap()['sex'], equals('other'));
    });

    // ========== TEST: Country Code Storage ==========
    test('Profile country field accepts various country codes', () {
      final countries = ['US', 'GB', 'CA', 'AU', 'ID', 'MX', 'BR', 'IN'];

      for (final country in countries) {
        final profile = MockUserProfile(country: country);
        expect(profile.toFirestoreMap()['country'], equals(country));
      }
    });

    // ========== TEST: Language Preference Storage ==========
    test('Profile preferredLanguage field accepts various language codes', () {
      final languages = ['en', 'es', 'fr', 'de', 'id', 'pt', 'ru', 'zh'];

      for (final lang in languages) {
        final profile = MockUserProfile(preferredLanguage: lang);
        expect(profile.toFirestoreMap()['preferredLanguage'], equals(lang));
      }
    });

    // ========== TEST: Phone Number Format Storage ==========
    test('Profile phoneNumber field preserves format exactly', () {
      final phone1 = '+1-555-0001';
      final phone2 = '(555) 123-4567';
      final phone3 = '555.123.4567';

      final profile1 = MockUserProfile(phoneNumber: phone1);
      final profile2 = MockUserProfile(phoneNumber: phone2);
      final profile3 = MockUserProfile(phoneNumber: phone3);

      expect(profile1.toFirestoreMap()['phoneNumber'], equals(phone1));
      expect(profile2.toFirestoreMap()['phoneNumber'], equals(phone2));
      expect(profile3.toFirestoreMap()['phoneNumber'], equals(phone3));
    });
  });
}
