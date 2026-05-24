import '../../../../core/utils/result.dart';
import '../entities/vendor_entity.dart';

abstract class VendorsRepository {
  Future<Result<List<VendorEntity>>> getVendors();
  Future<Result<VendorEntity>> createVendor(String name);
}
