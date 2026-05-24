import 'package:equatable/equatable.dart';

import 'expense_enums.dart';

class JournalEntryEntity extends Equatable {
  const JournalEntryEntity({
    required this.id,
    required this.userId,
    required this.number,
    this.entryDate,
    required this.currency,
    this.description,
    this.sourceType = JournalSourceType.manual,
    this.sourceId,
    this.status = JournalEntryStatus.draft,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String number;
  final DateTime? entryDate;
  final String currency;
  final String? description;
  final JournalSourceType sourceType;
  final String? sourceId;
  final JournalEntryStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  JournalEntryEntity copyWith({
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
    return JournalEntryEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        number,
        entryDate,
        currency,
        description,
        sourceType,
        sourceId,
        status,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
