import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../domain/entities/user_entity.dart';

/// Data model that maps between Supabase [sb.User] and [UserEntity].
class UserModel {
  const UserModel({
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

  /// Create from a Supabase [sb.User].
  factory UserModel.fromSupabaseUser(sb.User user) {
    final meta = user.userMetadata;
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: meta?['full_name'] as String?,
      businessName: (meta?['company_name'] ?? meta?['business_name']) as String?,
      phoneNumber: (meta?['phone'] ?? meta?['phone_number']) as String?,
      avatarUrl: meta?['avatar_url'] as String?,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  /// Convert to a pure domain entity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      businessName: businessName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
}
