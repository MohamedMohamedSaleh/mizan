import '../../../../core/utils/result.dart';
import '../../domain/entities/tax_entity.dart';
import '../../domain/repositories/taxes_repository.dart';
import '../datasources/taxes_remote_data_source.dart';
import 'expense_repository_guard.dart';

class TaxesRepositoryImpl implements TaxesRepository {
  TaxesRepositoryImpl(this._remoteDataSource);

  final TaxesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<TaxEntity>>> getTaxes() {
    return guardExpenseRepositoryCall<List<TaxEntity>>(() async {
      final models = await _remoteDataSource.getTaxes();
      return models.map((model) => model.toEntity()).toList();
    });
  }
}
