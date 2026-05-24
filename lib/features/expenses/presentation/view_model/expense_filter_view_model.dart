import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/expense_filters_entity.dart';

class ExpenseFilterViewModel extends Equatable {
  const ExpenseFilterViewModel({
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

  bool get hasActiveFilters =>
      includeDeleted ||
      status != null ||
      categoryId != null ||
      vendorId != null ||
      paidFromAccountId != null ||
      fromDate != null ||
      toDate != null ||
      (search?.trim().isNotEmpty ?? false);

  ExpenseFiltersEntity toEntity() {
    return ExpenseFiltersEntity(
      includeDeleted: includeDeleted,
      status: status,
      categoryId: categoryId,
      vendorId: vendorId,
      paidFromAccountId: paidFromAccountId,
      fromDate: fromDate,
      toDate: toDate,
      search: search,
    );
  }

  ExpenseFilterViewModel copyWith({
    bool? includeDeleted,
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
    String? search,
    bool clearSearch = false,
  }) {
    return ExpenseFilterViewModel(
      includeDeleted: includeDeleted ?? this.includeDeleted,
      status: clearStatus ? null : status ?? this.status,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      vendorId: clearVendorId ? null : vendorId ?? this.vendorId,
      paidFromAccountId: clearPaidFromAccountId
          ? null
          : paidFromAccountId ?? this.paidFromAccountId,
      fromDate: clearFromDate ? null : fromDate ?? this.fromDate,
      toDate: clearToDate ? null : toDate ?? this.toDate,
      search: clearSearch ? null : search ?? this.search,
    );
  }

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
