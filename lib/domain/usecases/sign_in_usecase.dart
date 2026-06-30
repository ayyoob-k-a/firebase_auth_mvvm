import '../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: sign in an existing user with email + password.
class SignInUseCase {
  final AuthRepository _repository;
  const SignInUseCase(this._repository);

  Future<AppResult<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
