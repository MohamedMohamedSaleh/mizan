import 'package:equatable/equatable.dart';

import 'expense_enums.dart';

class ExpenseEntity extends Equatable {
  const ExpenseEntity({
    required this.id,
    required this.userId,
    required this.code,
    required this.amount,
    required this.currency,
    this.description,
    this.expenseDate,
    this.categoryId,
    this.vendorId,
    this.paidFromAccountId,
    this.subAccountId,
    this.taxId,
    this.status = ExpenseStatus.draft,
    this.isRecurring = false,
    this.recurrenceType,
    this.recurrenceEndDate,
    this.attachmentUrl,
    this.journalEntryId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
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

  ExpenseEntity copyWith({
    String? id,
    String? userId,
    String? code,
    double? amount,
    String? currency,
    String? description,
    bool clearDescription = false,
    DateTime? expenseDate,
    bool clearExpenseDate = false,
    String? categoryId,
    bool clearCategoryId = false,
    String? vendorId,
    bool clearVendorId = false,
    String? paidFromAccountId,
    bool clearPaidFromAccountId = false,
    String? subAccountId,
    bool clearSubAccountId = false,
    String? taxId,
    bool clearTaxId = false,
    ExpenseStatus? status,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
    bool clearRecurrenceType = false,
    DateTime? recurrenceEndDate,
    bool clearRecurrenceEndDate = false,
    String? attachmentUrl,
    bool clearAttachmentUrl = false,
    String? journalEntryId,
    bool clearJournalEntryId = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: clearDescription ? null : description ?? this.description,
      expenseDate: clearExpenseDate ? null : expenseDate ?? this.expenseDate,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      vendorId: clearVendorId ? null : vendorId ?? this.vendorId,
      paidFromAccountId: clearPaidFromAccountId
          ? null
          : paidFromAccountId ?? this.paidFromAccountId,
      subAccountId: clearSubAccountId ? null : subAccountId ?? this.subAccountId,
      taxId: clearTaxId ? null : taxId ?? this.taxId,
      status: status ?? this.status,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: clearRecurrenceType
          ? null
          : recurrenceType ?? this.recurrenceType,
      recurrenceEndDate: clearRecurrenceEndDate
          ? null
          : recurrenceEndDate ?? this.recurrenceEndDate,
      attachmentUrl: clearAttachmentUrl ? null : attachmentUrl ?? this.attachmentUrl,
      journalEntryId: clearJournalEntryId
          ? null
          : journalEntryId ?? this.journalEntryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
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
