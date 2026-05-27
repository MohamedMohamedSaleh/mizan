import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import '../../../expenses/domain/repositories/vendors_repository.dart';

class GetVendorByIdUseCase
    extends UseCase<VendorEntity, GetVendorByIdParams> {
  GetVendorByIdUseCase(this._repository);

  final VendorsRepository _repository;

  @override
  Future<Result<VendorEntity>> call(GetVendorByIdParams params) {
    return _repository.getVendorById(params.id);
  }
}

class GetVendorByIdParams extends Equatable {
  const GetVendorByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
