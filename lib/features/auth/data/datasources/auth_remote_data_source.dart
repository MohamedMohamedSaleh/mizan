import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

/// Contract for remote auth operations.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String businessName,
    required String phoneNumber,
  });
  Future<void> logout();
  UserModel? getCurrentUser();
  Future<void> forgotPassword({required String email});
}

/// Implementation backed by Supabase Auth.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);
  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Login failed: no user returned');
    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String businessName,
    required String phoneNumber,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'business_name': businessName,
        'phone_number': phoneNumber,
      },
    );
    final user = response.user;
    if (user == null) throw Exception('Registration failed: no user returned');
    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _auth.resetPasswordForEmail(email);
  }
}
