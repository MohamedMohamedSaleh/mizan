import '../../../../core/utils/result.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/accounts_repository.dart';
import '../datasources/accounts_remote_data_source.dart';
import 'expense_repository_guard.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  AccountsRepositoryImpl(this._remoteDataSource);

  final AccountsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<AccountEntity>>> getAccounts() {
    return guardExpenseRepositoryCall<List<AccountEntity>>(() async {
      final models = await _remoteDataSource.getAccounts();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<AccountEntity>>> getPaymentAccounts() {
    return guardExpenseRepositoryCall<List<AccountEntity>>(() async {
      final models = await _remoteDataSource.getPaymentAccounts();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<AccountEntity>>> getExpenseAccounts() {
    return guardExpenseRepositoryCall<List<AccountEntity>>(() async {
      final models = await _remoteDataSource.getExpenseAccounts();
      return models.map((model) => model.toEntity()).toList();
    });
  }
}
