import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../expenses/domain/repositories/vendors_repository.dart';

class DeleteVendorUseCase extends UseCase<void, DeleteVendorParams> {
  DeleteVendorUseCase(this._repository);

  final VendorsRepository _repository;

  @override
  Future<Result<void>> call(DeleteVendorParams params) {
    return _repository.deleteVendor(params.id);
  }
}

class DeleteVendorParams extends Equatable {
  const DeleteVendorParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
