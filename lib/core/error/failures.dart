abstract class Failure {
  const Failure({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.code,
    required super.message,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.code,
    required super.message,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.code,
    required super.message,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.code = 'unknown',
    super.message = 'An unknown error occurred',
  });
}
