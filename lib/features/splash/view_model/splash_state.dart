part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

/// Typewriter animation is still running.
class SplashAnimating extends SplashState {
  const SplashAnimating();
}

/// User is not logged in — go to Login.
class SplashNavigateToLogin extends SplashState {
  const SplashNavigateToLogin();
}

/// User is logged in but profile is incomplete — go to Complete Profile.
class SplashNavigateToCompleteProfile extends SplashState {
  final UserEntity user;
  const SplashNavigateToCompleteProfile(this.user);

  @override
  List<Object?> get props => [user];
}

/// User is logged in AND profile is complete — go to Home.
class SplashNavigateToHome extends SplashState {
  final String uid;
  const SplashNavigateToHome(this.uid);

  @override
  List<Object?> get props => [uid];
}
