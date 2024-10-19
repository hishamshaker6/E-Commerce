part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({this.message = 'Success'});
}

class AuthFailed extends AuthState {
  final String error;

  AuthFailed(this.error);
}

class ResetPasswordSuccess extends AuthState {}

class PasswordVisibilityChanged extends AuthState {
  final bool isVisible;

  PasswordVisibilityChanged(this.isVisible);
}

class AuthLogout extends AuthState {}

class AuthEmailVerificationSent extends AuthState {
  final String message;

  AuthEmailVerificationSent({this.message = 'Verification email sent'});
}
