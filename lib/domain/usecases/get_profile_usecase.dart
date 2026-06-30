import '../../core/utils/app_result.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Fetches a user profile from Firestore once.
/// Returns null inside [AppSuccess] if the document doesn't exist.
class GetProfileUseCase {
  final ProfileRepository _repository;
  const GetProfileUseCase(this._repository);

  Future<AppResult<UserProfileEntity?>> call(String uid) =>
      _repository.getProfile(uid);
}
