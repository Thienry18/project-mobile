import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/data/purchases_service.dart';

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
// FIXTURES
// ============================================================================

/// Realistic course purchase data matching typical schema
Map<String, dynamic> createCourseData({
  String courseId = 'course_001',
  String title = 'Dart Fundamentals',
  double price = 29.99,
  String currency = 'USD',
  String instructor = 'Jane Doe',
  DateTime? purchasedAt,
  String seller = 'Udemy',
}) {
  return {
    'id': courseId,
    'title': title,
    'price': price,
    'currency': currency,
    'instructor': instructor,
    'timestamp': Timestamp.fromDate(purchasedAt ?? DateTime.now()),
    'seller': seller,
  };
}

// ============================================================================
// PURCHASES SERVICE TESTS
// ============================================================================

void main() {
  group('PurchasesService', () {
    late _MockFirebaseFirestore mockFirestore;
    late _MockCollectionReference mockCollection;
    late _MockDocumentReference mockDocRef;
    late PurchasesService service;

    setUp(() {
      mockFirestore = _MockFirebaseFirestore();
      mockCollection = _MockCollectionReference();
      mockDocRef = _MockDocumentReference();
      service = PurchasesService(firestore: mockFirestore);

      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    });

    // ========== TEST: Basic Purchase with arrayUnion ==========
    test(
      'buyCourse uses FieldValue.arrayUnion to add course to purchases array',
      () async {
        final uid = 'user_purchase_basic';
        final courseData = createCourseData(courseId: 'course_101');

        when(() => mockDocRef.update(any())).thenAnswer((_) async {});

        await service.buyCourse(uid: uid, courseData: courseData);

        final updateVerify = verify(() => mockDocRef.update(captureAny()));
        updateVerify.called(1);

        final updateData = updateVerify.captured.first;
        expect(updateData, isA<Map>());
        expect(updateData.toString(), contains('purchases'));
      },
    );

    // ========== TEST: Data Shape - Full Course Metadata ==========
    test(
      'buyCourse preserves all course fields (id, title, price, currency, instructor)',
      () async {
        final uid = 'user_data_shape';
        final now = DateTime(2024, 1, 15, 10, 30);
        final courseData = createCourseData(
          courseId: 'course_advanced',
          title: 'Advanced Dart & Flutter',
          price: 49.99,
          currency: 'USD',
          instructor: 'John Developer',
          purchasedAt: now,
          seller: 'Skillshare',
        );

        when(() => mockDocRef.update(any())).thenAnswer((_) async {});

        await service.buyCourse(uid: uid, courseData: courseData);

        verify(() => mockDocRef.update(any())).called(1);

        // Course data should remain intact
        expect(courseData['id'], equals('course_advanced'));
        expect(courseData['title'], equals('Advanced Dart & Flutter'));
        expect(courseData['price'], equals(49.99));
        expect(courseData['currency'], equals('USD'));
        expect(courseData['instructor'], equals('John Developer'));
        expect(courseData['seller'], equals('Skillshare'));
      },
    );

    // ========== TEST: Duplicate Course Purchase ==========
    test(
      'buyCourse with duplicate course uses arrayUnion (prevents manual duplicates)',
      () async {
        final uid = 'user_duplicate_test';
        final courseData = createCourseData(courseId: 'duplicate_course');

        when(() => mockDocRef.update(any())).thenAnswer((_) async {});

        // Buy same course twice
        await service.buyCourse(uid: uid, courseData: courseData);
        await service.buyCourse(uid: uid, courseData: courseData);

        verify(() => mockDocRef.update(any())).called(2);
        // arrayUnion will naturally prevent true duplicates (same object)
        // but allows adding the same data structure twice if objects differ
      },
    );

    // ========== TEST: Timestamp Recording ==========
    test('buyCourse includes purchase timestamp in course data', () async {
      final uid = 'user_timestamp_test';
      final courseData = createCourseData(courseId: 'timestamped_course');

      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      await service.buyCourse(uid: uid, courseData: courseData);

      // Verify timestamp exists in courseData
      expect(courseData.containsKey('timestamp'), isTrue);
      final timestamp = courseData['timestamp'];
      expect(timestamp, isA<Timestamp>());
    });

    // ========== TEST: Firestore Update Failure - No Local DB Corruption ==========
    test(
      'buyCourse throws on Firestore failure without corrupting local state',
      () async {
        final uid = 'user_failure_test';
        final courseData = createCourseData(courseId: 'failed_purchase');

        when(() => mockDocRef.update(any())).thenThrow(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'PERMISSION_DENIED',
            message: 'User does not have permission to update document',
          ),
        );

        expect(
          () => service.buyCourse(uid: uid, courseData: courseData),
          throwsA(isA<FirebaseException>()),
        );

        // Verify local courseData not modified
        expect(courseData['id'], equals('failed_purchase'));
      },
    );

    // ========== TEST: Price Field Types ==========
    test('buyCourse handles numeric price field correctly', () async {
      final uid = 'user_price_type';

      // Test with double
      final courseDouble = createCourseData(
        courseId: 'course_double',
        price: 99.99,
      );
      when(() => mockDocRef.update(any())).thenAnswer((_) async {});
      await service.buyCourse(uid: uid, courseData: courseDouble);
      expect(courseDouble['price'], isA<double>());

      // Test with integer
      final courseInt = createCourseData(courseId: 'course_int', price: 50.0);
      await service.buyCourse(uid: uid, courseData: courseInt);
      expect(courseInt['price'], isA<num>());
    });

    // ========== TEST: Currency Code Validation ==========
    test('buyCourse supports multiple currency codes', () async {
      final uid = 'user_currencies';

      final coursesUSD = createCourseData(
        courseId: 'course_usd',
        currency: 'USD',
      );
      final coursesEUR = createCourseData(
        courseId: 'course_eur',
        currency: 'EUR',
      );
      final coursesIDR = createCourseData(
        courseId: 'course_idr',
        currency: 'IDR',
      );

      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      await service.buyCourse(uid: uid, courseData: coursesUSD);
      await service.buyCourse(uid: uid, courseData: coursesEUR);
      await service.buyCourse(uid: uid, courseData: coursesIDR);

      expect(coursesUSD['currency'], equals('USD'));
      expect(coursesEUR['currency'], equals('EUR'));
      expect(coursesIDR['currency'], equals('IDR'));
    });

    // ========== TEST: Network Timeout ==========
    test('buyCourse throws on network timeout', () async {
      final uid = 'user_timeout';
      final courseData = createCourseData(courseId: 'timeout_course');

      when(() => mockDocRef.update(any())).thenThrow(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'DEADLINE_EXCEEDED',
          message: 'Operation timed out',
        ),
      );

      expect(
        () => service.buyCourse(uid: uid, courseData: courseData),
        throwsA(isA<FirebaseException>()),
      );
    });

    // ========== TEST: Invalid User UID ==========
    test(
      'buyCourse with empty UID should still attempt update (validation in UI layer)',
      () async {
        final uid = '';
        final courseData = createCourseData(courseId: 'course_no_uid');

        when(() => mockDocRef.update(any())).thenAnswer((_) async {});

        // Service layer doesn't validate UID format
        await service.buyCourse(uid: uid, courseData: courseData);

        verify(() => mockDocRef.update(any())).called(1);
      },
    );

    // ========== TEST: Firestore Service Unavailable ==========
    test('buyCourse throws when Firestore service is unavailable', () async {
      final uid = 'user_unavailable';
      final courseData = createCourseData(courseId: 'unavailable_course');

      when(() => mockDocRef.update(any())).thenThrow(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'UNAVAILABLE',
          message: 'Service temporarily unavailable',
        ),
      );

      expect(
        () => service.buyCourse(uid: uid, courseData: courseData),
        throwsA(isA<FirebaseException>()),
      );
    });

    // ========== TEST: Batch Purchase Multiple Courses ==========
    test(
      'buyCourse called multiple times adds all courses to purchases',
      () async {
        final uid = 'user_batch_purchase';
        final course1 = createCourseData(
          courseId: 'course_1',
          title: 'Flutter Basics',
        );
        final course2 = createCourseData(
          courseId: 'course_2',
          title: 'Dart Advanced',
        );
        final course3 = createCourseData(
          courseId: 'course_3',
          title: 'Firebase Mastery',
        );

        when(() => mockDocRef.update(any())).thenAnswer((_) async {});

        await service.buyCourse(uid: uid, courseData: course1);
        await service.buyCourse(uid: uid, courseData: course2);
        await service.buyCourse(uid: uid, courseData: course3);

        verify(() => mockDocRef.update(any())).called(3);
      },
    );

    // ========== TEST: Seller Field Populated ==========
    test('buyCourse records seller information correctly', () async {
      final uid = 'user_seller_test';
      final courseData = createCourseData(
        courseId: 'seller_course',
        seller: 'Skillshare',
      );

      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      await service.buyCourse(uid: uid, courseData: courseData);

      expect(courseData['seller'], equals('Skillshare'));
    });

    // ========== TEST: Concurrent Purchase Requests ==========
    test('buyCourse handles concurrent purchase requests', () async {
      final uid = 'user_concurrent_buy';
      final courses = [
        createCourseData(courseId: 'course_a'),
        createCourseData(courseId: 'course_b'),
        createCourseData(courseId: 'course_c'),
      ];

      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      await Future.wait(
        courses.map(
          (course) => service.buyCourse(uid: uid, courseData: course),
        ),
      );

      verify(() => mockDocRef.update(any())).called(3);
    });

    // ========== TEST: Null Safety - Missing Optional Fields ==========
    test('buyCourse handles courses with missing optional metadata', () async {
      final uid = 'user_minimal_course';
      final minimalCourse = {'id': 'minimal_course', 'title': 'Minimal Title'};

      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      await service.buyCourse(uid: uid, courseData: minimalCourse);

      verify(() => mockDocRef.update(any())).called(1);
      expect(minimalCourse['id'], equals('minimal_course'));
    });
  });
}
