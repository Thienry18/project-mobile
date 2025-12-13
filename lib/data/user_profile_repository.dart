import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserProfileRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<UserProfile?> fetchProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromFirestore(doc);
  }

  Future<void> createProfile(UserProfile profile) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null)
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user logged in',
      );
    final now = Timestamp.now();
    final toSet =
        profile.toFirestore(forUpdate: false)
          ..['createdAt'] = now
          ..['updatedAt'] = now;
    await _usersCollection.doc(uid).set(Map<String, dynamic>.from(toSet));
  }

  Future<void> updateProfile(UserProfile profile) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null)
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user logged in',
      );
    final toUpdate = profile.toFirestore(forUpdate: true)
      ..['updatedAt'] = Timestamp.now();
    await _usersCollection.doc(uid).update(Map<String, dynamic>.from(toUpdate));
  }
}
