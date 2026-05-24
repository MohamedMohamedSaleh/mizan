import '../../../../core/utils/result.dart';
import '../entities/tax_entity.dart';

abstract class TaxesRepository {
  Future<Result<List<TaxEntity>>> getTaxes();
}
