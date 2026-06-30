part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
  });

  @override
  List<Object?> get props => [email, password, isPasswordVisible];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginFormUpdated extends LoginState {
  const LoginFormUpdated({
    super.email,
    super.password,
    super.isPasswordVisible,
  });

  LoginFormUpdated copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
  }) =>
      LoginFormUpdated(
        email: email ?? this.email,
        password: password ?? this.password,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      );
}

class LoginLoading extends LoginState {
  const LoginLoading({required super.email, required super.password});
}

/// Profile is complete — navigate to Home.
class LoginNavigateToHome extends LoginState {
  final String uid;
  const LoginNavigateToHome({
    required this.uid,
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [...super.props, uid];
}

/// Profile is missing or incomplete — navigate to Complete Profile.
class LoginNavigateToCompleteProfile extends LoginState {
  final UserEntity user;
  const LoginNavigateToCompleteProfile({
    required this.user,
    required super.email,
    required super.password,
  });

  @override
  List<Object?> get props => [...super.props, user];
}

class LoginFailure extends LoginState {
  final String errorMessage;
  const LoginFailure({
    required this.errorMessage,
    required super.email,
    required super.password,
    super.isPasswordVisible,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
