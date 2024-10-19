part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;

  ProfileLoaded(this.userData);
}

final class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

final class ProfileSaved extends ProfileState {}

final class ProfileImagePicked extends ProfileState {
  final String imageBase64;

  ProfileImagePicked(this.imageBase64);
}
