abstract class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.cause,
  });

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class NetworkException extends AppException {
  const NetworkException({
    required super.code,
    required super.message,
    super.cause,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.code,
    required super.message,
    super.cause,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.code,
    required super.message,
    super.cause,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.code = 'unknown',
    super.message = 'An unknown error occurred',
    super.cause,
  });
}
