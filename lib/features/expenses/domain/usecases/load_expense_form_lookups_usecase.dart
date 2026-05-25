import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/account_entity.dart';
import '../entities/expense_category_entity.dart';
import '../entities/expense_form_lookups_entity.dart';
import '../entities/expense_enums.dart';
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

  Result<ExpenseFormLookupsEntity>? _cachedResult;
  Future<Result<ExpenseFormLookupsEntity>>? _inFlightRequest;

  void invalidateCache() {
    _cachedResult = null;
    _inFlightRequest = null;
  }

  @override
  Future<Result<ExpenseFormLookupsEntity>> call(NoParams params) async {
    final cachedResult = _cachedResult;
    if (cachedResult != null) return cachedResult;

    final inFlightRequest = _inFlightRequest;
    if (inFlightRequest != null) return inFlightRequest;

    final request = _loadLookups();
    _inFlightRequest = request;
    final result = await request;
    _inFlightRequest = null;
    if (result is Success<ExpenseFormLookupsEntity>) {
      _cachedResult = result;
    }
    return result;
  }

  Future<Result<ExpenseFormLookupsEntity>> _loadLookups() async {
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

    final accountsAfterSeed =
        (accountsResult as Success<List<AccountEntity>>).data;
    final categoriesFuture = _categoriesRepository.getCategories();
    final vendorsFuture = _vendorsRepository.getVendors();
    final taxesFuture = _taxesRepository.getTaxes();

    final categoriesResult = await categoriesFuture;
    if (categoriesResult is Error<List<ExpenseCategoryEntity>>) {
      return Error(categoriesResult.failure);
    }

    final vendorsResult = await vendorsFuture;
    if (vendorsResult is Error<List<VendorEntity>>) {
      return Error(vendorsResult.failure);
    }

    final taxesResult = await taxesFuture;
    if (taxesResult is Error<List<TaxEntity>>) {
      return Error(taxesResult.failure);
    }

    return Success(
      ExpenseFormLookupsEntity(
        accounts: accountsAfterSeed,
        paymentAccounts: accountsAfterSeed
            .where((account) => account.isPaymentAccount && account.isActive)
            .toList(),
        expenseAccounts: accountsAfterSeed
            .where((account) =>
                account.type == AccountType.expense && account.isActive)
            .toList(),
        categories:
            (categoriesResult as Success<List<ExpenseCategoryEntity>>).data,
        vendors: (vendorsResult as Success<List<VendorEntity>>).data,
        taxes: (taxesResult as Success<List<TaxEntity>>).data,
      ),
    );
  }
}
