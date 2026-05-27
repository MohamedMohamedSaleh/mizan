import '../../../../core/utils/result.dart';
import '../entities/vendor_entity.dart';

abstract class VendorsRepository {
  Future<Result<List<VendorEntity>>> getVendors({
    String? search,
    String? status,
  });
  Future<Result<VendorEntity>> createVendor(String name);
  Future<Result<VendorEntity>> getVendorById(String id);
  Future<Result<VendorEntity>> createVendorRecord(VendorEntity vendor);
  Future<Result<VendorEntity>> updateVendor(VendorEntity vendor);
  Future<Result<void>> deleteVendor(String id);
}
