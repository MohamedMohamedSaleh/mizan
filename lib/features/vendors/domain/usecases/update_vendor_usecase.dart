import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import '../../../expenses/domain/repositories/vendors_repository.dart';

class UpdateVendorUseCase
    extends UseCase<VendorEntity, UpdateVendorParams> {
  UpdateVendorUseCase(this._repository);

  final VendorsRepository _repository;

  @override
  Future<Result<VendorEntity>> call(UpdateVendorParams params) {
    return _repository.updateVendor(params.vendor);
  }
}

class UpdateVendorParams extends Equatable {
  const UpdateVendorParams({required this.vendor});

  final VendorEntity vendor;

  @override
  List<Object?> get props => [vendor];
}
