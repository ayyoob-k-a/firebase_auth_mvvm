import '../../core/utils/app_result.dart';
import '../repositories/auth_repository.dart';

/// Use case: sign out the currently authenticated user.
class SignOutUseCase {
  final AuthRepository _repository;
  const SignOutUseCase(this._repository);

  Future<AppResult<void>> call() => _repository.signOut();
}
