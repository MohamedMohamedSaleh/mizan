import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      businessName: params.businessName,
      phoneNumber: params.phoneNumber,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.businessName,
    required this.phoneNumber,
  });

  final String email;
  final String password;
  final String fullName;
  final String businessName;
  final String phoneNumber;

  @override
  List<Object?> get props => [email, password, fullName, businessName, phoneNumber];
}
