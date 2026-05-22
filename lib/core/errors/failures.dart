import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer.
///
/// All specific failures extend this. Used as the "left" side
/// of result types to represent error cases without exceptions.
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// A failure originating from the server / remote API.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// A failure originating from local cache / database.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// A failure due to no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// A failure from Supabase Auth operations.
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// A generic / unexpected failure.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred'});
}
