import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onlinestore/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authServices = AuthServicesImpl();

  Future<void> authStatus() async {
    final user = authServices.currentUser;
    if (user != null) {
      final isVerified = await authServices.isEmailVerified();
      if (isVerified) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailed('Email not verified. Please check your inbox.'));
      }
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authServices.loginWithEmailAndPassword(email, password);
      if (user != null) {
        final isVerified = await authServices.isEmailVerified();
        if (isVerified) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailed('Email not verified. Please check your inbox.'));
        }
      } else {
        emit(AuthFailed('Login failed: Unknown error.'));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authServices.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        emit(AuthEmailVerificationSent());
      } else {
        emit(AuthFailed('Registration failed: Unknown error.'));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await authServices.resetPassword(email);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authServices.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await authServices.loginWithGoogle();
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailed('Google login failed.'));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void togglePasswordVisibility() {
    if (state is PasswordVisibilityChanged) {
      emit(PasswordVisibilityChanged(false));
    } else {
      emit(PasswordVisibilityChanged(true));
    }
  }
}
