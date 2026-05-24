import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException;

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';

Future<Result<T>> guardExpenseRepositoryCall<T>(
  Future<T> Function() operation,
) async {
  try {
    return Success(await operation());
  } on Failure catch (failure) {
    return Error(failure);
  } on AuthException catch (error) {
    return Error(AuthFailure(message: error.message));
  } on PostgrestException catch (error) {
    return Error(ServerFailure(message: error.message));
  } catch (error) {
    return Error(UnexpectedFailure(message: error.toString()));
  }
}
