import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String username;
  final String fullName;
  final Timestamp dateOfBirth;
  final String sex; // 'male' | 'female'
  final String phoneNumber;
  final String country;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  UserProfile({
    String? uid,
    this.username = '',
    this.fullName = '',
    Timestamp? dateOfBirth,
    String? sex,
    this.phoneNumber = '',
    this.country = '',
    Timestamp? createdAt,
    Timestamp? updatedAt,
    // Backwards-compatible legacy params used across the app
    String? dob,
    String? gender,
  }) : uid = uid ?? '',
       // If explicit Timestamp is provided use it; otherwise try to parse legacy `dob` string.
       dateOfBirth = dateOfBirth ?? _parseDob(dob),
       sex =
           (gender != null && gender.isNotEmpty)
               ? gender
               : (sex != null && sex.isNotEmpty ? sex : 'male'),
       createdAt = createdAt ?? Timestamp.now(),
       updatedAt = updatedAt ?? Timestamp.now();

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return UserProfile(
      uid: doc.id,
      username: data['username'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      dateOfBirth:
          (data['dateOfBirth'] is Timestamp)
              ? data['dateOfBirth'] as Timestamp
              : Timestamp.fromDate(DateTime(1970)),
      sex: data['sex'] as String? ?? 'male',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      country: data['country'] as String? ?? '',
      createdAt:
          (data['createdAt'] is Timestamp)
              ? data['createdAt'] as Timestamp
              : Timestamp.now(),
      updatedAt:
          (data['updatedAt'] is Timestamp)
              ? data['updatedAt'] as Timestamp
              : Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore({bool forUpdate = false}) {
    final map = <String, dynamic>{
      'username': username,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'sex': sex,
      'phoneNumber': phoneNumber,
      'country': country,
    };
    if (!forUpdate) map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  static Timestamp _parseDob(String? dob) {
    if (dob == null || dob.isEmpty) return Timestamp.fromDate(DateTime(1970));
    try {
      // Expect formats like "dd/MM/yyyy" or ISO-like strings. Try to be tolerant.
      if (dob.contains('/')) {
        final parts = dob.split('/');
        if (parts.length == 3) {
          final d = int.tryParse(parts[0]) ?? 1;
          final m = int.tryParse(parts[1]) ?? 1;
          final y = int.tryParse(parts[2]) ?? 1970;
          return Timestamp.fromDate(DateTime(y, m, d));
        }
      }
      // fallback parse ISO
      final dt = DateTime.tryParse(dob);
      if (dt != null) return Timestamp.fromDate(dt);
    } catch (_) {}
    return Timestamp.fromDate(DateTime(1970));
  }

  // Backwards-compatible getters for older code expecting `dob` and `gender`.
  String get dob => dateOfBirth.toDate().toIso8601String().split('T').first;
  String get gender => sex;
}
