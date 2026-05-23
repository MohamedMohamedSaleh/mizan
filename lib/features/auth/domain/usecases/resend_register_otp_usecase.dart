import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ResendRegisterOtpUseCase extends UseCase<void, ResendRegisterOtpParams> {
  ResendRegisterOtpUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<void>> call(ResendRegisterOtpParams params) {
    return _repository.resendRegisterOtp(email: params.email);
  }
}

class ResendRegisterOtpParams extends Equatable {
  const ResendRegisterOtpParams({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
