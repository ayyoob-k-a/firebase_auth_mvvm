import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../complete_profile/view/complete_profile_page.dart';
import '../../home/view/home_page.dart';
import '../../login/view/login_page.dart';
import '../view_model/splash_bloc.dart';
import 'widgets/typewriter_text.dart';

/// Splash screen — shows typewriter animation then navigates based on
/// Firebase auth state + Firestore profile completion status.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(const SplashStarted()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  PageRoute _fadeRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToLogin) {
            Navigator.of(context).pushReplacement(
                _fadeRoute(const LoginPage()));
          } else if (state is SplashNavigateToCompleteProfile) {
            Navigator.of(context).pushReplacement(
                _fadeRoute(CompleteProfilePage(user: state.user)));
          } else if (state is SplashNavigateToHome) {
            Navigator.of(context).pushReplacement(
                _fadeRoute(HomePage(uid: state.uid)));
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TypewriterText(text: 'FIRE AUTH'),
              const SizedBox(height: 12),
              _FadeInSubtitle(
                delay: const Duration(milliseconds: 1400),
                child: Text(
                  'Secure · Simple · Swift',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.subtitle,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: _FadeInSubtitle(
          delay: const Duration(milliseconds: 2000),
          child: Text(
            'v1.0.0',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.subtitle.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Fade-in helper ───────────────────────────────────────────────────────────

class _FadeInSubtitle extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _FadeInSubtitle({required this.child, required this.delay});

  @override
  State<_FadeInSubtitle> createState() => _FadeInSubtitleState();
}

class _FadeInSubtitleState extends State<_FadeInSubtitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _opacity, child: widget.child);
}
