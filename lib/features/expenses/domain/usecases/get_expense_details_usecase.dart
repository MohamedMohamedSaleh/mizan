import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/expense_entity.dart';
import '../repositories/expenses_repository.dart';

class GetExpenseDetailsUseCase
    extends UseCase<ExpenseEntity, GetExpenseDetailsParams> {
  GetExpenseDetailsUseCase(this._repository);

  final ExpensesRepository _repository;

  @override
  Future<Result<ExpenseEntity>> call(GetExpenseDetailsParams params) {
    return _repository.getExpenseById(params.id);
  }
}

class GetExpenseDetailsParams extends Equatable {
  const GetExpenseDetailsParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
