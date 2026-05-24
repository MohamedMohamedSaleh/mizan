import '../../../../core/utils/result.dart';
import '../entities/expense_category_entity.dart';

abstract class ExpenseCategoriesRepository {
  Future<Result<List<ExpenseCategoryEntity>>> getCategories();
  Future<Result<ExpenseCategoryEntity>> createCategory(
    String name,
    String expenseAccountId,
  );
}
