import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  const VendorEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.taxNumber,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxNumber;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VendorEntity copyWith({
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
    return VendorEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        phone,
        email,
        address,
        taxNumber,
        notes,
        status,
        createdAt,
        updatedAt,
      ];
}
