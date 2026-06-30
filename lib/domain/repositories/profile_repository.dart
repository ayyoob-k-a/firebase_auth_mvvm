import '../../core/utils/app_result.dart';
import '../entities/user_profile_entity.dart';

/// Domain contract for profile storage operations.
/// The data layer provides the concrete implementation.
abstract class ProfileRepository {
  /// Fetches profile once. Returns null if document doesn't exist.
  Future<AppResult<UserProfileEntity?>> getProfile(String uid);

  /// Creates or merges the profile document in Firestore.
  Future<AppResult<void>> saveProfile(UserProfileEntity profile);

  /// Real-time stream — emits every time the Firestore document changes.
  Stream<UserProfileEntity?> watchProfile(String uid);
}
