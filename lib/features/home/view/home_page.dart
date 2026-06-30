import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_result.dart';
import '../../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../../data/datasources/profile/profile_remote_datasource.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../../../../data/repositories/profile_repository_impl.dart';
import '../../../../domain/entities/user_profile_entity.dart';
import '../../../../domain/usecases/sign_out_usecase.dart';
import '../../../../domain/usecases/watch_profile_usecase.dart';
import '../../login/view/login_page.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_state.dart';

/// Home page — requires a completed Firestore profile.
/// Shows a real-time updating premium dashboard card.
class HomePage extends StatelessWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  static const routeName = '/home';

  static HomeCubit _createCubit(String uid) {
    final authDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(authDataSource);
    final profileDataSource = ProfileRemoteDataSourceImpl();
    final profileRepository = ProfileRepositoryImpl(profileDataSource);
    return HomeCubit(
      watchProfileUseCase: WatchProfileUseCase(profileRepository),
      signOutUseCase: SignOutUseCase(authRepository),
      uid: uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createCubit(uid),
      child: const _HomeView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _HomeView extends StatelessWidget {
  const _HomeView();

  Future<void> _signOut(BuildContext context) async {
    final cubit = context.read<HomeCubit>();
    final result = await cubit.signOut();
    if (!context.mounted) return;
    if (result is AppSuccess) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else if (result is AppFailure) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text((result as AppFailure).message,
            style: GoogleFonts.outfit()),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'FIRE AUTH',
          style: GoogleFonts.dmSerifDisplay(
              fontSize: 20, color: Colors.white, letterSpacing: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: Colors.white, size: 22),
            tooltip: 'Sign Out',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is HomeError) {
            return Center(
              child: Text(state.message,
                  style: GoogleFonts.outfit(color: AppColors.subtitle)),
            );
          }
          if (state is HomeLoaded) {
            return _ProfileDashboard(profile: state.profile);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Dashboard Card ───────────────────────────────────────────────────────────

class _ProfileDashboard extends StatefulWidget {
  final UserProfileEntity profile;
  const _ProfileDashboard({required this.profile});

  @override
  State<_ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<_ProfileDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'My Profile',
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: 28, color: AppColors.onBackground),
              ),
              const SizedBox(height: 4),
              Text(
                'Your profile information',
                style: GoogleFonts.outfit(
                    fontSize: 13, color: AppColors.subtitle),
              ),
              const SizedBox(height: 24),

              // ── Card ────────────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Avatar + name header ──────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  width: 2),
                            ),
                            child: Center(
                              child: Text(
                                p.initials,
                                style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.fullName,
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 22,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.email,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color:
                                        Colors.white.withValues(alpha: 0.85),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Info rows ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _InfoTile(
                              icon: Icons.cake_outlined,
                              label: 'Date of Birth',
                              value: p.dob),
                          _Divider(),
                          _InfoTile(
                              icon: Icons.people_outline,
                              label: 'Gender',
                              value: p.gender),
                          _Divider(),
                          _InfoTile(
                              icon: Icons.flag_outlined,
                              label: 'Nationality',
                              value: p.nationality),
                          _Divider(),
                          _InfoTile(
                              icon: Icons.language_outlined,
                              label: 'Language',
                              value: p.language),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: Color(0xFFF0F0F0));
}
