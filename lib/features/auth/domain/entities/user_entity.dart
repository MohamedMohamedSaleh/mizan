import 'package:equatable/equatable.dart';

/// Pure domain entity representing an authenticated user.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.businessName,
    this.phoneNumber,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? fullName;
  final String? businessName;
  final String? phoneNumber;
  final String? avatarUrl;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        businessName,
        phoneNumber,
        avatarUrl,
        createdAt,
      ];
}
