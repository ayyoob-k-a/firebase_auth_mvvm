import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_lists.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/datasources/profile/profile_remote_datasource.dart';
import '../../../../data/repositories/profile_repository_impl.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/save_profile_usecase.dart';
import '../../../../shared/widgets/app_dropdown.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/gender_selector.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../home/view/home_page.dart';
import '../view_model/complete_profile_bloc.dart';

/// Complete Profile page — blocks navigation to Home until submitted.
class CompleteProfilePage extends StatelessWidget {
  final UserEntity user;

  const CompleteProfilePage({super.key, required this.user});

  static const routeName = '/complete-profile';

  static CompleteProfileBloc _createBloc(UserEntity user) {
    final profileDataSource = ProfileRemoteDataSourceImpl();
    final profileRepository = ProfileRepositoryImpl(profileDataSource);
    final saveProfileUseCase = SaveProfileUseCase(profileRepository);
    return CompleteProfileBloc(
      saveProfileUseCase: saveProfileUseCase,
      user: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc(user),
      child: const _CompleteProfileView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _CompleteProfileView extends StatelessWidget {
  const _CompleteProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomePage(uid: state.profile.uid),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
                transitionDuration: const Duration(milliseconds: 500),
              ),
              (route) => false,
            );
          }
          if (state is CompleteProfileFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content:
                    Text(state.errorMessage, style: GoogleFonts.outfit()),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ──────────────────────────────────────────────
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 16, color: AppColors.onBackground),
                    onPressed: () => Navigator.of(context).maybePop(),
                    padding: EdgeInsets.zero,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Heading ──────────────────────────────────────────────────
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        height: 1.2),
                    children: [
                      TextSpan(
                        text: 'Create your ',
                        style: const TextStyle(color: AppColors.onBackground),
                      ),
                      TextSpan(
                        text: 'Profile',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Create your profile with some basic information',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onBackground,
                  ),
                ),

                const SizedBox(height: 36),

                const _ProfileForm(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Form ─────────────────────────────────────────────────────────────────────

class _ProfileForm extends StatefulWidget {
  const _ProfileForm();

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.year}';
      context
          .read<CompleteProfileBloc>()
          .add(ProfileDobChanged(formatted));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        final bloc = context.read<CompleteProfileBloc>();
        final isLoading = state is CompleteProfileLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name ────────────────────────────────────────────────────────
            const SectionLabel("What's your Name"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: 'First Name',
                    controller: _firstNameController,
                    onChanged: (v) =>
                        bloc.add(ProfileFirstNameChanged(v)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    hint: 'Last Name',
                    controller: _lastNameController,
                    onChanged: (v) =>
                        bloc.add(ProfileLastNameChanged(v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'First name is only visible on your profile.',
              style: GoogleFonts.outfit(
                  fontSize: 12, color: AppColors.subtitle),
            ),

            const SizedBox(height: 28),

            // ── DOB ─────────────────────────────────────────────────────────
            const SectionLabel("What's your date of birth"),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: AppTextField(
                  hint: 'dd-mm-yyyy',
                  controller: TextEditingController(text: state.dob),
                  onChanged: (_) {},
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Gender ───────────────────────────────────────────────────────
            const SectionLabel("What's your gender"),
            const SizedBox(height: 14),
            GenderSelector(
              selected: state.gender.isEmpty ? null : state.gender,
              options: kGenders,
              onChanged: (v) => bloc.add(ProfileGenderChanged(v)),
            ),

            const SizedBox(height: 28),

            // ── Nationality ──────────────────────────────────────────────────
            const SectionLabel("What's your nationality"),
            const SizedBox(height: 12),
            AppDropdown<String>(
              hint: 'Select nationality',
              value: state.nationality.isEmpty ? null : state.nationality,
              items: kNationalities,
              onChanged: (v) {
                if (v != null) bloc.add(ProfileNationalityChanged(v));
              },
            ),

            const SizedBox(height: 28),

            // ── Language ─────────────────────────────────────────────────────
            const SectionLabel('Languages spoken'),
            const SizedBox(height: 12),
            AppDropdown<String>(
              hint: 'Select language',
              value: state.language.isEmpty ? null : state.language,
              items: kLanguages,
              onChanged: (v) {
                if (v != null) bloc.add(ProfileLanguageChanged(v));
              },
            ),

            const SizedBox(height: 36),

            // ── Save button ──────────────────────────────────────────────────
            PrimaryButton(
              label: 'Save',
              isLoading: isLoading,
              onPressed: () => bloc.add(const ProfileSubmitted()),
            ),
          ],
        );
      },
    );
  }
}
