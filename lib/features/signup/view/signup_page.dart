import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/sign_up_usecase.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../complete_profile/view/complete_profile_page.dart';
import '../view_model/signup_bloc.dart';

/// Create Account page — always navigates to CompleteProfile after signup.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  static const routeName = '/signup';

  static SignupBloc _createBloc() {
    final authDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(authDataSource);
    return SignupBloc(signUpUseCase: SignUpUseCase(authRepository));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            // New user always goes to Complete Profile first.
            final user = UserEntity(
              uid: state.user.uid,
              email: state.user.email,
              displayName: state.user.displayName,
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => CompleteProfilePage(user: user)),
              (route) => false,
            );
          }
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.errorMessage,
                    style: GoogleFonts.outfit()),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios,
                      size: 20, color: AppColors.onBackground),
                ),
                const SizedBox(height: 28),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                        height: 1.15),
                    children: [
                      const TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(color: AppColors.onBackground),
                      ),
                      const TextSpan(
                        text: 'Test app',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'All users are verified to help prevent fake accounts.',
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.subtitle,
                      height: 1.5),
                ),
                const SizedBox(height: 48),
                const _SignupForm(),
                const SizedBox(height: 32),
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
            Text('Already have an account? ',
                style: GoogleFonts.outfit(
                    fontSize: 14, color: AppColors.subtitle)),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text('Sign In',
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        final bloc = context.read<SignupBloc>();
        final isLoading = state is SignupLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => bloc.add(SignupEmailChanged(v)),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Password',
              obscureText: true,
              showToggle: true,
              isVisible: state.isPasswordVisible,
              onChanged: (v) => bloc.add(SignupPasswordChanged(v)),
              onToggleVisibility: () =>
                  bloc.add(const SignupPasswordVisibilityToggled()),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Confirm Password',
              obscureText: true,
              showToggle: true,
              isVisible: state.isConfirmPasswordVisible,
              onChanged: (v) =>
                  bloc.add(SignupConfirmPasswordChanged(v)),
              onToggleVisibility: () =>
                  bloc.add(const SignupConfirmPasswordVisibilityToggled()),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'SIGN UP',
              isLoading: isLoading,
              onPressed: () => bloc.add(const SignupSubmitted()),
            ),
          ],
        );
      },
    );
  }
}
