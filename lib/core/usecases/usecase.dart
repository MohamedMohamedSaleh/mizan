import '../utils/result.dart';

/// Base class for all use cases.
///
/// [T] is the return type, [P] is the params type.
/// Use [NoParams] when the use case takes no arguments.
abstract class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

/// Marker class for use cases that don't need parameters.
class NoParams {
  const NoParams();
}
