import 'package:equatable/equatable.dart';

import '../view_model/expense_details_view_model.dart';
import '../view_model/expense_form_lookups_view_model.dart';

sealed class ExpenseDetailsState extends Equatable {
  const ExpenseDetailsState();

  @override
  List<Object?> get props => [];
}

class ExpenseDetailsInitial extends ExpenseDetailsState {
  const ExpenseDetailsInitial();
}

class ExpenseDetailsLoading extends ExpenseDetailsState {
  const ExpenseDetailsLoading();
}

class ExpenseDetailsLoaded extends ExpenseDetailsState {
  const ExpenseDetailsLoaded({
    required this.expense,
    required this.lookups,
  });

  final ExpenseDetailsViewModel expense;
  final ExpenseFormLookupsViewModel lookups;

  @override
  List<Object?> get props => [expense, lookups];
}

class ExpenseDetailsDeleted extends ExpenseDetailsState {
  const ExpenseDetailsDeleted();
}

class ExpenseDetailsError extends ExpenseDetailsState {
  const ExpenseDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
