import '../fl_mirror.dart';

/// Levels of severity for failures.
enum FailureLevel {
  info, // Informational only
  warning, // Non-critical, recoverable
  error, // Standard error
  critical, // Severe issue, might require immediate attention
}

/// Abstract base class for all failure types.
///
/// Use this class as a base for domain-specific or technical failure types.
/// It provides value equality and common fields for displaying and logging errors.
abstract class Failure extends Mirrorable {
  /// Human-readable error message for logs or UI.
  final String message;

  /// Optional error code (HTTP status code, DB error code, etc.).
  final int? code;

  /// The severity level of the failure.
  final FailureLevel level;

  /// A short hint to be shown to users, like actionable advice.
  final String? hint;

  /// Where the error originated (e.g., "Server", "Cache", "Validation").
  final String? source;

  /// Optional stack trace for debugging.
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.level = FailureLevel.error,
    this.hint,
    this.source,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, level, hint, source];

  @override
  String toString() =>
      'Failure(message: $message, code: $code, level: $level, hint: $hint, source: $source)';
}

/// Represents a failure that occurred on the server or backend.
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'A server error occurred.',
    super.hint = 'Try again later.',
    super.code = 500,
    super.level = FailureLevel.error,
    super.source = 'Server',
    super.stackTrace,
  });
}

/// Represents an unauthorized access failure (e.g., 401).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access.',
    super.hint = 'Please login to continue.',
    super.code = 401,
    super.level = FailureLevel.warning,
    super.source = 'Auth',
    super.stackTrace,
  });
}

/// Represents a forbidden access failure (e.g., 403).
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Access is forbidden.',
    super.hint = 'You do not have permission.',
    super.code = 403,
    super.level = FailureLevel.warning,
    super.source = 'Auth',
    super.stackTrace,
  });
}

/// Represents a failure when a resource is not found (e.g., 404).
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Requested resource not found.',
    super.hint = 'Please check and try again.',
    super.code = 404,
    super.level = FailureLevel.warning,
    super.source = 'Server',
    super.stackTrace,
  });
}

/// Represents a local (device-side) error such as file I/O or DB read/write.
class LocalFailure extends Failure {
  const LocalFailure({
    super.message = 'A local error occurred.',
    super.hint = 'Something went wrong on your device.',
    super.level = FailureLevel.error,
    super.source = 'Local',
    super.stackTrace,
    super.code,
  });
}

/// Represents an error related to local caching.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error.',
    super.hint = 'Please clear cache or restart the app.',
    super.level = FailureLevel.warning,
    super.source = 'Cache',
    super.stackTrace,
    super.code,
  });
}

/// Represents a network connection failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection.',
    super.hint = 'Please check your connection.',
    super.code = -1,
    super.level = FailureLevel.warning,
    super.source = 'Network',
    super.stackTrace,
  });
}

/// Represents a timeout from server or network.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The request timed out.',
    super.hint = 'Check your network and try again.',
    super.code = 408,
    super.level = FailureLevel.warning,
    super.source = 'Network',
    super.stackTrace,
  });
}

/// Represents an error in data formatting (e.g., invalid JSON).
class FormatFailure extends Failure {
  const FormatFailure({
    super.message = 'Data format error.',
    super.hint = 'Please contact support.',
    super.level = FailureLevel.error,
    super.source = 'Parsing',
    super.stackTrace,
    super.code,
  });
}

/// Represents invalid user input or failed validation.
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Validation failed.',
    super.hint = 'Please correct the input fields.',
    super.level = FailureLevel.info,
    super.source = 'Form',
    super.stackTrace,
    super.code,
  });
}

/// Represents a generic unknown error not categorized elsewhere.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error occurred.',
    super.hint = 'Try restarting the app or contact support.',
    super.level = FailureLevel.critical,
    super.source = 'Unknown',
    super.stackTrace,
    super.code,
  });
}

/// Represents a failure due to a conflict (e.g., 409).
class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'Conflict occurred.',
    super.hint = 'Please try again or contact support.',
    super.code = 409,
    super.level = FailureLevel.warning,
    super.source = 'Server',
    super.stackTrace,
  });
}

/// Represents a failure due to bad request (e.g., 400).
class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request.',
    super.hint = 'Please check your data and try again.',
    super.code = 400,
    super.level = FailureLevel.warning,
    super.source = 'Client',
    super.stackTrace,
  });
}

/// Represents a failure that is expected and not an actual error (e.g., empty state).
class ExpectedFailure extends Failure {
  const ExpectedFailure({
    super.message = 'No data available.',
    super.hint = 'Try refreshing the page.',
    super.level = FailureLevel.info,
    super.source = 'App',
    super.stackTrace,
    super.code,
  });
}

/// Represents a failure due to missing or denied app permissions.
///
/// Example: location, camera, storage, notifications, etc.
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied.',
    super.hint = 'Please allow permissions from the app settings.',
    super.code,
    super.level = FailureLevel.warning,
    super.source = 'Permissions',
    super.stackTrace,
  });
}

/// Represents a failure during a payment process.
///
/// Can be caused by declined cards, gateway errors, insufficient funds, etc.
class PaymentFailure extends Failure {
  const PaymentFailure({
    super.message = 'Payment could not be completed.',
    super.hint = 'Please try another payment method.',
    super.code,
    super.level = FailureLevel.error,
    super.source = 'Payment',
    super.stackTrace,
  });
}

/// Represents a failure related to the device or hardware.
///
/// Example: sensor failure, battery issue, OS-specific problems.
class DeviceFailure extends Failure {
  const DeviceFailure({
    super.message = 'Device error occurred.',
    super.hint = 'Restart the app or device.',
    super.code,
    super.level = FailureLevel.error,
    super.source = 'Device',
    super.stackTrace,
  });
}
