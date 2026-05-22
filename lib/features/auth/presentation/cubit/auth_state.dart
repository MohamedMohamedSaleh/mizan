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
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An auth operation failed.
class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Password reset email was sent successfully.
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}
