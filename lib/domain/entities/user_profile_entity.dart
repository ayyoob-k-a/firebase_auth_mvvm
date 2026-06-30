import 'package:equatable/equatable.dart';

/// Domain entity for a user's Firestore profile document.
/// Pure Dart — no Firebase/Flutter dependencies.
class UserProfileEntity extends Equatable {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String nationality;
  final String language;
  final bool profileCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.nationality,
    required this.language,
    required this.profileCompleted,
    this.createdAt,
    this.updatedAt,
  });

  /// Convenience getter used on the Home screen.
  String get fullName => '$firstName $lastName'.trim();

  /// Returns initials for the avatar (max 2 chars).
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [
        uid, email, firstName, lastName, dob,
        gender, nationality, language, profileCompleted,
        createdAt, updatedAt,
      ];
}
