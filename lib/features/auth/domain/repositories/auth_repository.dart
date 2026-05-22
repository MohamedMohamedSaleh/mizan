import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// Abstract contract for authentication operations.
///
/// Implemented by [AuthRepositoryImpl] in the data layer.
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  /// Create a new account.
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String businessName,
    required String phoneNumber,
  });

  /// Sign out the current user.
  Future<Result<void>> logout();

  /// Get the currently authenticated user, or null.
  Future<Result<UserEntity?>> getCurrentUser();

  /// Send a password-reset email.
  Future<Result<void>> forgotPassword({required String email});
}
