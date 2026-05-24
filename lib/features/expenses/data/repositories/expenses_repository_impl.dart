import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_filters_entity.dart';
import '../../domain/entities/expenses_summary_entity.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../../../../core/utils/result.dart';
import '../datasources/expenses_remote_data_source.dart';
import '../models/expense_filters_model.dart';
import '../models/expense_model.dart';
import 'expense_repository_guard.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl(this._remoteDataSource);

  final ExpensesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<ExpenseEntity>>> getExpenses({
    ExpenseFiltersEntity? filters,
  }) {
    return guardExpenseRepositoryCall<List<ExpenseEntity>>(() async {
      final models = await _remoteDataSource.getExpenses(
        filters: filters == null ? null : ExpenseFiltersModel.fromEntity(filters),
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<ExpenseEntity>> getExpenseById(String id) {
    return guardExpenseRepositoryCall<ExpenseEntity>(() async {
      return (await _remoteDataSource.getExpenseById(id)).toEntity();
    });
  }

  @override
  Future<Result<ExpenseEntity>> createExpense(ExpenseEntity expense) {
    return guardExpenseRepositoryCall<ExpenseEntity>(() async {
      return (await _remoteDataSource.createExpense(
        ExpenseModel.fromEntity(expense),
      ))
          .toEntity();
    });
  }

  @override
  Future<Result<ExpenseEntity>> updateExpense(ExpenseEntity expense) {
    return guardExpenseRepositoryCall<ExpenseEntity>(() async {
      return (await _remoteDataSource.updateExpense(
        ExpenseModel.fromEntity(expense),
      ))
          .toEntity();
    });
  }

  @override
  Future<Result<void>> softDeleteExpense(String id) {
    return guardExpenseRepositoryCall<void>(
      () => _remoteDataSource.softDeleteExpense(id),
    );
  }

  @override
  Future<Result<ExpensesSummaryEntity>> getExpensesSummary() {
    return guardExpenseRepositoryCall<ExpensesSummaryEntity>(() async {
      return (await _remoteDataSource.getExpensesSummary()).toEntity();
    });
  }
}
