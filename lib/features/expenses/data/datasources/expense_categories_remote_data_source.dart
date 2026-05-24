import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/expense_category_model.dart';
import 'authenticated_supabase_data_source.dart';

abstract class ExpenseCategoriesRemoteDataSource {
  Future<List<ExpenseCategoryModel>> getCategories();
  Future<ExpenseCategoryModel> createCategory(
    String name,
    String expenseAccountId,
  );
}

class ExpenseCategoriesRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements ExpenseCategoriesRemoteDataSource {
  ExpenseCategoriesRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _table = 'expense_categories';

  @override
  Future<List<ExpenseCategoryModel>> getCategories() async {
    final response = await client
        .from(_table)
        .select()
        .eq('user_id', currentUserId)
        .eq('is_active', true)
        .isFilter('deleted_at', null)
        .order('name', ascending: true);

    return rowsAsMaps(response).map(ExpenseCategoryModel.fromJson).toList();
  }

  @override
  Future<ExpenseCategoryModel> createCategory(
    String name,
    String expenseAccountId,
  ) async {
    final userId = currentUserId;
    final now = DateTime.now().toIso8601String();
    final response = await client
        .from(_table)
        .insert({
          'user_id': userId,
          'name': name.trim(),
          'expense_account_id': expenseAccountId,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
          'deleted_at': null,
        })
        .select()
        .single();

    return ExpenseCategoryModel.fromJson(rowAsMap(response));
  }
}
