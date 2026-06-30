import '../../core/errors/exceptions.dart';
import '../../core/utils/app_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository].
///
/// Catches [AuthException] from the datasource and converts them into
/// [AppFailure] so the domain layer stays exception-free.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  UserEntity? get currentUser => _dataSource.currentUser;

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<AppResult<UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);
      return AppSuccess(user);
    } on AuthException catch (e) {
      return AppFailure(e.message);
    } catch (_) {
      return const AppFailure('An unexpected error occurred.');
    }
  }

  @override
  Future<AppResult<UserEntity>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signUp(email: email, password: password);
      return AppSuccess(user);
    } on AuthException catch (e) {
      return AppFailure(e.message);
    } catch (_) {
      return const AppFailure('An unexpected error occurred.');
    }
  }

  @override
  Future<AppResult<void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const AppSuccess(null);
    } on AuthException catch (e) {
      return AppFailure(e.message);
    } catch (_) {
      return const AppFailure('Sign out failed.');
    }
  }
}
