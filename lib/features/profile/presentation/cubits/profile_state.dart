import 'package:socialx/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

//Initial Profile state
class ProfileInitial extends ProfileState {}

//loading state

class ProfileLoading extends ProfileState {}

//loaded state

class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

//error state

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
