import 'package:cloud_firestore/cloud_firestore.dart';

class PinService {
  final FirebaseFirestore firestore;

  PinService({FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> setPin({required String uid, required String pin}) async {
    final doc = firestore.collection('users').doc(uid);
    await doc.set({'pin': pin}, SetOptions(merge: true));
  }

  Future<bool> verifyPin({required String uid, required String pin}) async {
    final doc = await firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) return false;
    return (data['pin']?.toString() ?? '') == pin;
  }
}
