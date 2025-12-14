import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import 'firestore_helper.dart';

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
    // Prefer explicit uid from the profile object; otherwise fall back to
    // currently authenticated user. This makes the method more flexible and
    // tolerant of callers that already supply a uid.
    final uid = (profile.uid.isNotEmpty) ? profile.uid : _auth.currentUser?.uid;
    if (uid == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user logged in',
      );
    }

    final now = Timestamp.now();
    final toSet =
        profile.toFirestore(forUpdate: false)
          ..['createdAt'] = now
          ..['updatedAt'] = now;

    try {
      // Ensure we write to `users/{uid}` so Firestore rules that require
      // `request.auth.uid == userId` will permit the write when authenticated.
      await FirestoreHelper.writeDocument(
        'users',
        toSet,
        docId: uid,
        merge: true,
      );
    } on FirebaseException {
      // Rethrow to allow UI to show a helpful dialog (helper already
      // includes project/auth debug info).
      rethrow;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    final uid = (profile.uid.isNotEmpty) ? profile.uid : _auth.currentUser?.uid;
    if (uid == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user logged in',
      );
    }
    final toUpdate = profile.toFirestore(forUpdate: true)
      ..['updatedAt'] = Timestamp.now();
    // Use the helper to perform a merge write to users/{uid}.
    try {
      await FirestoreHelper.writeDocument(
        'users',
        toUpdate,
        docId: uid,
        merge: true,
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}
