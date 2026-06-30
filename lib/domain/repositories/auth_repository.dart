import '../../core/utils/app_result.dart';
import '../entities/user_entity.dart';

/// Abstract contract — domain layer declares *what*, not *how*.
/// Implemented in the data layer by [AuthRepositoryImpl].
abstract class AuthRepository {
  /// Returns the currently signed-in user, or null.
  UserEntity? get currentUser;

  /// Signs in with email and password.
  Future<AppResult<UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Creates a new account and signs in.
  Future<AppResult<UserEntity>> signUp({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<AppResult<void>> signOut();

  /// Stream of auth state changes.
  Stream<UserEntity?> get authStateChanges;
}
