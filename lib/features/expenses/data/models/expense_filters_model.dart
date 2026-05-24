import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/expense_filters_entity.dart';
import 'expense_model_helpers.dart';

class ExpenseFiltersModel extends ExpenseFiltersEntity {
  const ExpenseFiltersModel({
    super.includeDeleted,
    super.status,
    super.categoryId,
    super.vendorId,
    super.paidFromAccountId,
    super.fromDate,
    super.toDate,
    super.search,
  });

  factory ExpenseFiltersModel.fromEntity(ExpenseFiltersEntity entity) {
    return ExpenseFiltersModel(
      includeDeleted: entity.includeDeleted,
      status: entity.status,
      categoryId: entity.categoryId,
      vendorId: entity.vendorId,
      paidFromAccountId: entity.paidFromAccountId,
      fromDate: entity.fromDate,
      toDate: entity.toDate,
      search: entity.search,
    );
  }

  ExpenseFiltersModel copyWith({
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
    return ExpenseFiltersModel(
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

  Map<String, dynamic> toJson() {
    return {
      'include_deleted': includeDeleted,
      'status': ExpenseModelHelpers.nullableEnumToJson(status),
      'category_id': categoryId,
      'vendor_id': vendorId,
      'paid_from_account_id': paidFromAccountId,
      'from_date': ExpenseModelHelpers.dateTimeToJson(fromDate),
      'to_date': ExpenseModelHelpers.dateTimeToJson(toDate),
      'search': search,
    };
  }
}
