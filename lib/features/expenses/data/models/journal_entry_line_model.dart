import '../../domain/entities/journal_entry_line_entity.dart';
import 'expense_model_helpers.dart';

class JournalEntryLineModel extends JournalEntryLineEntity {
  const JournalEntryLineModel({
    required super.id,
    required super.userId,
    required super.journalEntryId,
    required super.accountId,
    super.description,
    super.debit,
    super.credit,
    super.createdAt,
  });

  factory JournalEntryLineModel.fromEntity(JournalEntryLineEntity entity) {
    return JournalEntryLineModel(
      id: entity.id,
      userId: entity.userId,
      journalEntryId: entity.journalEntryId,
      accountId: entity.accountId,
      description: entity.description,
      debit: entity.debit,
      credit: entity.credit,
      createdAt: entity.createdAt,
    );
  }

  factory JournalEntryLineModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryLineModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      journalEntryId: ExpenseModelHelpers.stringValue(
        json['journal_entry_id'],
      ),
      accountId: ExpenseModelHelpers.stringValue(json['account_id']),
      description: ExpenseModelHelpers.nullableStringValue(json['description']),
      debit: ExpenseModelHelpers.doubleValue(json['debit']),
      credit: ExpenseModelHelpers.doubleValue(json['credit']),
      createdAt: ExpenseModelHelpers.dateTimeValue(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'journal_entry_id': journalEntryId,
      'account_id': accountId,
      'description': description,
      'debit': debit,
      'credit': credit,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
    };
  }

  JournalEntryLineEntity toEntity() => JournalEntryLineEntity(
        id: id,
        userId: userId,
        journalEntryId: journalEntryId,
        accountId: accountId,
        description: description,
        debit: debit,
        credit: credit,
        createdAt: createdAt,
      );

  @override
  JournalEntryLineModel copyWith({
    String? id,
    String? userId,
    String? journalEntryId,
    String? accountId,
    String? description,
    bool clearDescription = false,
    double? debit,
    double? credit,
    DateTime? createdAt,
  }) {
    return JournalEntryLineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      journalEntryId: journalEntryId ?? this.journalEntryId,
      accountId: accountId ?? this.accountId,
      description: clearDescription ? null : description ?? this.description,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
