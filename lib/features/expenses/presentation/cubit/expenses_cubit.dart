import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/expense_form_lookups_entity.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/load_expense_form_lookups_usecase.dart';
import '../view_model/expense_filter_view_model.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../view_model/expense_list_item_view_model.dart';
import '../view_model/expenses_summary_view_model.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit({
    required GetExpensesUseCase getExpensesUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
    required LoadExpenseFormLookupsUseCase loadLookupsUseCase,
  })  : _getExpensesUseCase = getExpensesUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        _loadLookupsUseCase = loadLookupsUseCase,
        super(const ExpensesInitial());

  final GetExpensesUseCase _getExpensesUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final LoadExpenseFormLookupsUseCase _loadLookupsUseCase;

  ExpenseFilterViewModel _filters = const ExpenseFilterViewModel();

  Future<void> loadExpenses() => _load(_filters);

  Future<void> refresh() => _load(_filters);

  Future<void> search(String query) {
    _filters = _filters.copyWith(
      search: query.trim().isEmpty ? null : query.trim(),
      clearSearch: query.trim().isEmpty,
    );
    return _load(_filters);
  }

  Future<void> applyFilters({
    ExpenseStatus? status,
    bool clearStatus = false,
    String? categoryId,
    bool clearCategoryId = false,
    String? vendorId,
    bool clearVendorId = false,
    String? paidFromAccountId,
    bool clearPaidFromAccountId = false,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? toDate,
    bool clearToDate = false,
    bool? includeDeleted,
  }) {
    _filters = _filters.copyWith(
      status: status,
      clearStatus: clearStatus,
      categoryId: categoryId,
      clearCategoryId: clearCategoryId,
      vendorId: vendorId,
      clearVendorId: clearVendorId,
      paidFromAccountId: paidFromAccountId,
      clearPaidFromAccountId: clearPaidFromAccountId,
      fromDate: fromDate,
      clearFromDate: clearFromDate,
      toDate: toDate,
      clearToDate: clearToDate,
      includeDeleted: includeDeleted,
    );
    return _load(_filters);
  }

  Future<void> clearFilters() {
    _filters = const ExpenseFilterViewModel();
    return _load(_filters);
  }

  Future<void> deleteExpense(String id) async {
    final result = await _deleteExpenseUseCase(DeleteExpenseParams(id: id));
    result.fold(
      (failure) =>
          emit(ExpensesError(message: failure.message, filters: _filters)),
      (_) => refresh(),
    );
  }

  Future<void> _load(ExpenseFilterViewModel filters) async {
    emit(ExpensesLoading(filters: filters));

    final expensesResult = await _getExpensesUseCase(
      GetExpensesParams(filters: filters.toEntity()),
    );
    if (expensesResult is Error<List<ExpenseEntity>>) {
      emit(ExpensesError(
          message: expensesResult.failure.message, filters: filters));
      return;
    }

    final lookupsResult = await _loadLookupsUseCase(const NoParams());
    if (lookupsResult is Error<ExpenseFormLookupsEntity>) {
      emit(ExpensesError(
          message: lookupsResult.failure.message, filters: filters));
      return;
    }

    final lookups = ExpenseFormLookupsViewModel.fromEntity(
      (lookupsResult as Success<ExpenseFormLookupsEntity>).data,
    );
    final loadedExpenses =
        (expensesResult as Success<List<ExpenseEntity>>).data;
    final expenses =
        loadedExpenses.map(ExpenseListItemViewModel.fromEntity).toList();
    final summary = _summaryFromExpenses(loadedExpenses);

    if (expenses.isEmpty) {
      emit(ExpensesEmpty(summary: summary, filters: filters, lookups: lookups));
      return;
    }

    emit(
      ExpensesLoaded(
        expenses: expenses,
        summary: summary,
        filters: filters,
        lookups: lookups,
      ),
    );
  }

  ExpensesSummaryViewModel _summaryFromExpenses(List<ExpenseEntity> expenses) {
    var totalAmount = 0.0;
    var draftCount = 0;
    var savedCount = 0;
    var voidedCount = 0;

    for (final expense in expenses) {
      totalAmount += expense.amount;
      switch (expense.status) {
        case ExpenseStatus.draft:
          draftCount++;
        case ExpenseStatus.saved:
          savedCount++;
        case ExpenseStatus.voided:
          voidedCount++;
      }
    }

    return ExpensesSummaryViewModel(
      totalAmount: totalAmount,
      expensesCount: expenses.length,
      draftCount: draftCount,
      savedCount: savedCount,
      voidedCount: voidedCount,
    );
  }
}
