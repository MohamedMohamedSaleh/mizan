import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expense_details_usecase.dart';
import '../../domain/usecases/load_expense_form_lookups_usecase.dart';
import '../view_model/expense_details_view_model.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import 'expense_details_state.dart';

class ExpenseDetailsCubit extends Cubit<ExpenseDetailsState> {
  ExpenseDetailsCubit({
    required GetExpenseDetailsUseCase getExpenseDetailsUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
    required LoadExpenseFormLookupsUseCase loadLookupsUseCase,
  })  : _getExpenseDetailsUseCase = getExpenseDetailsUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        _loadLookupsUseCase = loadLookupsUseCase,
        super(const ExpenseDetailsInitial());

  final GetExpenseDetailsUseCase _getExpenseDetailsUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final LoadExpenseFormLookupsUseCase _loadLookupsUseCase;

  String? _currentExpenseId;

  Future<void> loadExpense(String id) async {
    _currentExpenseId = id;
    emit(const ExpenseDetailsLoading());

    final lookupsResult = await _loadLookupsUseCase(const NoParams());
    final result = await _getExpenseDetailsUseCase(
      GetExpenseDetailsParams(id: id),
    );
    lookupsResult.fold(
      (failure) => emit(ExpenseDetailsError(failure.message)),
      (lookups) => result.fold(
      (failure) => emit(ExpenseDetailsError(failure.message)),
      (expense) => emit(
        ExpenseDetailsLoaded(
          expense: ExpenseDetailsViewModel.fromEntity(expense),
          lookups: ExpenseFormLookupsViewModel.fromEntity(lookups),
        ),
      ),
      ),
    );
  }

  Future<void> deleteExpense() async {
    final id = _currentExpenseId;
    if (id == null) return;

    final result = await _deleteExpenseUseCase(DeleteExpenseParams(id: id));
    result.fold(
      (failure) => emit(ExpenseDetailsError(failure.message)),
      (_) => emit(const ExpenseDetailsDeleted()),
    );
  }

  Future<void> voidExpense() => deleteExpense();
}
