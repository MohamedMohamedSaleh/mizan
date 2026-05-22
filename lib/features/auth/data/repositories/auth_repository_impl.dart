import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Concrete implementation of [AuthRepository].
///
/// Catches exceptions from [AuthRemoteDataSource] and wraps them
/// into [Result] with proper [Failure] types.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

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
      return Error(AuthFailure(message: e.message));
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String businessName,
    required String phoneNumber,
  }) async {
    try {
      final model = await _remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
        businessName: businessName,
        phoneNumber: phoneNumber,
      );
      return Success(model.toEntity());
    } on AuthException catch (e) {
      return Error(AuthFailure(message: e.message));
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
      return Error(AuthFailure(message: e.message));
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
      return Error(AuthFailure(message: e.message));
    } catch (e) {
      return Error(UnexpectedFailure(message: e.toString()));
    }
  }
}
