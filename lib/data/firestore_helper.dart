import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Lightweight helper for writing documents. Firestore auto-creates
/// collections when a document is written; this helper centralizes
/// error handling and provides a convenient API for creating or
/// appending documents.
class FirestoreHelper {
  static final FirebaseFirestore _fs = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Write [data] into [collection]. If [docId] is provided the document
  /// with that id will be written (useful for `users/{uid}` where the
  /// document id must match the authenticated user's uid). If [merge]
  /// is true the write will be merged with existing data (create-or-update).
  ///
  /// Returns the resulting `DocumentReference` on success. Throws a
  /// `FirebaseException` on failure with extra debug info appended.
  static Future<DocumentReference<Map<String, dynamic>>> writeDocument(
    String collection,
    Map<String, dynamic> data, {
    String? docId,
    bool merge = false,
  }) async {
    try {
      final col = _fs.collection(collection);
      if (docId != null) {
        final docRef = col.doc(docId);
        if (merge) {
          await docRef.set(
            Map<String, dynamic>.from(data),
            SetOptions(merge: true),
          );
        } else {
          await docRef.set(Map<String, dynamic>.from(data));
        }
        return docRef;
      } else {
        final added = await col.add(Map<String, dynamic>.from(data));
        return added;
      }
    } on FirebaseException catch (e) {
      final proj = _fs.app.options.projectId;
      final authUid = _auth.currentUser?.uid ?? '<no-auth-user>';
      throw FirebaseException(
        plugin: e.plugin,
        code: e.code,
        message: '${e.message} (project=$proj, authUid=$authUid)',
      );
    }
  }
}
