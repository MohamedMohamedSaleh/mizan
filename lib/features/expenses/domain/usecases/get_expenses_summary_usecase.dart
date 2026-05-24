import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/expenses_summary_entity.dart';
import '../repositories/expenses_repository.dart';

class GetExpensesSummaryUseCase
    extends UseCase<ExpensesSummaryEntity, NoParams> {
  GetExpensesSummaryUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Result<ExpensesSummaryEntity>> call(NoParams params) {
    return _repository.getExpensesSummary();
  }
}
