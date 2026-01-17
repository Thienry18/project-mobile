import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/data/purchases_service.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class _MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class _MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  test('Buying a course triggers Firestore update on user doc', () async {
    final firestore = _MockFirebaseFirestore();
    final collection = _MockCollectionReference();
    final docRef = _MockDocumentReference();
    final uid = 'user_1';

    when(() => firestore.collection('users')).thenReturn(collection);
    when(() => collection.doc(uid)).thenReturn(docRef);
    when(() => docRef.update(any())).thenAnswer((_) async {});

    final service = PurchasesService(firestore: firestore);
    final course = {'id': 'course_123', 'title': 'Dart 101'};

    await service.buyCourse(uid: uid, courseData: course);

    final invocation = verify(() => docRef.update(captureAny()));
    invocation.called(1);
    final captured = invocation.captured.single as Map;
    expect(captured.containsKey('purchases'), isTrue);
  });
}
