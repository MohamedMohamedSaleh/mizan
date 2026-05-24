import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_enums.dart';

class ExpenseListItemViewModel extends Equatable {
  const ExpenseListItemViewModel({
    required this.id,
    required this.code,
    required this.amount,
    required this.currency,
    required this.expenseDate,
    required this.description,
    required this.categoryId,
    required this.status,
    required this.isRecurring,
  });

  factory ExpenseListItemViewModel.fromEntity(ExpenseEntity entity) {
    return ExpenseListItemViewModel(
      id: entity.id,
      code: entity.code,
      amount: entity.amount,
      currency: entity.currency,
      expenseDate: entity.expenseDate,
      description: entity.description,
      categoryId: entity.categoryId,
      status: entity.status,
      isRecurring: entity.isRecurring,
    );
  }

  final String id;
  final String code;
  final double amount;
  final String currency;
  final DateTime? expenseDate;
  final String? description;
  final String? categoryId;
  final ExpenseStatus status;
  final bool isRecurring;

  @override
  List<Object?> get props => [
        id,
        code,
        amount,
        currency,
        expenseDate,
        description,
        categoryId,
        status,
        isRecurring,
      ];
}
