import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyRegisterOtpUseCase
    extends UseCase<UserEntity, VerifyRegisterOtpParams> {
  VerifyRegisterOtpUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(VerifyRegisterOtpParams params) {
    return _repository.verifyRegisterOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyRegisterOtpParams extends Equatable {
  const VerifyRegisterOtpParams({
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}
