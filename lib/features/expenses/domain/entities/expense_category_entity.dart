import 'package:equatable/equatable.dart';

class ExpenseCategoryEntity extends Equatable {
  const ExpenseCategoryEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.expenseAccountId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String? expenseAccountId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ExpenseCategoryEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? expenseAccountId,
    bool clearExpenseAccountId = false,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return ExpenseCategoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      expenseAccountId: clearExpenseAccountId
          ? null
          : expenseAccountId ?? this.expenseAccountId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        expenseAccountId,
        isActive,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
