import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException;

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/register_result_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  String _mapAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('already registered') || lower.contains('already exists')) {
      return 'This email is already registered.';
    }
    if (lower.contains('signups not allowed for otp') ||
        lower.contains('user not found') ||
        lower.contains('signup disabled')) {
      return 'No account found for this email.';
    }
    if (lower.contains('token') || lower.contains('otp') || lower.contains('expired')) {
      return 'Invalid or expired OTP code.';
    }
    if (lower.contains('password')) {
      return 'Password is too weak. Please use at least 8 characters.';
    }
    if (lower.contains('network') || lower.contains('socket')) {
      return 'Network error. Please check your internet connection.';
    }
    return message;
  }

  String _mapGenericError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('otp verification failed')) {
      return 'Invalid or expired OTP code.';
    }
    return error.toString();
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return Error(AuthFailure(message: _mapAuthError(e.message)));
    } on PostgrestException catch (e) {
      return Error(ServerFailure(message: e.message));
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<RegisterResultEntity>> register({
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
      final model = await _remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        companyName: companyName,
        jobTitle: jobTitle,
        country: country,
        city: city,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return Error(AuthFailure(message: _mapAuthError(e.message)));
    } on PostgrestException catch (e) {
      return Error(ServerFailure(message: e.message));
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Success(null);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: _mapAuthError(e.message)));
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final model = _remoteDataSource.getCurrentUser();
      return Success(model?.toEntity());
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Success(null);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: _mapAuthError(e.message)));
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> sendEmailOtp({required String email}) async {
    try {
      await _remoteDataSource.sendEmailOtp(email: email);
      return const Success(null);
    } on AuthException catch (e) {
      return Error(AuthFailure(message: _mapAuthError(e.message)));
    } catch (e) {
      return Error(UnexpectedFailure(message: _mapGenericError(e)));
    }
  }

  @override
  Future<Result<UserEntity>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final model = await _remoteDataSource.verifyEmailOtp(
        email: email,
        otp: otp,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return Error(AuthFailure(message: _mapAuthError(e.message)));
    } catch (e) {
      return Error(UnexpectedFailure(message: _mapGenericError(e)));
    }
  }
}
