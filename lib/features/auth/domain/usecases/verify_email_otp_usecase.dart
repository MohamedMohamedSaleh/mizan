import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailOtpUseCase extends UseCase<UserEntity, VerifyEmailOtpParams> {
  VerifyEmailOtpUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(VerifyEmailOtpParams params) {
    return _repository.verifyEmailOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyEmailOtpParams extends Equatable {
  const VerifyEmailOtpParams({
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}
