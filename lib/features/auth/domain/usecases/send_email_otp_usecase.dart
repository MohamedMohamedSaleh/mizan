import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class SendEmailOtpUseCase extends UseCase<void, SendEmailOtpParams> {
  SendEmailOtpUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<void>> call(SendEmailOtpParams params) {
    return _repository.sendEmailOtp(email: params.email);
  }
}

class SendEmailOtpParams extends Equatable {
  const SendEmailOtpParams({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
