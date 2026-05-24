import 'package:equatable/equatable.dart';

import 'account_entity.dart';
import 'expense_category_entity.dart';
import 'tax_entity.dart';
import 'vendor_entity.dart';

class ExpenseFormLookupsEntity extends Equatable {
  const ExpenseFormLookupsEntity({
    required this.accounts,
    required this.paymentAccounts,
    required this.expenseAccounts,
    required this.categories,
    required this.vendors,
    required this.taxes,
  });

  final List<AccountEntity> accounts;
  final List<AccountEntity> paymentAccounts;
  final List<AccountEntity> expenseAccounts;
  final List<ExpenseCategoryEntity> categories;
  final List<VendorEntity> vendors;
  final List<TaxEntity> taxes;

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
