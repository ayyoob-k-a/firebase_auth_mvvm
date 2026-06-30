import '../../core/utils/app_result.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Saves (create or update) the user profile in Firestore.
class SaveProfileUseCase {
  final ProfileRepository _repository;
  const SaveProfileUseCase(this._repository);

  Future<AppResult<void>> call(UserProfileEntity profile) =>
      _repository.saveProfile(profile);
}
