part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const SignupState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        isPasswordVisible,
        isConfirmPasswordVisible,
      ];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupFormUpdated extends SignupState {
  const SignupFormUpdated({
    super.email,
    super.password,
    super.confirmPassword,
    super.isPasswordVisible,
    super.isConfirmPasswordVisible,
  });

  SignupFormUpdated copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) =>
      SignupFormUpdated(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible:
            isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      );
}

class SignupLoading extends SignupState {
  const SignupLoading({
    required super.email,
    required super.password,
    required super.confirmPassword,
  });
}

class SignupSuccess extends SignupState {
  final UserEntity user;
  const SignupSuccess({
    required this.user,
    required super.email,
    required super.password,
    required super.confirmPassword,
  });

  @override
  List<Object?> get props => [...super.props, user];
}

class SignupFailure extends SignupState {
  final String errorMessage;
  const SignupFailure({
    required this.errorMessage,
    required super.email,
    required super.password,
    required super.confirmPassword,
    super.isPasswordVisible,
    super.isConfirmPasswordVisible,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
