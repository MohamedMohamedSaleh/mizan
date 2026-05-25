import 'package:equatable/equatable.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/expense_form_lookups_entity.dart';
import '../../domain/entities/tax_entity.dart';
import '../../domain/entities/vendor_entity.dart';

class ExpenseFormLookupsViewModel extends Equatable {
  const ExpenseFormLookupsViewModel({
    required this.accounts,
    required this.paymentAccounts,
    required this.expenseAccounts,
    required this.categories,
    required this.vendors,
    required this.taxes,
  });

  factory ExpenseFormLookupsViewModel.fromEntity(
    ExpenseFormLookupsEntity entity,
  ) {
    return ExpenseFormLookupsViewModel(
      accounts: entity.accounts,
      paymentAccounts: entity.paymentAccounts,
      expenseAccounts: entity.expenseAccounts,
      categories: entity.categories,
      vendors: entity.vendors,
      taxes: entity.taxes,
    );
  }

  static const empty = ExpenseFormLookupsViewModel(
    accounts: [],
    paymentAccounts: [],
    expenseAccounts: [],
    categories: [],
    vendors: [],
    taxes: [],
  );

  final List<AccountEntity> accounts;
  final List<AccountEntity> paymentAccounts;
  final List<AccountEntity> expenseAccounts;
  final List<ExpenseCategoryEntity> categories;
  final List<VendorEntity> vendors;
  final List<TaxEntity> taxes;

  ExpenseFormLookupsViewModel copyWith({
    List<AccountEntity>? accounts,
    List<AccountEntity>? paymentAccounts,
    List<AccountEntity>? expenseAccounts,
    List<ExpenseCategoryEntity>? categories,
    List<VendorEntity>? vendors,
    List<TaxEntity>? taxes,
  }) {
    return ExpenseFormLookupsViewModel(
      accounts: accounts ?? this.accounts,
      paymentAccounts: paymentAccounts ?? this.paymentAccounts,
      expenseAccounts: expenseAccounts ?? this.expenseAccounts,
      categories: categories ?? this.categories,
      vendors: vendors ?? this.vendors,
      taxes: taxes ?? this.taxes,
    );
  }

  AccountEntity? expenseAccountForCategory(String? categoryId) {
    if (categoryId == null) return null;
    ExpenseCategoryEntity? selectedCategory;
    for (final category in categories) {
      if (category.id == categoryId) {
        selectedCategory = category;
        break;
      }
    }
    final expenseAccountId = selectedCategory?.expenseAccountId;
    if (expenseAccountId == null) return null;
    for (final account in accounts) {
      if (account.id == expenseAccountId) return account;
    }
    return null;
  }

  AccountEntity? accountById(String? accountId) {
    if (accountId == null) return null;
    for (final account in accounts) {
      if (account.id == accountId) return account;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        accounts,
        paymentAccounts,
        expenseAccounts,
        categories,
        vendors,
        taxes,
      ];
}
