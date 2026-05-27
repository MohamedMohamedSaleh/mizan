import '../../domain/entities/vendor_entity.dart';
import 'expense_model_helpers.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.userId,
    required super.name,
    super.phone,
    super.email,
    super.address,
    super.taxNumber,
    super.notes,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory VendorModel.fromEntity(VendorEntity entity) {
    return VendorModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      taxNumber: entity.taxNumber,
      notes: entity.notes,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: ExpenseModelHelpers.stringValue(json['id']),
      userId: ExpenseModelHelpers.stringValue(json['user_id']),
      name: ExpenseModelHelpers.stringValue(json['name']),
      phone: ExpenseModelHelpers.nullableStringValue(json['phone']),
      email: ExpenseModelHelpers.nullableStringValue(json['email']),
      address: ExpenseModelHelpers.nullableStringValue(json['address']),
      taxNumber: ExpenseModelHelpers.nullableStringValue(json['tax_number']),
      notes: ExpenseModelHelpers.nullableStringValue(json['notes']),
      status: ExpenseModelHelpers.nullableStringValue(json['status']),
      createdAt: ExpenseModelHelpers.dateTimeValue(json['created_at']),
      updatedAt: ExpenseModelHelpers.dateTimeValue(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'tax_number': taxNumber,
      'notes': notes,
      'status': status,
      'created_at': ExpenseModelHelpers.dateTimeToJson(createdAt),
      'updated_at': ExpenseModelHelpers.dateTimeToJson(updatedAt),
    };
  }

  VendorEntity toEntity() => VendorEntity(
        id: id,
        userId: userId,
        name: name,
        phone: phone,
        email: email,
        address: address,
        taxNumber: taxNumber,
        notes: notes,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
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
    String? address,
    bool clearAddress = false,
    String? taxNumber,
    bool clearTaxNumber = false,
    String? notes,
    bool clearNotes = false,
    String? status,
    bool clearStatus = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: clearPhone ? null : phone ?? this.phone,
      email: clearEmail ? null : email ?? this.email,
      address: clearAddress ? null : address ?? this.address,
      taxNumber: clearTaxNumber ? null : taxNumber ?? this.taxNumber,
      notes: clearNotes ? null : notes ?? this.notes,
      status: clearStatus ? null : status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
