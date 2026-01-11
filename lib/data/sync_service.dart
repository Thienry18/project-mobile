import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek_mobile/database/database_service.dart';
import 'package:projek_mobile/database/database_user.dart';
import 'package:projek_mobile/database/database_mycourse.dart';
import 'package:projek_mobile/database/database_course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncService {
  /// Pull user profile, PIN and purchases from Firestore into local DB.
  static Future<void> syncCurrentUserFromFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;
    if (uid == null || email == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!doc.exists) return;
      final data = doc.data() ?? {};

      // Ensure SharedPreferences has the email/username for local resolution
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email.toLowerCase());
        final username =
            data['username'] as String? ??
            prefs.getString('user_username') ??
            '';
        if (username.isNotEmpty)
          await prefs.setString('user_username', username);
      } catch (_) {}

      // Resolve/create local user row
      final userId = await DatabaseUser.getOrCreateUserIdForCurrentAppUser();
      final db = await DatabaseService.instance.database;

      // Prepare updates for local user table
      final updates = <String, Object?>{};
      if (data.containsKey('username'))
        updates['username'] = data['username'] as String? ?? '';
      if (data.containsKey('fullName'))
        updates['fullname'] = data['fullName'] as String? ?? '';
      if (data.containsKey('dateOfBirth')) {
        try {
          final ts = data['dateOfBirth'];
          if (ts is Timestamp)
            updates['day_of_birth'] = ts.toDate().toIso8601String();
        } catch (_) {}
      }
      if (data.containsKey('sex'))
        updates['gender'] = data['sex'] as String? ?? '';
      if (data.containsKey('phoneNumber'))
        updates['phone_number'] = data['phoneNumber'] as String? ?? '';
      if (data.containsKey('country'))
        updates['country'] = data['country'] as String? ?? '';
      if (data.containsKey('pin'))
        updates['pin'] = data['pin'] as String? ?? '';

      if (updates.isNotEmpty) {
        try {
          await DatabaseUser.updateUserByEmail(
            db,
            email.toLowerCase(),
            updates,
          );
        } catch (_) {}
      }

      // Sync purchases -> mycourse table
      final purchases = data['purchases'];
      if (purchases is List) {
        try {
          final existing = await DatabaseMyCourse.getMyCourses(db, userId);
          final existingIds =
              existing.map((e) => e['course_id'] as int).toSet();

          for (final p in purchases) {
            final cid = p is int ? p : int.tryParse(p.toString());
            if (cid == null) continue;
            if (existingIds.contains(cid)) continue;
            final course = await DatabaseCourse.getCourseByIdForApp(cid);
            if (course == null) continue;
            await DatabaseMyCourse.addMyCourse(db, {
              'user_id': userId,
              'course_id': cid,
              'title': course.title,
              'instructor': course.instructor,
              'image': course.images,
              'price': course.price,
              'purchased_at': DateTime.now().millisecondsSinceEpoch,
            });
          }
        } catch (_) {}
      }

      // Done
    } catch (_) {
      // ignore
    }
  }
}
