import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_enums.dart';

class ExpenseDetailsViewModel extends Equatable {
  const ExpenseDetailsViewModel({
    required this.id,
    required this.code,
    required this.amount,
    required this.currency,
    required this.description,
    required this.expenseDate,
    required this.categoryId,
    required this.vendorId,
    required this.paidFromAccountId,
    required this.subAccountId,
    required this.taxId,
    required this.status,
    required this.isRecurring,
    required this.recurrenceType,
    required this.recurrenceEndDate,
    required this.attachmentUrl,
    required this.journalEntryId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ExpenseDetailsViewModel.fromEntity(ExpenseEntity entity) {
    return ExpenseDetailsViewModel(
      id: entity.id,
      code: entity.code,
      amount: entity.amount,
      currency: entity.currency,
      description: entity.description,
      expenseDate: entity.expenseDate,
      categoryId: entity.categoryId,
      vendorId: entity.vendorId,
      paidFromAccountId: entity.paidFromAccountId,
      subAccountId: entity.subAccountId,
      taxId: entity.taxId,
      status: entity.status,
      isRecurring: entity.isRecurring,
      recurrenceType: entity.recurrenceType,
      recurrenceEndDate: entity.recurrenceEndDate,
      attachmentUrl: entity.attachmentUrl,
      journalEntryId: entity.journalEntryId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  final String id;
  final String code;
  final double amount;
  final String currency;
  final String? description;
  final DateTime? expenseDate;
  final String? categoryId;
  final String? vendorId;
  final String? paidFromAccountId;
  final String? subAccountId;
  final String? taxId;
  final ExpenseStatus status;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;
  final DateTime? recurrenceEndDate;
  final String? attachmentUrl;
  final String? journalEntryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  @override
  List<Object?> get props => [
        id,
        code,
        amount,
        currency,
        description,
        expenseDate,
        categoryId,
        vendorId,
        paidFromAccountId,
        subAccountId,
        taxId,
        status,
        isRecurring,
        recurrenceType,
        recurrenceEndDate,
        attachmentUrl,
        journalEntryId,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
