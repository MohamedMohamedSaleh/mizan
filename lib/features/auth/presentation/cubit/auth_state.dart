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

typedef AuthAuthenticated = Authenticated;
typedef AuthUnauthenticated = Unauthenticated;
