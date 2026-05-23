import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/register_result_model.dart';
import '../models/user_model.dart';

/// Contract for remote auth operations.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<RegisterResultModel> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String companyName,
    required String jobTitle,
    required String country,
    required String city,
  });
  Future<void> logout();
  UserModel? getCurrentUser();
  Future<void> forgotPassword({required String email});
  Future<void> sendEmailOtp({required String email});
  Future<UserModel> verifyEmailOtp({required String email, required String otp});
  Future<UserModel> verifyRegisterOtp({required String email, required String otp});
  Future<void> resendRegisterOtp({required String email});
  Future<void> upsertProfile({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
    required String companyName,
    required String jobTitle,
    required String country,
    required String city,
  });
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
  Future<RegisterResultModel> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String companyName,
    required String jobTitle,
    required String country,
    required String city,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phoneNumber,
          'company_name': companyName,
          'job_title': jobTitle,
          'country': country,
          'city': city,
        },
      );
      final user = response.user;
      if (user == null)
        throw Exception('Registration failed: no user returned');
      final hasSession = response.session != null;
      final requiresEmailConfirmation = !hasSession;

    if (hasSession) {
      await upsertProfile(
        userId: user.id,
        fullName: fullName,
        email: email,
        phone: phoneNumber,
        companyName: companyName,
        jobTitle: jobTitle,
        country: country,
        city: city,
      );
    }

      return RegisterResultModel(
        user: UserModel.fromSupabaseUser(user),
        hasActiveSession: hasSession,
        requiresEmailConfirmation: requiresEmailConfirmation,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw Exception('Registration failed: $e');
    }
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

  @override
  Future<void> sendEmailOtp({required String email}) async {
    await _auth.signInWithOtp(
      email: email,
      shouldCreateUser: false,
    );
  }

  @override
  Future<UserModel> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );

    final user = response.user;
    final session = response.session;
    if (user == null || session == null) {
      throw Exception('OTP verification failed: no active session');
    }

    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<UserModel> verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.signup,
    );

    final user = response.user;
    final session = response.session;
    if (user == null || session == null) {
      throw Exception('OTP verification failed: no active session');
    }

    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<void> resendRegisterOtp({required String email}) async {
    await _auth.resend(
      email: email,
      type: OtpType.signup,
    );
  }

  @override
  Future<void> upsertProfile({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
    required String companyName,
    required String jobTitle,
    required String country,
    required String city,
  }) async {
    await _client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'company_name': companyName,
      'job_title': jobTitle,
      'country': country,
      'city': city,
    });
  }
}
