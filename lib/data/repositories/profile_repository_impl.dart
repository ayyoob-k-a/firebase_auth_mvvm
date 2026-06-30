import '../../core/errors/exceptions.dart';
import '../../core/utils/app_result.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

/// Concrete implementation of [ProfileRepository].
/// Catches datasource exceptions → converts to [AppFailure].
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  const ProfileRepositoryImpl(this._dataSource);

  @override
  Future<AppResult<UserProfileEntity?>> getProfile(String uid) async {
    try {
      final model = await _dataSource.getProfile(uid);
      return AppSuccess(model);
    } on AuthException catch (e) {
      return AppFailure(e.message);
    } catch (e) {
      return AppFailure('Profile fetch failed: ${e.toString()}');
    }
  }

  @override
  Future<AppResult<void>> saveProfile(UserProfileEntity profile) async {
    try {
      final isNew = profile.createdAt == null;
      await _dataSource.saveProfile(
        UserProfileModel.fromEntity(profile),
        isNew: isNew,
      );
      return const AppSuccess(null);
    } on AuthException catch (e) {
      return AppFailure(e.message);
    } catch (e) {
      return AppFailure('Profile save failed: ${e.toString()}');
    }
  }

  @override
  Stream<UserProfileEntity?> watchProfile(String uid) =>
      _dataSource.watchProfile(uid);
}
