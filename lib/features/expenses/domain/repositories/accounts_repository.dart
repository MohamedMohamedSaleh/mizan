import '../../../../core/utils/result.dart';
import '../entities/account_entity.dart';

abstract class AccountsRepository {
  Future<Result<List<AccountEntity>>> getAccounts();
  Future<Result<List<AccountEntity>>> getPaymentAccounts();
  Future<Result<List<AccountEntity>>> getExpenseAccounts();
}
