import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// All possible states for the auth feature.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — haven't checked auth yet.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Checking if the user is already logged in.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated.
class Authenticated extends AuthState {
  const Authenticated(this.user);
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// An auth operation failed.
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Register operation succeeded and a session is active.
class RegisterSuccess extends AuthState {
  const RegisterSuccess(this.user);
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Register succeeded but user must confirm email before login/session.
class EmailConfirmationRequired extends AuthState {
  const EmailConfirmationRequired({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Password reset email was sent successfully.
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

class OtpInitial extends AuthState {
  const OtpInitial();
}

class SendingOtp extends AuthState {
  const SendingOtp();
}

class OtpSent extends AuthState {
  const OtpSent({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

class VerifyingOtp extends AuthState {
  const VerifyingOtp({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

class RegisterOtpPayload extends Equatable {
  const RegisterOtpPayload({
    required this.email,
    required this.fullName,
    required this.phone,
    required this.companyName,
    required this.jobTitle,
    required this.country,
    required this.city,
  });

  final String email;
  final String fullName;
  final String phone;
  final String companyName;
  final String jobTitle;
  final String country;
  final String city;

  @override
  List<Object?> get props => [
        email,
        fullName,
        phone,
        companyName,
        jobTitle,
        country,
        city,
      ];
}

class RegisterLoading extends AuthState {
  const RegisterLoading();
}

class RegisterOtpRequired extends AuthState {
  const RegisterOtpRequired(this.payload);
  final RegisterOtpPayload payload;

  @override
  List<Object?> get props => [payload];
}

class RegisterOtpVerifying extends AuthState {
  const RegisterOtpVerifying();
}

class RegisterFailure extends AuthState {
  const RegisterFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ResendOtpLoading extends AuthState {
  const ResendOtpLoading();
}

class ResendOtpSuccess extends AuthState {
  const ResendOtpSuccess();
}

typedef AuthAuthenticated = Authenticated;
typedef AuthUnauthenticated = Unauthenticated;
