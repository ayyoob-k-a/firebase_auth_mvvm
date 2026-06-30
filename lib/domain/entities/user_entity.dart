import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
/// No Firebase types leak into the domain layer.
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];
}
