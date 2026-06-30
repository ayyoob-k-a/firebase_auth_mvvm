import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_profile_entity.dart';

/// Data model that extends [UserProfileEntity] and adds Firestore
/// serialisation / deserialisation logic.
class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.uid,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.dob,
    required super.gender,
    required super.nationality,
    required super.language,
    required super.profileCompleted,
    super.createdAt,
    super.updatedAt,
  });

  // ── Firestore → Model ──────────────────────────────────────────────────────

  factory UserProfileModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return UserProfileModel(
      uid: d['uid'] as String? ?? '',
      email: d['email'] as String? ?? '',
      firstName: d['firstName'] as String? ?? '',
      lastName: d['lastName'] as String? ?? '',
      dob: d['dob'] as String? ?? '',
      gender: d['gender'] as String? ?? '',
      nationality: d['nationality'] as String? ?? '',
      language: d['language'] as String? ?? '',
      profileCompleted: d['profileCompleted'] as bool? ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── Model → Firestore ──────────────────────────────────────────────────────

  Map<String, dynamic> toFirestore({bool isNew = false}) => {
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'gender': gender,
        'nationality': nationality,
        'language': language,
        'profileCompleted': profileCompleted,
        if (isNew) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  // ── Clone from entity ──────────────────────────────────────────────────────

  factory UserProfileModel.fromEntity(UserProfileEntity e) => UserProfileModel(
        uid: e.uid,
        email: e.email,
        firstName: e.firstName,
        lastName: e.lastName,
        dob: e.dob,
        gender: e.gender,
        nationality: e.nationality,
        language: e.language,
        profileCompleted: e.profileCompleted,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );
}
