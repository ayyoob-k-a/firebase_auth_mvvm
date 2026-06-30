import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_result.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../../domain/usecases/save_profile_usecase.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

/// ViewModel for the Complete Profile screen.
///
/// Receives [UserEntity] (uid + email from Firebase Auth) and
/// [SaveProfileUseCase] from the data layer.
/// Validates every field before saving to Firestore.
class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final SaveProfileUseCase _saveProfileUseCase;
  final UserEntity _user;

  CompleteProfileBloc({
    required SaveProfileUseCase saveProfileUseCase,
    required UserEntity user,
  })  : _saveProfileUseCase = saveProfileUseCase,
        _user = user,
        super(const CompleteProfileInitial()) {
    on<ProfileFirstNameChanged>(_onFirstNameChanged);
    on<ProfileLastNameChanged>(_onLastNameChanged);
    on<ProfileDobChanged>(_onDobChanged);
    on<ProfileGenderChanged>(_onGenderChanged);
    on<ProfileNationalityChanged>(_onNationalityChanged);
    on<ProfileLanguageChanged>(_onLanguageChanged);
    on<ProfileSubmitted>(_onSubmitted);
  }

  // ── Form field helpers ────────────────────────────────────────────────────

  CompleteProfileFormUpdated get _form => state is CompleteProfileFormUpdated
      ? state as CompleteProfileFormUpdated
      : CompleteProfileFormUpdated(
          firstName: state.firstName,
          lastName: state.lastName,
          dob: state.dob,
          gender: state.gender,
          nationality: state.nationality,
          language: state.language,
        );

  void _onFirstNameChanged(
          ProfileFirstNameChanged event, Emitter<CompleteProfileState> emit) =>
      emit(_form.copyWith(firstName: event.value));

  void _onLastNameChanged(
          ProfileLastNameChanged event, Emitter<CompleteProfileState> emit) =>
      emit(_form.copyWith(lastName: event.value));

  void _onDobChanged(
          ProfileDobChanged event, Emitter<CompleteProfileState> emit) =>
      emit(_form.copyWith(dob: event.value));

  void _onGenderChanged(
          ProfileGenderChanged event, Emitter<CompleteProfileState> emit) =>
      emit(_form.copyWith(gender: event.value));

  void _onNationalityChanged(
          ProfileNationalityChanged event, Emitter<CompleteProfileState> emit) =>
      emit(_form.copyWith(nationality: event.value));

  void _onLanguageChanged(
          ProfileLanguageChanged event, Emitter<CompleteProfileState> emit) =>
      emit(_form.copyWith(language: event.value));

  // ── Submission ────────────────────────────────────────────────────────────

  Future<void> _onSubmitted(
    ProfileSubmitted event,
    Emitter<CompleteProfileState> emit,
  ) async {
    final s = _form;
    final String? error = _validate(s);

    if (error != null) {
      emit(CompleteProfileFailure(
        errorMessage: error,
        firstName: s.firstName,
        lastName: s.lastName,
        dob: s.dob,
        gender: s.gender,
        nationality: s.nationality,
        language: s.language,
      ));
      return;
    }

    emit(CompleteProfileLoading(
      firstName: s.firstName,
      lastName: s.lastName,
      dob: s.dob,
      gender: s.gender,
      nationality: s.nationality,
      language: s.language,
    ));

    final profile = UserProfileEntity(
      uid: _user.uid,
      email: _user.email,
      firstName: s.firstName.trim(),
      lastName: s.lastName.trim(),
      dob: s.dob,
      gender: s.gender,
      nationality: s.nationality,
      language: s.language,
      profileCompleted: true,
    );

    final result = await _saveProfileUseCase(profile);

    switch (result) {
      case AppSuccess():
        emit(CompleteProfileSuccess(
          profile: profile,
          firstName: profile.firstName,
          lastName: profile.lastName,
          dob: profile.dob,
          gender: profile.gender,
          nationality: profile.nationality,
          language: profile.language,
        ));
      case AppFailure(:final message):
        emit(CompleteProfileFailure(
          errorMessage: message,
          firstName: s.firstName,
          lastName: s.lastName,
          dob: s.dob,
          gender: s.gender,
          nationality: s.nationality,
          language: s.language,
        ));
    }
  }

  String? _validate(CompleteProfileFormUpdated s) {
    if (s.firstName.trim().isEmpty) return 'First name is required.';
    if (s.lastName.trim().isEmpty) return 'Last name is required.';
    if (s.dob.isEmpty) return 'Date of birth is required.';
    if (s.gender.isEmpty) return 'Please select your gender.';
    if (s.nationality.isEmpty) return 'Please select your nationality.';
    if (s.language.isEmpty) return 'Please select your language.';
    return null;
  }
}
