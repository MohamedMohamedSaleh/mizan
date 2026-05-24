import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/expense_enums.dart';
import '../models/account_model.dart';
import '../models/expense_model_helpers.dart';
import 'authenticated_supabase_data_source.dart';

abstract class AccountsRemoteDataSource {
  Future<List<AccountModel>> getAccounts();
  Future<List<AccountModel>> getPaymentAccounts();
  Future<List<AccountModel>> getExpenseAccounts();
}

class AccountsRemoteDataSourceImpl
    with AuthenticatedSupabaseDataSource
    implements AccountsRemoteDataSource {
  AccountsRemoteDataSourceImpl(this.client);

  @override
  final SupabaseClient client;

  static const _table = 'accounts';

  @override
  Future<List<AccountModel>> getAccounts() async {
    final response = await _baseActiveQuery().order('code', ascending: true);
    return rowsAsMaps(response).map(AccountModel.fromJson).toList();
  }

  @override
  Future<List<AccountModel>> getPaymentAccounts() async {
    final response = await _baseActiveQuery()
        .eq('is_payment_account', true)
        .eq('is_active', true)
        .order('code', ascending: true);
    return rowsAsMaps(response).map(AccountModel.fromJson).toList();
  }

  @override
  Future<List<AccountModel>> getExpenseAccounts() async {
    final response = await _baseActiveQuery()
        .eq('type', ExpenseModelHelpers.enumToJson(AccountType.expense))
        .eq('is_active', true)
        .order('code', ascending: true);
    return rowsAsMaps(response).map(AccountModel.fromJson).toList();
  }

  dynamic _baseActiveQuery() {
    return client
        .from(_table)
        .select()
        .eq('user_id', currentUserId)
        .isFilter('deleted_at', null);
  }
}
