import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/account_entity.dart';
import '../entities/expense_category_entity.dart';
import '../entities/expense_form_lookups_entity.dart';
import '../entities/tax_entity.dart';
import '../entities/vendor_entity.dart';
import '../repositories/accounts_repository.dart';
import '../repositories/expense_categories_repository.dart';
import '../repositories/taxes_repository.dart';
import '../repositories/vendors_repository.dart';
import 'seed_accounting_data_usecase.dart';

class LoadExpenseFormLookupsUseCase
    extends UseCase<ExpenseFormLookupsEntity, NoParams> {
  LoadExpenseFormLookupsUseCase({
    required AccountsRepository accountsRepository,
    required ExpenseCategoriesRepository categoriesRepository,
    required VendorsRepository vendorsRepository,
    required TaxesRepository taxesRepository,
    required SeedAccountingDataUseCase seedAccountingDataUseCase,
  })  : _accountsRepository = accountsRepository,
        _categoriesRepository = categoriesRepository,
        _vendorsRepository = vendorsRepository,
        _taxesRepository = taxesRepository,
        _seedAccountingDataUseCase = seedAccountingDataUseCase;

  final AccountsRepository _accountsRepository;
  final ExpenseCategoriesRepository _categoriesRepository;
  final VendorsRepository _vendorsRepository;
  final TaxesRepository _taxesRepository;
  final SeedAccountingDataUseCase _seedAccountingDataUseCase;

  @override
  Future<Result<ExpenseFormLookupsEntity>> call(NoParams params) async {
    var accountsResult = await _accountsRepository.getAccounts();
    if (accountsResult is Error<List<AccountEntity>>) {
      return Error(accountsResult.failure);
    }
    final accounts = (accountsResult as Success<List<AccountEntity>>).data;
    if (accounts.isEmpty) {
      final seedResult = await _seedAccountingDataUseCase(const NoParams());
      if (seedResult is Error<bool>) return Error(seedResult.failure);

      accountsResult = await _accountsRepository.getAccounts();
      if (accountsResult is Error<List<AccountEntity>>) {
        return Error(accountsResult.failure);
      }
    }

    final paymentAccountsResult = await _accountsRepository.getPaymentAccounts();
    if (paymentAccountsResult is Error<List<AccountEntity>>) {
      return Error(paymentAccountsResult.failure);
    }

    final expenseAccountsResult = await _accountsRepository.getExpenseAccounts();
    if (expenseAccountsResult is Error<List<AccountEntity>>) {
      return Error(expenseAccountsResult.failure);
    }

    final categoriesResult = await _categoriesRepository.getCategories();
    if (categoriesResult is Error<List<ExpenseCategoryEntity>>) {
      return Error(categoriesResult.failure);
    }

    final vendorsResult = await _vendorsRepository.getVendors();
    if (vendorsResult is Error<List<VendorEntity>>) {
      return Error(vendorsResult.failure);
    }

    final taxesResult = await _taxesRepository.getTaxes();
    if (taxesResult is Error<List<TaxEntity>>) {
      return Error(taxesResult.failure);
    }

    return Success(
      ExpenseFormLookupsEntity(
        accounts: (accountsResult as Success<List<AccountEntity>>).data,
        paymentAccounts:
            (paymentAccountsResult as Success<List<AccountEntity>>).data,
        expenseAccounts:
            (expenseAccountsResult as Success<List<AccountEntity>>).data,
        categories:
            (categoriesResult as Success<List<ExpenseCategoryEntity>>).data,
        vendors: (vendorsResult as Success<List<VendorEntity>>).data,
        taxes: (taxesResult as Success<List<TaxEntity>>).data,
      ),
    );
  }
}
