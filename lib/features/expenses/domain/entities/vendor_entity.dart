import 'package:equatable/equatable.dart';

class VendorEntity extends Equatable {
  const VendorEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    this.email,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  VendorEntity copyWith({
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
    return VendorEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        phone,
        email,
        isActive,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
