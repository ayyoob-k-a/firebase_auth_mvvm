import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/features/complete_profile/view/complete_profile_page.dart';
import 'package:test_app/features/home/view/home_page.dart';
import 'package:test_app/features/signup/view/signup_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../../data/datasources/profile/profile_remote_datasource.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../../../../data/repositories/profile_repository_impl.dart';
import '../../../../domain/usecases/get_profile_usecase.dart';
import '../../../../domain/usecases/sign_in_usecase.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

import '../view_model/login_bloc.dart';

/// Sign In page — View in MVVM.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  static LoginBloc _createBloc() {
    final authDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(authDataSource);
    final profileDataSource = ProfileRemoteDataSourceImpl();
    final profileRepository = ProfileRepositoryImpl(profileDataSource);
    return LoginBloc(
      signInUseCase: SignInUseCase(authRepository),
      getProfileUseCase: GetProfileUseCase(profileRepository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginNavigateToHome) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomePage(uid: state.uid)),
              (route) => false,
            );
          } else if (state is LoginNavigateToCompleteProfile) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => CompleteProfilePage(user: state.user),
              ),
              (route) => false,
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage,
                    style: GoogleFonts.outfit(),
                  ),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onBackground,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to continue to your account.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.subtitle,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                const _SignInForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.subtitle,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SignupPage())),
              child: Text(
                'Sign Up',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();
        final isLoading = state is LoginLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => bloc.add(LoginEmailChanged(v)),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Password',
              obscureText: true,
              showToggle: true,
              isVisible: state.isPasswordVisible,
              onChanged: (v) => bloc.add(LoginPasswordChanged(v)),
              onToggleVisibility: () =>
                  bloc.add(const LoginPasswordVisibilityToggled()),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'SIGN IN',
              isLoading: isLoading,
              onPressed: () => bloc.add(const LoginSubmitted()),
            ),
          ],
        );
      },
    );
  }
}
