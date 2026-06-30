/// Model for the Login/Signup form.
class LoginModel {
  final String email;
  final String password;
  final String confirmPassword;

  const LoginModel({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  LoginModel copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
