import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_enums.dart';
import 'expense_model_helpers.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.userId,
    required super.code,
    required super.amount,
    required super.currency,
    super.description,
    super.expenseDate,
    super.categoryId,
    super.vendorId,
    super.paidFromAccountId,
    super.subAccountId,
    super.taxId,
    super.status,
    super.isRecurring,
    super.recurrenceType,
    super.recurrenceEndDate,
    super.attachmentUrl,
    super.journalEntryId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      userId: entity.userId,
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      code: ExpenseModelHelpers.stringValue(json['code']),
      amount: ExpenseModelHelpers.doubleValue(json['amount']),
      currency: ExpenseModelHelpers.stringValue(json['currency']),
      description: ExpenseModelHelpers.nullableStringValue(json['description']),
      expenseDate: ExpenseModelHelpers.dateTimeValue(json['expense_date']),
      categoryId: ExpenseModelHelpers.nullableStringValue(json['category_id']),
      vendorId: ExpenseModelHelpers.nullableStringValue(json['vendor_id']),
      paidFromAccountId: ExpenseModelHelpers.nullableStringValue(
        json['paid_from_account_id'],
      ),
      subAccountId: ExpenseModelHelpers.nullableStringValue(
        json['sub_account_id'],
      ),
      taxId: ExpenseModelHelpers.nullableStringValue(json['tax_id']),
      status: ExpenseModelHelpers.expenseStatusValue(json['status']),
      isRecurring: ExpenseModelHelpers.boolValue(json['is_recurring']),
      recurrenceType: ExpenseModelHelpers.recurrenceTypeValue(
        json['recurrence_type'],
      ),
      recurrenceEndDate: ExpenseModelHelpers.dateTimeValue(
        json['recurrence_end_date'],
      ),
      attachmentUrl: ExpenseModelHelpers.nullableStringValue(
        json['attachment_url'],
      ),
      journalEntryId: ExpenseModelHelpers.nullableStringValue(
        json['journal_entry_id'],
      ),
      createdAt: ExpenseModelHelpers.dateTimeValue(json['created_at']),
      updatedAt: ExpenseModelHelpers.dateTimeValue(json['updated_at']),
      deletedAt: ExpenseModelHelpers.dateTimeValue(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'amount': amount,
      'currency': currency,
      'description': description,
      'expense_date': ExpenseModelHelpers.dateTimeToJson(expenseDate),
      'category_id': categoryId,
      'vendor_id': vendorId,
      'paid_from_account_id': paidFromAccountId,
      'sub_account_id': subAccountId,
      'tax_id': taxId,
      'status': ExpenseModelHelpers.enumToJson(status),
      'is_recurring': isRecurring,
      'recurrence_type': ExpenseModelHelpers.nullableEnumToJson(recurrenceType),
      'recurrence_end_date': ExpenseModelHelpers.dateTimeToJson(
        recurrenceEndDate,
      ),
      'attachment_url': attachmentUrl,
      'journal_entry_id': journalEntryId,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
      'deleted_at': ExpenseModelHelpers.dateTimeToJson(deletedAt),
    };
  }

  ExpenseEntity toEntity() => ExpenseEntity(
        id: id,
        userId: userId,
        code: code,
        amount: amount,
        currency: currency,
        description: description,
        expenseDate: expenseDate,
        categoryId: categoryId,
        vendorId: vendorId,
        paidFromAccountId: paidFromAccountId,
        subAccountId: subAccountId,
        taxId: taxId,
        status: status,
        isRecurring: isRecurring,
        recurrenceType: recurrenceType,
        recurrenceEndDate: recurrenceEndDate,
        attachmentUrl: attachmentUrl,
        journalEntryId: journalEntryId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

  @override
  ExpenseModel copyWith({
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
    return ExpenseModel(
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
}
