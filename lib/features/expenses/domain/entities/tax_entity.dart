import 'package:equatable/equatable.dart';

class TaxEntity extends Equatable {
  const TaxEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.rate,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String name;
  final double rate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  TaxEntity copyWith({
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
    return TaxEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        rate,
        isActive,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
