import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/data/pin_service.dart';

// ============================================================================
// MOCKS
// ============================================================================

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class _MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class _MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class _MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

// ============================================================================
// PIN SERVICE TESTS
// ============================================================================

void main() {
  group('PinService', () {
    late _MockFirebaseFirestore mockFirestore;
    late _MockCollectionReference mockCollection;
    late _MockDocumentReference mockDocRef;
    late PinService service;

    setUp(() {
      mockFirestore = _MockFirebaseFirestore();
      mockCollection = _MockCollectionReference();
      mockDocRef = _MockDocumentReference();
      service = PinService(firestore: mockFirestore);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    });

    // ========== TEST: Basic Set and Verify ==========
    test('setPin stores PIN in Firestore with merge=true', () async {
      final uid = 'user_pin_set';
      final pin = '1234';

      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async {});

      await service.setPin(uid: uid, pin: pin);

      final setVerify = verify(
        () => mockDocRef.set(captureAny(), captureAny()),
      );
      setVerify.called(1);

      final Map<String, dynamic> data =
          setVerify.captured[0] as Map<String, dynamic>;
      final SetOptions options = setVerify.captured[1] as SetOptions;

      expect(data['pin'], equals(pin));
      expect(
        options.merge,
        isTrue,
        reason: 'setPin should use merge=true to preserve other fields',
      );
    });

    // ========== TEST: Verify Correct PIN ==========
    test('verifyPin returns true when PIN matches', () async {
      final uid = 'user_verify_correct';
      final pin = '5678';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn({'pin': pin});

      final result = await service.verifyPin(uid: uid, pin: pin);

      expect(result, isTrue);
      verify(() => mockDocRef.get()).called(1);
    });

    // ========== TEST: Verify Incorrect PIN ==========
    test('verifyPin returns false when PIN does not match', () async {
      final uid = 'user_verify_wrong';
      final storedPin = '1234';
      final wrongPin = '9999';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn({'pin': storedPin});

      final result = await service.verifyPin(uid: uid, pin: wrongPin);

      expect(result, isFalse);
    });

    // ========== TEST: Missing User Document ==========
    test('verifyPin returns false when user document does not exist', () async {
      final uid = 'user_nonexistent';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.data()).thenReturn(null);

      final result = await service.verifyPin(uid: uid, pin: '1234');

      expect(
        result,
        isFalse,
        reason: 'Should return false when user doc is absent',
      );
    });

    // ========== TEST: Missing PIN Field ==========
    test(
      'verifyPin returns false when PIN field is absent from document',
      () async {
        final uid = 'user_no_pin_field';
        final mockSnapshot = _MockDocumentSnapshot();

        when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
        when(() => mockSnapshot.data()).thenReturn({'username': 'alice'});

        final result = await service.verifyPin(uid: uid, pin: '1234');

        expect(
          result,
          isFalse,
          reason: 'Should handle missing pin field gracefully',
        );
      },
    );

    // ========== TEST: PIN Length Variations ==========
    test('verifyPin handles different PIN lengths correctly', () async {
      final uid = 'user_pin_lengths';
      final mockSnapshot = _MockDocumentSnapshot();

      // Test 4-digit PIN
      when(() => mockSnapshot.data()).thenReturn({'pin': '1234'});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      expect(await service.verifyPin(uid: uid, pin: '1234'), isTrue);
      expect(await service.verifyPin(uid: uid, pin: '123'), isFalse);

      // Test 6-digit PIN
      when(() => mockSnapshot.data()).thenReturn({'pin': '123456'});
      expect(await service.verifyPin(uid: uid, pin: '123456'), isTrue);
      expect(await service.verifyPin(uid: uid, pin: '12345'), isFalse);
    });

    // ========== TEST: Leading Zeros ==========
    test('verifyPin preserves leading zeros in PIN', () async {
      final uid = 'user_leading_zeros';
      final pinWithLeadingZeros = '0001';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockSnapshot.data()).thenReturn({'pin': pinWithLeadingZeros});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      expect(await service.verifyPin(uid: uid, pin: '0001'), isTrue);
      expect(await service.verifyPin(uid: uid, pin: '1'), isFalse);
    });

    // ========== TEST: PIN as Integer vs String ==========
    test('verifyPin handles PIN stored as integer or string', () async {
      final uid = 'user_pin_type';
      final mockSnapshot = _MockDocumentSnapshot();

      // PIN stored as integer
      when(() => mockSnapshot.data()).thenReturn({'pin': 1234});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      final resultInt = await service.verifyPin(uid: uid, pin: '1234');
      expect(
        resultInt,
        isTrue,
        reason: 'Should convert integer PIN to string for comparison',
      );

      // PIN stored as string
      when(() => mockSnapshot.data()).thenReturn({'pin': '1234'});
      final resultStr = await service.verifyPin(uid: uid, pin: '1234');
      expect(resultStr, isTrue);
    });

    // ========== TEST: Merge Safety - Doesn't Wipe Other Fields ==========
    test('setPin uses merge to preserve other profile fields', () async {
      final uid = 'user_merge_safety';
      final pin = '4321';

      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async {});

      await service.setPin(uid: uid, pin: pin);

      final setVerify = verify(() => mockDocRef.set(any(), captureAny()));
      final SetOptions options = setVerify.captured.single as SetOptions;

      expect(
        options.merge,
        isTrue,
        reason: 'setPin must use merge=true to prevent wiping other fields',
      );
    });

    // ========== TEST: Firestore Write Failure ==========
    test('setPin throws on Firestore write failure', () async {
      final uid = 'user_pin_error';
      final pin = '1234';

      when(() => mockDocRef.set(any(), any())).thenThrow(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'PERMISSION_DENIED',
          message: 'Missing write permission',
        ),
      );

      expect(
        () => service.setPin(uid: uid, pin: pin),
        throwsA(isA<FirebaseException>()),
      );
    });

    // ========== TEST: Firestore Read Failure ==========
    test('verifyPin throws on Firestore read failure', () async {
      final uid = 'user_verify_error';

      when(() => mockDocRef.get()).thenThrow(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'UNAVAILABLE',
          message: 'Service temporarily unavailable',
        ),
      );

      expect(
        () => service.verifyPin(uid: uid, pin: '1234'),
        throwsA(isA<FirebaseException>()),
      );
    });

    // ========== TEST: Empty PIN String ==========
    test(
      'setPin accepts empty string (no validation at service level)',
      () async {
        final uid = 'user_empty_pin';
        final emptyPin = '';

        when(() => mockDocRef.set(any(), any())).thenAnswer((_) async {});

        // Service does not validate; assumes UI does
        await service.setPin(uid: uid, pin: emptyPin);

        final setVerify = verify(() => mockDocRef.set(captureAny(), any()));
        final Map<String, dynamic> data =
            setVerify.captured.first as Map<String, dynamic>;

        expect(data['pin'], equals(''));
      },
    );

    // ========== TEST: Case Sensitivity ==========
    test('verifyPin is case-sensitive if PIN contains letters', () async {
      final uid = 'user_case_sensitive';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockSnapshot.data()).thenReturn({'pin': 'AbCd'});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      expect(await service.verifyPin(uid: uid, pin: 'AbCd'), isTrue);
      expect(await service.verifyPin(uid: uid, pin: 'abcd'), isFalse);
    });

    // ========== TEST: Concurrent Verify Calls ==========
    test('verifyPin can be called multiple times concurrently', () async {
      final uid = 'user_concurrent';
      final pin = '1234';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockSnapshot.data()).thenReturn({'pin': pin});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      final results = await Future.wait([
        service.verifyPin(uid: uid, pin: pin),
        service.verifyPin(uid: uid, pin: pin),
        service.verifyPin(uid: uid, pin: '9999'),
      ]);

      expect(results, [true, true, false]);
      verify(() => mockDocRef.get()).called(3);
    });

    // ========== TEST: Whitespace Handling ==========
    test('verifyPin is strict about whitespace', () async {
      final uid = 'user_whitespace';
      final mockSnapshot = _MockDocumentSnapshot();

      when(() => mockSnapshot.data()).thenReturn({'pin': '1234'});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      expect(await service.verifyPin(uid: uid, pin: '1234'), isTrue);
      expect(await service.verifyPin(uid: uid, pin: ' 1234'), isFalse);
      expect(await service.verifyPin(uid: uid, pin: '1234 '), isFalse);
    });

    // ========== TEST: Update PIN (Overwrite) ==========
    test('setPin can update existing PIN', () async {
      final uid = 'user_pin_update';
      final oldPin = '1111';
      final newPin = '2222';

      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async {});

      // First set
      await service.setPin(uid: uid, pin: oldPin);
      // Update
      await service.setPin(uid: uid, pin: newPin);

      final setVerify = verify(() => mockDocRef.set(captureAny(), any()));
      setVerify.called(2);

      // Both calls should succeed
      final allCalls = setVerify.captured;
      expect((allCalls[0] as Map<String, dynamic>)['pin'], equals(oldPin));
      expect((allCalls[1] as Map<String, dynamic>)['pin'], equals(newPin));
    });
  });
}
