import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../services/accounting_seed_service.dart';

class SeedAccountingDataUseCase extends UseCase<bool, NoParams> {
  SeedAccountingDataUseCase(this._seedService);

  final AccountingSeedService _seedService;

  @override
  Future<Result<bool>> call(NoParams params) {
    return _seedService.seedForCurrentUserIfNeeded();
  }
}
