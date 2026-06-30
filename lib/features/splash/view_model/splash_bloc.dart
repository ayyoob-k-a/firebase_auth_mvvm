import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_result.dart';
import '../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../data/datasources/profile/profile_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_profile_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

/// ViewModel for the Splash screen.
///
/// Runs the typewriter animation and auth check in parallel.
/// Emits the correct navigation state once both complete.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// Minimum time to show the splash (covers the typewriter animation).
  static const Duration _minSplashDuration = Duration(milliseconds: 3200);

  SplashBloc() : super(const SplashAnimating()) {
    on<SplashStarted>(_onSplashStarted);
  }

  static GetProfileUseCase _buildGetProfileUseCase() {
    final profileDataSource = ProfileRemoteDataSourceImpl();
    final profileRepository = ProfileRepositoryImpl(profileDataSource);
    return GetProfileUseCase(profileRepository);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    // Run animation delay and auth check concurrently.
    final results = await Future.wait([
      Future<void>.delayed(_minSplashDuration),
      _determineDestination(),
    ]);

    emit(results[1] as SplashState);
  }

  /// Checks Firebase auth state + Firestore profile.
  Future<SplashState> _determineDestination() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) return const SplashNavigateToLogin();

      final user = UserEntity(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
      );

      // Check if profile is complete in Firestore.
      final getProfile = _buildGetProfileUseCase();
      final profileResult = await getProfile(user.uid);

      if (profileResult is AppSuccess) {
        final profile =
            (profileResult as AppSuccess).data;
        if (profile != null && profile.profileCompleted) {
          return SplashNavigateToHome(user.uid);
        }
      }
      return SplashNavigateToCompleteProfile(user);
    } catch (_) {
      return const SplashNavigateToLogin();
    }
  }
}
