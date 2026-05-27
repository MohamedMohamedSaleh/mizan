import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import '../../../expenses/domain/repositories/vendors_repository.dart';

class CreateVendorUseCase
    extends UseCase<VendorEntity, CreateVendorParams> {
  CreateVendorUseCase(this._repository);

  final VendorsRepository _repository;

  @override
  Future<Result<VendorEntity>> call(CreateVendorParams params) {
    return _repository.createVendorRecord(params.vendor);
  }
}

class CreateVendorParams extends Equatable {
  const CreateVendorParams({required this.vendor});

  final VendorEntity vendor;

  @override
  List<Object?> get props => [vendor];
}
