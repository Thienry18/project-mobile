import 'package:cloud_firestore/cloud_firestore.dart';

class PurchasesService {
  final FirebaseFirestore firestore;

  PurchasesService({FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  /// Adds [courseData] into the user's `purchases` array in Firestore.
  Future<void> buyCourse({required String uid, required Map<String, dynamic> courseData}) async {
    final doc = firestore.collection('users').doc(uid);
    await doc.update({'purchases': FieldValue.arrayUnion([courseData])});
  }
}
