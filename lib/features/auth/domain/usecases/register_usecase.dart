import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/register_result_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<RegisterResultEntity, RegisterParams> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<RegisterResultEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      companyName: params.companyName,
      jobTitle: params.jobTitle,
      country: params.country,
      city: params.city,
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.companyName,
    required this.jobTitle,
    required this.country,
    required this.city,
  });

  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final String companyName;
  final String jobTitle;
  final String country;
  final String city;

  @override
  List<Object?> get props => [
        email,
        password,
        fullName,
        phoneNumber,
        companyName,
        jobTitle,
        country,
        city,
      ];
}
