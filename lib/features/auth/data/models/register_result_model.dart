import '../../domain/entities/register_result_entity.dart';
import 'user_model.dart';

class RegisterResultModel {
  const RegisterResultModel({
    required this.user,
    required this.hasActiveSession,
    required this.requiresEmailConfirmation,
  });

  final UserModel user;
  final bool hasActiveSession;
  final bool requiresEmailConfirmation;

  RegisterResultEntity toEntity() {
    return RegisterResultEntity(
      user: user.toEntity(),
      hasActiveSession: hasActiveSession,
      requiresEmailConfirmation: requiresEmailConfirmation,
    );
  }
}
