import '../../../../core/utils/result.dart';

abstract class AccountingSeedService {
  /// Seeds default accounting data for the current authenticated user.
  ///
  /// Returns `true` when seed data was created, or `false` when the user
  /// already has active accounts and no seed was needed.
  Future<Result<bool>> seedForCurrentUserIfNeeded();
}
