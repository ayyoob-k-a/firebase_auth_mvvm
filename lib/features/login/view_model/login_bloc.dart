import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../core/utils/app_result.dart';

part 'login_event.dart';
part 'login_state.dart';

/// ViewModel for the Sign In screen.
///
/// Delegates actual authentication to [SignInUseCase] (domain layer).
/// The View dispatches events and reacts to emitted states.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase _signInUseCase;

  LoginBloc({required SignInUseCase signInUseCase})
      : _signInUseCase = signInUseCase,
        super(const LoginInitial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
  }

  LoginFormUpdated get _form => state is LoginFormUpdated
      ? state as LoginFormUpdated
      : LoginFormUpdated(email: state.email, password: state.password);

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(_form.copyWith(email: event.email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(_form.copyWith(password: event.password));
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(_form.copyWith(isPasswordVisible: !_form.isPasswordVisible));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = state.email.trim();
    final password = state.password;

    // ── Client-side validation ────────────────────────────────────────────────
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure(
        errorMessage: 'Email and password cannot be empty.',
        email: email,
        password: password,
        isPasswordVisible: state.isPasswordVisible,
      ));
      return;
    }

    emit(LoginLoading(email: email, password: password));

    // ── Call use case ─────────────────────────────────────────────────────────
    final result = await _signInUseCase(email: email, password: password);

    switch (result) {
      case AppSuccess<UserEntity>(:final data):
        emit(LoginSuccess(user: data, email: email, password: password));
      case AppFailure<UserEntity>(:final message):
        emit(LoginFailure(
          errorMessage: message,
          email: email,
          password: password,
          isPasswordVisible: state.isPasswordVisible,
        ));
    }
  }
}
