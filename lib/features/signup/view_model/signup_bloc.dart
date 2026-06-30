import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_result.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/sign_up_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

/// ViewModel for the Create Account screen.
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignUpUseCase _signUpUseCase;

  SignupBloc({required SignUpUseCase signUpUseCase})
      : _signUpUseCase = signUpUseCase,
        super(const SignupInitial()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<SignupConfirmPasswordVisibilityToggled>(
        _onConfirmPasswordVisibilityToggled);
    on<SignupSubmitted>(_onSubmitted);
  }

  SignupFormUpdated get _form => state is SignupFormUpdated
      ? state as SignupFormUpdated
      : SignupFormUpdated(
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
        );

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) =>
      emit(_form.copyWith(email: event.email));

  void _onPasswordChanged(
          SignupPasswordChanged event, Emitter<SignupState> emit) =>
      emit(_form.copyWith(password: event.password));

  void _onConfirmPasswordChanged(
          SignupConfirmPasswordChanged event, Emitter<SignupState> emit) =>
      emit(_form.copyWith(confirmPassword: event.confirmPassword));

  void _onPasswordVisibilityToggled(
    SignupPasswordVisibilityToggled event,
    Emitter<SignupState> emit,
  ) =>
      emit(_form.copyWith(isPasswordVisible: !_form.isPasswordVisible));

  void _onConfirmPasswordVisibilityToggled(
    SignupConfirmPasswordVisibilityToggled event,
    Emitter<SignupState> emit,
  ) =>
      emit(_form.copyWith(
          isConfirmPasswordVisible: !_form.isConfirmPasswordVisible));

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    final email = state.email.trim();
    final password = state.password;
    final confirmPassword = state.confirmPassword;

    // ── Validation ────────────────────────────────────────────────────────────
    if (email.isEmpty || password.isEmpty) {
      emit(SignupFailure(
        errorMessage: 'All fields are required.',
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));
      return;
    }
    if (password.length < 6) {
      emit(SignupFailure(
        errorMessage: 'Password must be at least 6 characters.',
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));
      return;
    }
    if (password != confirmPassword) {
      emit(SignupFailure(
        errorMessage: 'Passwords do not match.',
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      ));
      return;
    }

    emit(SignupLoading(
        email: email, password: password, confirmPassword: confirmPassword));

    final result = await _signUpUseCase(email: email, password: password);

    switch (result) {
      case AppSuccess<UserEntity>(:final data):
        emit(SignupSuccess(
          user: data,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        ));
      case AppFailure<UserEntity>(:final message):
        emit(SignupFailure(
          errorMessage: message,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          isPasswordVisible: state.isPasswordVisible,
          isConfirmPasswordVisible: state.isConfirmPasswordVisible,
        ));
    }
  }
}
