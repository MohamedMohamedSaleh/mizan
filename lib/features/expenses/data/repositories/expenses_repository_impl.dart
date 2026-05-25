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
  final Map<String, ExpenseEntity> _expenseCacheById = {};

  @override
  Future<Result<List<ExpenseEntity>>> getExpenses({
    ExpenseFiltersEntity? filters,
  }) {
    return guardExpenseRepositoryCall<List<ExpenseEntity>>(() async {
      final models = await _remoteDataSource.getExpenses(
        filters:
            filters == null ? null : ExpenseFiltersModel.fromEntity(filters),
      );
      final expenses = models.map((model) => model.toEntity()).toList();
      for (final expense in expenses) {
        _expenseCacheById[expense.id] = expense;
      }
      return expenses;
    });
  }

  @override
  Future<Result<ExpenseEntity>> getExpenseById(String id) {
    final cachedExpense = _expenseCacheById[id];
    if (cachedExpense != null) return Future.value(Success(cachedExpense));

    return guardExpenseRepositoryCall<ExpenseEntity>(() async {
      final expense = (await _remoteDataSource.getExpenseById(id)).toEntity();
      _expenseCacheById[expense.id] = expense;
      return expense;
    });
  }

  @override
  Future<Result<ExpenseEntity>> createExpense(ExpenseEntity expense) {
    return guardExpenseRepositoryCall<ExpenseEntity>(() async {
      final createdExpense = (await _remoteDataSource.createExpense(
        ExpenseModel.fromEntity(expense),
      ))
          .toEntity();
      _expenseCacheById[createdExpense.id] = createdExpense;
      return createdExpense;
    });
  }

  @override
  Future<Result<ExpenseEntity>> updateExpense(ExpenseEntity expense) {
    return guardExpenseRepositoryCall<ExpenseEntity>(() async {
      final updatedExpense = (await _remoteDataSource.updateExpense(
        ExpenseModel.fromEntity(expense),
      ))
          .toEntity();
      _expenseCacheById[updatedExpense.id] = updatedExpense;
      return updatedExpense;
    });
  }

  @override
  Future<Result<void>> softDeleteExpense(String id) {
    return guardExpenseRepositoryCall<void>(
      () async {
        await _remoteDataSource.softDeleteExpense(id);
        _expenseCacheById.remove(id);
      },
    );
  }

  @override
  Future<Result<ExpensesSummaryEntity>> getExpensesSummary() {
    return guardExpenseRepositoryCall<ExpensesSummaryEntity>(() async {
      return (await _remoteDataSource.getExpensesSummary()).toEntity();
    });
  }
}
