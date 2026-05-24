import '../../domain/entities/tax_entity.dart';
import 'expense_model_helpers.dart';

class TaxModel extends TaxEntity {
  const TaxModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.rate,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      name: ExpenseModelHelpers.stringValue(json['name']),
      rate: ExpenseModelHelpers.doubleValue(json['rate']),
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
      'rate': rate,
      'is_active': isActive,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
      'deleted_at': ExpenseModelHelpers.dateTimeToJson(deletedAt),
    };
  }

  TaxEntity toEntity() => TaxEntity(
        id: id,
        userId: userId,
        name: name,
        rate: rate,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

  @override
  TaxModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? rate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return TaxModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      rate: rate ?? this.rate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }
}
