import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/expense_enums.dart';
import '../models/expense_filters_model.dart';
import '../models/expense_model.dart';
import '../models/expense_model_helpers.dart';
import '../models/expenses_summary_model.dart';
import 'authenticated_supabase_data_source.dart';

abstract class ExpensesRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses({ExpenseFiltersModel? filters});
  Future<ExpenseModel> getExpenseById(String id);
  Future<ExpenseModel> createExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> softDeleteExpense(String id);
  Future<ExpensesSummaryModel> getExpensesSummary();
}

class ExpensesRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements ExpensesRemoteDataSource {
  ExpensesRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _table = 'expenses';

  @override
  Future<List<ExpenseModel>> getExpenses({ExpenseFiltersModel? filters}) async {
    final userId = currentUserId;
    final appliedFilters = filters ?? const ExpenseFiltersModel();

    dynamic query = client.from(_table).select().eq('user_id', userId);

    if (!appliedFilters.includeDeleted) {
      query = query.isFilter('deleted_at', null);
    }
    if (appliedFilters.status != null) {
      query = query.eq(
        'status',
        ExpenseModelHelpers.enumToJson(appliedFilters.status!),
      );
    }
    if (appliedFilters.categoryId != null) {
      query = query.eq('category_id', appliedFilters.categoryId!);
    }
    if (appliedFilters.vendorId != null) {
      query = query.eq('vendor_id', appliedFilters.vendorId!);
    }
    if (appliedFilters.paidFromAccountId != null) {
      query = query.eq(
        'paid_from_account_id',
        appliedFilters.paidFromAccountId!,
      );
    }
    if (appliedFilters.fromDate != null) {
      query = query.gte(
        'expense_date',
        appliedFilters.fromDate!.toIso8601String(),
      );
    }
    if (appliedFilters.toDate != null) {
      query = query.lte(
        'expense_date',
        appliedFilters.toDate!.toIso8601String(),
      );
    }
    final search = appliedFilters.search?.trim();
    if (search != null && search.isNotEmpty) {
      query = query.or('code.ilike.%$search%,description.ilike.%$search%');
    }

    final response = await query.order('expense_date', ascending: false);
    return rowsAsMaps(response).map(ExpenseModel.fromJson).toList();
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    final userId = currentUserId;
    final response = await client
        .from(_table)
        .select()
        .eq('id', id)
        .eq('user_id', userId)
        .isFilter('deleted_at', null)
        .single();

    return ExpenseModel.fromJson(rowAsMap(response));
  }

  @override
  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    final userId = currentUserId;
    final payload = dataForInsert(expense.toJson(), userId);
    payload['created_at'] ??= DateTime.now().toIso8601String();
    payload['updated_at'] ??= DateTime.now().toIso8601String();
    payload['deleted_at'] = null;

    final response = await client.from(_table).insert(payload).select().single();
    return ExpenseModel.fromJson(rowAsMap(response));
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final userId = currentUserId;
    final payload = dataForUpdate(expense.toJson(), userId);

    final response = await client
        .from(_table)
        .update(payload)
        .eq('id', expense.id)
        .eq('user_id', userId)
        .isFilter('deleted_at', null)
        .select()
        .single();

    return ExpenseModel.fromJson(rowAsMap(response));
  }

  @override
  Future<void> softDeleteExpense(String id) async {
    final userId = currentUserId;
    final now = DateTime.now().toIso8601String();
    await client
        .from(_table)
        .update({
          'deleted_at': now,
          'updated_at': now,
        })
        .eq('id', id)
        .eq('user_id', userId)
        .isFilter('deleted_at', null);
  }

  @override
  Future<ExpensesSummaryModel> getExpensesSummary() async {
    final userId = currentUserId;
    final response = await client
        .from(_table)
        .select('amount,status')
        .eq('user_id', userId)
        .isFilter('deleted_at', null);

    var totalAmount = 0.0;
    var draftCount = 0;
    var savedCount = 0;
    var voidedCount = 0;
    final rows = rowsAsMaps(response);

    for (final row in rows) {
      totalAmount += ExpenseModelHelpers.doubleValue(row['amount']);
      switch (ExpenseModelHelpers.expenseStatusValue(row['status'])) {
        case ExpenseStatus.draft:
          draftCount++;
        case ExpenseStatus.saved:
          savedCount++;
        case ExpenseStatus.voided:
          voidedCount++;
      }
    }

    return ExpensesSummaryModel(
      totalAmount: totalAmount,
      expensesCount: rows.length,
      draftCount: draftCount,
      savedCount: savedCount,
      voidedCount: voidedCount,
    );
  }
}
