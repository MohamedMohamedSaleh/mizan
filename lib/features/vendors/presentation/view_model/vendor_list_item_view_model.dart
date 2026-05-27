import 'package:equatable/equatable.dart';

import '../../../expenses/domain/entities/vendor_entity.dart';

class VendorListItemViewModel extends Equatable {
  const VendorListItemViewModel({
    required this.id,
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

  factory VendorListItemViewModel.fromEntity(VendorEntity entity) {
    return VendorListItemViewModel(
      id: entity.id,
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

  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxNumber;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
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
