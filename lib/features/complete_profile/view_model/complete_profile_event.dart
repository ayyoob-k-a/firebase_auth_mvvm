part of 'complete_profile_bloc.dart';

abstract class CompleteProfileEvent extends Equatable {
  const CompleteProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileFirstNameChanged extends CompleteProfileEvent {
  final String value;
  const ProfileFirstNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ProfileLastNameChanged extends CompleteProfileEvent {
  final String value;
  const ProfileLastNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ProfileDobChanged extends CompleteProfileEvent {
  final String value; // dd-MM-yyyy
  const ProfileDobChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ProfileGenderChanged extends CompleteProfileEvent {
  final String value;
  const ProfileGenderChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ProfileNationalityChanged extends CompleteProfileEvent {
  final String value;
  const ProfileNationalityChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ProfileLanguageChanged extends CompleteProfileEvent {
  final String value;
  const ProfileLanguageChanged(this.value);
  @override
  List<Object?> get props => [value];
}

/// User tapped the Save / Continue button.
class ProfileSubmitted extends CompleteProfileEvent {
  const ProfileSubmitted();
}
