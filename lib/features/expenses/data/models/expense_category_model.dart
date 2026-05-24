import '../../domain/entities/expense_category_entity.dart';
import 'expense_model_helpers.dart';

class ExpenseCategoryModel extends ExpenseCategoryEntity {
  const ExpenseCategoryModel({
    required super.id,
    required super.userId,
    required super.name,
    super.expenseAccountId,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      name: ExpenseModelHelpers.stringValue(json['name']),
      expenseAccountId: ExpenseModelHelpers.nullableStringValue(
        json['expense_account_id'],
      ),
      isActive: ExpenseModelHelpers.boolValue(json['is_active'], fallback: true),
      createdAt: ExpenseModelHelpers.dateTimeValue(json['created_at']),
      updatedAt: ExpenseModelHelpers.dateTimeValue(json['updated_at']),
      deletedAt: ExpenseModelHelpers.dateTimeValue(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'expense_account_id': expenseAccountId,
      'is_active': isActive,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
      'deleted_at': ExpenseModelHelpers.dateTimeToJson(deletedAt),
    };
  }

  ExpenseCategoryEntity toEntity() => ExpenseCategoryEntity(
        id: id,
        userId: userId,
        name: name,
        expenseAccountId: expenseAccountId,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

  @override
  ExpenseCategoryModel copyWith({
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
    return ExpenseCategoryModel(
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
}
