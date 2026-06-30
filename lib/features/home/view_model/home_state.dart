import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final UserProfileEntity profile;
  const HomeLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
