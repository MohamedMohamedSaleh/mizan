import '../../../../core/utils/result.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/repositories/vendors_repository.dart';
import '../datasources/vendors_remote_data_source.dart';
import 'expense_repository_guard.dart';

class VendorsRepositoryImpl implements VendorsRepository {
  VendorsRepositoryImpl(this._remoteDataSource);

  final VendorsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<VendorEntity>>> getVendors() {
    return guardExpenseRepositoryCall<List<VendorEntity>>(() async {
      final models = await _remoteDataSource.getVendors();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<VendorEntity>> createVendor(String name) {
    return guardExpenseRepositoryCall<VendorEntity>(() async {
      return (await _remoteDataSource.createVendor(name)).toEntity();
    });
  }
}
