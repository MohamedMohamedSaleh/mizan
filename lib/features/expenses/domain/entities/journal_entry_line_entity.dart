import 'package:equatable/equatable.dart';

class JournalEntryLineEntity extends Equatable {
  const JournalEntryLineEntity({
    required this.id,
    required this.userId,
    required this.journalEntryId,
    required this.accountId,
    this.description,
    this.debit = 0,
    this.credit = 0,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String journalEntryId;
  final String accountId;
  final String? description;
  final double debit;
  final double credit;
  final DateTime? createdAt;

  JournalEntryLineEntity copyWith({
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
    return JournalEntryLineEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        journalEntryId,
        accountId,
        description,
        debit,
        credit,
        createdAt,
      ];
}
