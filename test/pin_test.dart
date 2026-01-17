import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:projek_mobile/data/pin_service.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class _MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class _MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class _MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  test('Set and verify PIN via Firestore', () async {
    final firestore = _MockFirebaseFirestore();
    final collection = _MockCollectionReference();
    final docRef = _MockDocumentReference();
    final snapshot = _MockDocumentSnapshot();
    final uid = 'user_pin';

    when(() => firestore.collection('users')).thenReturn(collection);
    when(() => collection.doc(uid)).thenReturn(docRef);
    when(() => docRef.set(any(), any())).thenAnswer((_) async {});

    // Simulate get returning a snapshot with pin
    when(() => docRef.get()).thenAnswer((_) async => snapshot);
    when(() => snapshot.data()).thenReturn({'pin': '1234'});

    final service = PinService(firestore: firestore);

    await service.setPin(uid: uid, pin: '1234');

    final ok = await service.verifyPin(uid: uid, pin: '1234');
    expect(ok, isTrue);

    when(() => snapshot.data()).thenReturn({'pin': '9999'});
    final bad = await service.verifyPin(uid: uid, pin: '0000');
    expect(bad, isFalse);
  });
}
