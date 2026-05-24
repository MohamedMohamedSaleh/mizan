import '../../../../core/utils/result.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/repositories/expense_categories_repository.dart';
import '../datasources/expense_categories_remote_data_source.dart';
import 'expense_repository_guard.dart';

class ExpenseCategoriesRepositoryImpl implements ExpenseCategoriesRepository {
  ExpenseCategoriesRepositoryImpl(this._remoteDataSource);

  final ExpenseCategoriesRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<ExpenseCategoryEntity>>> getCategories() {
    return guardExpenseRepositoryCall<List<ExpenseCategoryEntity>>(() async {
      final models = await _remoteDataSource.getCategories();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<ExpenseCategoryEntity>> createCategory(
    String name,
    String expenseAccountId,
  ) {
    return guardExpenseRepositoryCall<ExpenseCategoryEntity>(() async {
      return (await _remoteDataSource.createCategory(name, expenseAccountId))
          .toEntity();
    });
  }
}
