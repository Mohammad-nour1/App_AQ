import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Object e) {
  if (e is Failure) return e;
  if (e is NetworkException) {
    return NetworkFailure(code: e.code, message: e.message);
  }
  if (e is CacheException) {
    return CacheFailure(code: e.code, message: e.message);
  }
  if (e is ValidationException) {
    return ValidationFailure(code: e.code, message: e.message);
  }
  if (e is AppException) {
    return UnknownFailure(code: e.code, message: e.message);
  }
  return UnknownFailure(message: e.toString());
}
