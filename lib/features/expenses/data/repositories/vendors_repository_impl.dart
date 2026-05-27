import '../../../../core/utils/result.dart';
import '../../domain/entities/vendor_entity.dart';
import '../../domain/repositories/vendors_repository.dart';
import '../datasources/vendors_remote_data_source.dart';
import '../models/vendor_model.dart';
import 'expense_repository_guard.dart';

class VendorsRepositoryImpl implements VendorsRepository {
  VendorsRepositoryImpl(this._remoteDataSource);

  final VendorsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<VendorEntity>>> getVendors({
    String? search,
    String? status,
  }) {
    return guardExpenseRepositoryCall<List<VendorEntity>>(() async {
      final models = await _remoteDataSource.getVendors(
        search: search,
        status: status,
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<VendorEntity>> createVendor(String name) {
    return guardExpenseRepositoryCall<VendorEntity>(() async {
      return (await _remoteDataSource.createVendor(name)).toEntity();
    });
  }

  @override
  Future<Result<VendorEntity>> getVendorById(String id) {
    return guardExpenseRepositoryCall<VendorEntity>(() async {
      return (await _remoteDataSource.getVendorById(id)).toEntity();
    });
  }

  @override
  Future<Result<VendorEntity>> createVendorRecord(VendorEntity vendor) {
    return guardExpenseRepositoryCall<VendorEntity>(() async {
      return (await _remoteDataSource.createVendorRecord(
        VendorModel.fromEntity(vendor),
      ))
          .toEntity();
    });
  }

  @override
  Future<Result<VendorEntity>> updateVendor(VendorEntity vendor) {
    return guardExpenseRepositoryCall<VendorEntity>(() async {
      return (await _remoteDataSource.updateVendor(
        VendorModel.fromEntity(vendor),
      ))
          .toEntity();
    });
  }

  @override
  Future<Result<void>> deleteVendor(String id) {
    return guardExpenseRepositoryCall<void>(() async {
      await _remoteDataSource.deleteVendor(id);
    });
  }
}
