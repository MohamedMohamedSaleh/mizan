import '../../../../core/utils/result.dart';
import '../entities/register_result_entity.dart';
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
  Future<Result<RegisterResultEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String companyName,
    required String jobTitle,
    required String country,
    required String city,
  });

  /// Sign out the current user.
  Future<Result<void>> logout();

  /// Get the currently authenticated user, or null.
  Future<Result<UserEntity?>> getCurrentUser();

  /// Send a password-reset email.
  Future<Result<void>> forgotPassword({required String email});

  /// Send email OTP for existing users only.
  Future<Result<void>> sendEmailOtp({required String email});

  /// Verify email OTP code and return authenticated user.
  Future<Result<UserEntity>> verifyEmailOtp({
    required String email,
    required String otp,
  });

  Future<Result<UserEntity>> verifyRegisterOtp({
    required String email,
    required String otp,
  });

  Future<Result<void>> resendRegisterOtp({required String email});

  Future<Result<void>> upsertProfile({
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
