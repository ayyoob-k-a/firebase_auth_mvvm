import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_result.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/sign_in_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

/// ViewModel for the Sign In screen.
///
/// After a successful Firebase sign-in, checks the Firestore profile
/// and emits the correct navigation state.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase _signInUseCase;
  final GetProfileUseCase _getProfileUseCase;

  LoginBloc({
    required SignInUseCase signInUseCase,
    required GetProfileUseCase getProfileUseCase,
  })  : _signInUseCase = signInUseCase,
        _getProfileUseCase = getProfileUseCase,
        super(const LoginInitial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
  }

  LoginFormUpdated get _form => state is LoginFormUpdated
      ? state as LoginFormUpdated
      : LoginFormUpdated(email: state.email, password: state.password);

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) =>
      emit(_form.copyWith(email: event.email));

  void _onPasswordChanged(
          LoginPasswordChanged event, Emitter<LoginState> emit) =>
      emit(_form.copyWith(password: event.password));

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) =>
      emit(_form.copyWith(isPasswordVisible: !_form.isPasswordVisible));

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = state.email.trim();
    final password = state.password;

    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure(
        errorMessage: 'Email and password cannot be empty.',
        email: email,
        password: password,
      ));
      return;
    }

    emit(LoginLoading(email: email, password: password));

    // ── Step 1: Firebase sign in ──────────────────────────────────────────
    final authResult =
        await _signInUseCase(email: email, password: password);

    if (authResult is AppFailure<UserEntity>) {
      emit(LoginFailure(
        errorMessage: authResult.message,
        email: email,
        password: password,
      ));
      return;
    }

    final user = (authResult as AppSuccess<UserEntity>).data;

    // ── Step 2: Check Firestore profile ───────────────────────────────────
    final profileResult = await _getProfileUseCase(user.uid);

    if (profileResult is AppSuccess) {
      final profile = (profileResult as AppSuccess).data;
      if (profile != null && profile.profileCompleted) {
        emit(LoginNavigateToHome(
            uid: user.uid, email: email, password: password));
        return;
      }
    }

    // Profile missing or incomplete → Complete Profile
    emit(LoginNavigateToCompleteProfile(
        user: user, email: email, password: password));
  }
}
