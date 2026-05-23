import 'package:equatable/equatable.dart';

import 'user_entity.dart';

/// Result of a register operation.
///
/// When email confirmation is enabled in Supabase Auth, a user may be created
/// without an active session. In that case [requiresEmailConfirmation] is true.
class RegisterResultEntity extends Equatable {
  const RegisterResultEntity({
    required this.user,
    required this.hasActiveSession,
    required this.requiresEmailConfirmation,
  });

  final UserEntity user;
  final bool hasActiveSession;
  final bool requiresEmailConfirmation;

  @override
  List<Object?> get props => [user, hasActiveSession, requiresEmailConfirmation];
}
