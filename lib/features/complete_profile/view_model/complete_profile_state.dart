part of 'complete_profile_bloc.dart';

abstract class CompleteProfileState extends Equatable {
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String nationality;
  final String language;

  const CompleteProfileState({
    this.firstName = '',
    this.lastName = '',
    this.dob = '',
    this.gender = '',
    this.nationality = '',
    this.language = '',
  });

  @override
  List<Object?> get props =>
      [firstName, lastName, dob, gender, nationality, language];
}

class CompleteProfileInitial extends CompleteProfileState {
  const CompleteProfileInitial();
}

class CompleteProfileFormUpdated extends CompleteProfileState {
  const CompleteProfileFormUpdated({
    super.firstName,
    super.lastName,
    super.dob,
    super.gender,
    super.nationality,
    super.language,
  });

  CompleteProfileFormUpdated copyWith({
    String? firstName,
    String? lastName,
    String? dob,
    String? gender,
    String? nationality,
    String? language,
  }) =>
      CompleteProfileFormUpdated(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dob: dob ?? this.dob,
        gender: gender ?? this.gender,
        nationality: nationality ?? this.nationality,
        language: language ?? this.language,
      );
}

class CompleteProfileLoading extends CompleteProfileState {
  const CompleteProfileLoading({
    required super.firstName,
    required super.lastName,
    required super.dob,
    required super.gender,
    required super.nationality,
    required super.language,
  });
}

class CompleteProfileSuccess extends CompleteProfileState {
  final UserProfileEntity profile;

  const CompleteProfileSuccess({
    required this.profile,
    required super.firstName,
    required super.lastName,
    required super.dob,
    required super.gender,
    required super.nationality,
    required super.language,
  });

  @override
  List<Object?> get props => [...super.props, profile];
}

class CompleteProfileFailure extends CompleteProfileState {
  final String errorMessage;

  const CompleteProfileFailure({
    required this.errorMessage,
    required super.firstName,
    required super.lastName,
    required super.dob,
    required super.gender,
    required super.nationality,
    required super.language,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
