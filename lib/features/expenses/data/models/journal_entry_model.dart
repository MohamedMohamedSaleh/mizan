import '../../domain/entities/expense_enums.dart';
import '../../domain/entities/journal_entry_entity.dart';
import 'expense_model_helpers.dart';

class JournalEntryModel extends JournalEntryEntity {
  const JournalEntryModel({
    required super.id,
    required super.userId,
    required super.number,
    super.entryDate,
    required super.currency,
    super.description,
    super.sourceType,
    super.sourceId,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory JournalEntryModel.fromEntity(JournalEntryEntity entity) {
    return JournalEntryModel(
      id: entity.id,
      userId: entity.userId,
      number: entity.number,
      entryDate: entity.entryDate,
      currency: entity.currency,
      description: entity.description,
      sourceType: entity.sourceType,
      sourceId: entity.sourceId,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      number: ExpenseModelHelpers.stringValue(json['number']),
      entryDate: ExpenseModelHelpers.dateTimeValue(json['entry_date']),
      currency: ExpenseModelHelpers.stringValue(json['currency']),
      description: ExpenseModelHelpers.nullableStringValue(json['description']),
      sourceType: ExpenseModelHelpers.journalSourceTypeValue(
        json['source_type'],
      ),
      sourceId: ExpenseModelHelpers.nullableStringValue(json['source_id']),
      status: ExpenseModelHelpers.journalEntryStatusValue(json['status']),
      createdAt: ExpenseModelHelpers.dateTimeValue(json['created_at']),
      updatedAt: ExpenseModelHelpers.dateTimeValue(json['updated_at']),
      deletedAt: ExpenseModelHelpers.dateTimeValue(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'number': number,
      'entry_date': ExpenseModelHelpers.dateTimeToJson(entryDate),
      'currency': currency,
      'description': description,
      'source_type': ExpenseModelHelpers.enumToJson(sourceType),
      'source_id': sourceId,
      'status': ExpenseModelHelpers.enumToJson(status),
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
      'deleted_at': ExpenseModelHelpers.dateTimeToJson(deletedAt),
    };
  }

  JournalEntryEntity toEntity() => JournalEntryEntity(
        id: id,
        userId: userId,
        number: number,
        entryDate: entryDate,
        currency: currency,
        description: description,
        sourceType: sourceType,
        sourceId: sourceId,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

  @override
  JournalEntryModel copyWith({
    String? id,
    String? userId,
    String? number,
    DateTime? entryDate,
    bool clearEntryDate = false,
    String? currency,
    String? description,
    bool clearDescription = false,
    JournalSourceType? sourceType,
    String? sourceId,
    bool clearSourceId = false,
    JournalEntryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      number: number ?? this.number,
      entryDate: clearEntryDate ? null : entryDate ?? this.entryDate,
      currency: currency ?? this.currency,
      description: clearDescription ? null : description ?? this.description,
      sourceType: sourceType ?? this.sourceType,
      sourceId: clearSourceId ? null : sourceId ?? this.sourceId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }
}
