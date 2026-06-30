import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Returns a real-time stream of the user's Firestore profile document.
/// Emits null when the document doesn't exist.
class WatchProfileUseCase {
  final ProfileRepository _repository;
  const WatchProfileUseCase(this._repository);

  Stream<UserProfileEntity?> call(String uid) =>
      _repository.watchProfile(uid);
}
