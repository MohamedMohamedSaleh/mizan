import 'package:equatable/equatable.dart';

import 'expense_enums.dart';

class ExpenseFiltersEntity extends Equatable {
  const ExpenseFiltersEntity({
    this.includeDeleted = false,
    this.status,
    this.categoryId,
    this.vendorId,
    this.paidFromAccountId,
    this.fromDate,
    this.toDate,
    this.search,
  });

  final bool includeDeleted;
  final ExpenseStatus? status;
  final String? categoryId;
  final String? vendorId;
  final String? paidFromAccountId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? search;

  @override
  List<Object?> get props => [
        includeDeleted,
        status,
        categoryId,
        vendorId,
        paidFromAccountId,
        fromDate,
        toDate,
        search,
      ];
}
