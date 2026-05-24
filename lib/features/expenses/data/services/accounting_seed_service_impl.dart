import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException, SupabaseClient;

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/expense_enums.dart';
import '../../domain/services/accounting_seed_service.dart';
import '../models/expense_model_helpers.dart';

class AccountingSeedServiceImpl implements AccountingSeedService {
  AccountingSeedServiceImpl(this._client);

  final SupabaseClient _client;

  static const _accountsTable = 'accounts';
  static const _categoriesTable = 'expense_categories';
  static const _taxesTable = 'taxes';

  @override
  Future<Result<bool>> seedForCurrentUserIfNeeded() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        return const Error(
          AuthFailure(message: 'User is not authenticated.'),
        );
      }

      var didSeed = false;
      final now = DateTime.now().toIso8601String();

      final existingAccounts = await _client
          .from(_accountsTable)
          .select('id')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .limit(1);

      if (existingAccounts.isEmpty) {
        await _client.from(_accountsTable).insert(_defaultAccounts(userId, now));
        didSeed = true;
      }

      final accounts = await _client
          .from(_accountsTable)
          .select('id,code')
          .eq('user_id', userId)
          .isFilter('deleted_at', null);
      final accountIdsByCode = <String, String>{
        for (final row in accounts)
          row['code'].toString(): row['id'].toString(),
      };

      final existingCategories = await _client
          .from(_categoriesTable)
          .select('id')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .limit(1);
      if (existingCategories.isEmpty) {
        await _client.from(_categoriesTable).insert(
              _defaultCategories(userId, now, accountIdsByCode),
            );
        didSeed = true;
      }

      final existingTaxes = await _client
          .from(_taxesTable)
          .select('id')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .limit(1);
      if (existingTaxes.isEmpty) {
        await _client.from(_taxesTable).insert(_defaultTaxes(userId, now));
        didSeed = true;
      }

      return Success(didSeed);
    } on AuthException catch (error) {
      return Error(AuthFailure(message: error.message));
    } on PostgrestException catch (error) {
      return Error(ServerFailure(message: error.message));
    } catch (error) {
      return Error(UnexpectedFailure(message: error.toString()));
    }
  }

  List<Map<String, dynamic>> _defaultAccounts(String userId, String now) {
    return [
      _account(
        userId: userId,
        now: now,
        code: '1000',
        name: 'Cash',
        type: AccountType.asset,
        isPaymentAccount: true,
        paymentAccountType: PaymentAccountType.cash,
      ),
      _account(
        userId: userId,
        now: now,
        code: '1010',
        name: 'Bank',
        type: AccountType.asset,
        isPaymentAccount: true,
        paymentAccountType: PaymentAccountType.bank,
      ),
      _account(
        userId: userId,
        now: now,
        code: '5000',
        name: 'Rent Expense',
        type: AccountType.expense,
      ),
      _account(
        userId: userId,
        now: now,
        code: '5010',
        name: 'Electricity Expense',
        type: AccountType.expense,
      ),
      _account(
        userId: userId,
        now: now,
        code: '5020',
        name: 'Salary Expense',
        type: AccountType.expense,
      ),
      _account(
        userId: userId,
        now: now,
        code: '5030',
        name: 'Transportation Expense',
        type: AccountType.expense,
      ),
      _account(
        userId: userId,
        now: now,
        code: '5090',
        name: 'Miscellaneous Expense',
        type: AccountType.expense,
      ),
    ];
  }

  Map<String, dynamic> _account({
    required String userId,
    required String now,
    required String code,
    required String name,
    required AccountType type,
    bool isPaymentAccount = false,
    PaymentAccountType? paymentAccountType,
  }) {
    return {
      'user_id': userId,
      'code': code,
      'name': name,
      'type': ExpenseModelHelpers.enumToJson(type),
      'is_payment_account': isPaymentAccount,
      'payment_account_type': ExpenseModelHelpers.nullableEnumToJson(
        paymentAccountType,
      ),
      'is_active': true,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    };
  }

  List<Map<String, dynamic>> _defaultCategories(
    String userId,
    String now,
    Map<String, String> accountIdsByCode,
  ) {
    return [
      _category(userId, now, 'Rent', accountIdsByCode['5000']),
      _category(userId, now, 'Electricity', accountIdsByCode['5010']),
      _category(userId, now, 'Salaries', accountIdsByCode['5020']),
      _category(userId, now, 'Transportation', accountIdsByCode['5030']),
      _category(userId, now, 'Other', accountIdsByCode['5090']),
    ];
  }

  Map<String, dynamic> _category(
    String userId,
    String now,
    String name,
    String? expenseAccountId,
  ) {
    return {
      'user_id': userId,
      'name': name,
      'expense_account_id': expenseAccountId,
      'is_active': true,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    };
  }

  List<Map<String, dynamic>> _defaultTaxes(String userId, String now) {
    return [
      {
        'user_id': userId,
        'name': 'VAT 14%',
        'rate': 14,
        'is_active': true,
        'created_at': now,
        'updated_at': now,
        'deleted_at': null,
      },
    ];
  }
}
