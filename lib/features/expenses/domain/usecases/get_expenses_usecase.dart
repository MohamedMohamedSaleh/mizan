import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/expense_entity.dart';
import '../entities/expense_filters_entity.dart';
import '../repositories/expenses_repository.dart';

class GetExpensesUseCase
    extends UseCase<List<ExpenseEntity>, GetExpensesParams> {
  GetExpensesUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Result<List<ExpenseEntity>>> call(GetExpensesParams params) {
    return _repository.getExpenses(filters: params.filters);
  }
}

class GetExpensesParams extends Equatable {
  const GetExpensesParams({this.filters});

  final ExpenseFiltersEntity? filters;

  @override
  List<Object?> get props => [filters];
}
