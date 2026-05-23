import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class UpsertProfileUseCase extends UseCase<void, UpsertProfileParams> {
  UpsertProfileUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<void>> call(UpsertProfileParams params) {
    return _repository.upsertProfile(
      userId: params.userId,
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      companyName: params.companyName,
      jobTitle: params.jobTitle,
      country: params.country,
      city: params.city,
    );
  }
}

class UpsertProfileParams extends Equatable {
  const UpsertProfileParams({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.companyName,
    required this.jobTitle,
    required this.country,
    required this.city,
  });

  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String companyName;
  final String jobTitle;
  final String country;
  final String city;

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        phone,
        companyName,
        jobTitle,
        country,
        city,
      ];
}
