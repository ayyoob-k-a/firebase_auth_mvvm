import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_result.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import '../../../domain/usecases/watch_profile_usecase.dart';
import 'home_state.dart';

/// Cubit that watches the Firestore profile stream in real-time.
/// Cancels the subscription automatically when closed.
class HomeCubit extends Cubit<HomeState> {
  final WatchProfileUseCase _watchProfileUseCase;
  final SignOutUseCase _signOutUseCase;
  final String uid;

  StreamSubscription? _profileSub;

  HomeCubit({
    required WatchProfileUseCase watchProfileUseCase,
    required SignOutUseCase signOutUseCase,
    required this.uid,
  })  : _watchProfileUseCase = watchProfileUseCase,
        _signOutUseCase = signOutUseCase,
        super(const HomeLoading()) {
    _startWatching();
  }

  void _startWatching() {
    _profileSub = _watchProfileUseCase(uid).listen(
      (profile) {
        if (profile != null) {
          emit(HomeLoaded(profile));
        } else {
          emit(const HomeError('Profile not found.'));
        }
      },
      onError: (dynamic error) =>
          emit(HomeError(error.toString())),
    );
  }

  Future<AppResult<void>> signOut() => _signOutUseCase();

  @override
  Future<void> close() {
    _profileSub?.cancel();
    return super.close();
  }
}
