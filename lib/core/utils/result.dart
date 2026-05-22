import '../errors/failures.dart';

/// Generic result type — either a [Failure] or a success value [T].
///
/// ```dart
/// final result = await loginUseCase(params);
/// result.fold(
///   (failure) => showError(failure.message),
///   (user)    => navigateToDashboard(),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Apply [onFailure] if this is an error, or [onSuccess] if this is data.
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  );

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;
}

/// Successful result wrapping [data].
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) => onSuccess(data);
}

/// Failed result wrapping a [Failure].
class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) => onFailure(failure);
}
