import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../expenses/domain/entities/vendor_entity.dart';
import '../../../expenses/domain/repositories/vendors_repository.dart';

class GetVendorsUseCase
    extends UseCase<List<VendorEntity>, GetVendorsParams> {
  GetVendorsUseCase(this._repository);

  final VendorsRepository _repository;

  @override
  Future<Result<List<VendorEntity>>> call(GetVendorsParams params) {
    return _repository.getVendors(
      search: params.search,
      status: params.status,
    );
  }
}

class GetVendorsParams extends Equatable {
  const GetVendorsParams({
    this.search,
    this.status,
  });

  final String? search;
  final String? status;

  @override
  List<Object?> get props => [search, status];
}
