import '../../../../core/utils/result.dart';
import '../entities/expense_entity.dart';
import '../entities/expense_filters_entity.dart';
import '../entities/expenses_summary_entity.dart';

abstract class ExpensesRepository {
  Future<Result<List<ExpenseEntity>>> getExpenses({
    ExpenseFiltersEntity? filters,
  });
  Future<Result<ExpenseEntity>> getExpenseById(String id);
  Future<Result<ExpenseEntity>> createExpense(ExpenseEntity expense);
  Future<Result<ExpenseEntity>> updateExpense(ExpenseEntity expense);
  Future<Result<void>> softDeleteExpense(String id);
  Future<Result<ExpensesSummaryEntity>> getExpensesSummary();
}
