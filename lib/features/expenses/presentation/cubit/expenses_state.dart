import 'package:equatable/equatable.dart';

import '../view_model/expense_filter_view_model.dart';
import '../view_model/expense_form_lookups_view_model.dart';
import '../view_model/expense_list_item_view_model.dart';
import '../view_model/expenses_summary_view_model.dart';

sealed class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object?> get props => [];
}

class ExpensesInitial extends ExpensesState {
  const ExpensesInitial();
}

class ExpensesLoading extends ExpensesState {
  const ExpensesLoading({required this.filters});

  final ExpenseFilterViewModel filters;

  @override
  List<Object?> get props => [filters];
}

class ExpensesLoaded extends ExpensesState {
  const ExpensesLoaded({
    required this.expenses,
    required this.summary,
    required this.filters,
    required this.lookups,
  });

  final List<ExpenseListItemViewModel> expenses;
  final ExpensesSummaryViewModel summary;
  final ExpenseFilterViewModel filters;
  final ExpenseFormLookupsViewModel lookups;

  @override
  List<Object?> get props => [expenses, summary, filters, lookups];
}

class ExpensesEmpty extends ExpensesState {
  const ExpensesEmpty({
    required this.summary,
    required this.filters,
    required this.lookups,
  });

  final ExpensesSummaryViewModel summary;
  final ExpenseFilterViewModel filters;
  final ExpenseFormLookupsViewModel lookups;

  @override
  List<Object?> get props => [summary, filters, lookups];
}

class ExpensesError extends ExpensesState {
  const ExpensesError({
    required this.message,
    required this.filters,
  });

  final String message;
  final ExpenseFilterViewModel filters;

  @override
  List<Object?> get props => [message, filters];
}
