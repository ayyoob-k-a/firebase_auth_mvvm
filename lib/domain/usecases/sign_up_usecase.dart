import '../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: create a new account with email + password.
class SignUpUseCase {
  final AuthRepository _repository;
  const SignUpUseCase(this._repository);

  Future<AppResult<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signUp(email: email, password: password);
  }
}
