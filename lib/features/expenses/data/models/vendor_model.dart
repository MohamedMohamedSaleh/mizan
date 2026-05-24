import '../../domain/entities/vendor_entity.dart';
import 'expense_model_helpers.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.userId,
    required super.name,
    super.phone,
    super.email,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      name: ExpenseModelHelpers.stringValue(json['name']),
      phone: ExpenseModelHelpers.nullableStringValue(json['phone']),
      email: ExpenseModelHelpers.nullableStringValue(json['email']),
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
      'phone': phone,
      'email': email,
      'is_active': isActive,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
      'deleted_at': ExpenseModelHelpers.dateTimeToJson(deletedAt),
    };
  }

  VendorEntity toEntity() => VendorEntity(
        id: id,
        userId: userId,
        name: name,
        phone: phone,
        email: email,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

  @override
  VendorModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    bool clearPhone = false,
    String? email,
    bool clearEmail = false,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return VendorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: clearPhone ? null : phone ?? this.phone,
      email: clearEmail ? null : email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }
}
