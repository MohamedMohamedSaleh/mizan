import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_email_otp_usecase.dart';
import '../../domain/usecases/verify_email_otp_usecase.dart';
import 'auth_state.dart';

/// Manages authentication state across the app.
///
/// Injected via get_it and provided at the root of the widget tree
/// so that [GoRouter] redirect logic can read the current state.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required SendEmailOtpUseCase sendEmailOtpUseCase,
    required VerifyEmailOtpUseCase verifyEmailOtpUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _sendEmailOtpUseCase = sendEmailOtpUseCase,
        _verifyEmailOtpUseCase = verifyEmailOtpUseCase,
        super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final SendEmailOtpUseCase _sendEmailOtpUseCase;
  final VerifyEmailOtpUseCase _verifyEmailOtpUseCase;

  /// Check if a user session already exists.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  /// Sign in with email + password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  /// Create a new account.
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String companyName,
    required String jobTitle,
    required String country,
    required String city,
  }) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        companyName: companyName,
        jobTitle: jobTitle,
        country: country,
        city: city,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (registerResult) {
        if (registerResult.requiresEmailConfirmation) {
          emit(
            const EmailConfirmationRequired(
              message: 'Please check your email to confirm your account.',
            ),
          );
          emit(const Unauthenticated());
          return;
        }

        emit(RegisterSuccess(registerResult.user));
        emit(Authenticated(registerResult.user));
      },
    );
  }

  /// Sign out.
  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  /// Send password reset email.
  Future<void> forgotPassword({required String email}) async {
    emit(const AuthLoading());
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: email),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthPasswordResetSent()),
    );
  }

  Future<void> sendEmailOtp({required String email}) async {
    emit(const SendingOtp());
    final result = await _sendEmailOtpUseCase(
      SendEmailOtpParams(email: email),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OtpSent(email: email)),
    );
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    emit(VerifyingOtp(email: email));
    final result = await _verifyEmailOtpUseCase(
      VerifyEmailOtpParams(email: email, otp: otp),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }
}
