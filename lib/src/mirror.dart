// lib/mirror.dart

/// A generic result container that holds either a success value of type [T] or an error.
///
/// Use [MirrorSuccess] for successful results,
/// and [MirrorFailure] for failures.
///
/// This class provides convenient methods to work with asynchronous or synchronous
/// operations that can either succeed or fail, without using exceptions.
///
/// Example usage:
/// ```dart
/// Mirror<int> success = MirrorSuccess(42);
/// Mirror<int> failure = MirrorFailure('Error occurred');
///
/// success.fold(
///   onSuccess: (value) => print('Success: $value'),
///   onFailure: (error) => print('Failure: $error'),
/// );
///
/// failure.fold(
///   onSuccess: (value) => print('Success: $value'),
///   onFailure: (error) => print('Failure: $error'),
/// );
/// ```
abstract class Mirror<T> {
  const Mirror();

  /// Returns true if this instance represents a successful result.
  bool get isSuccess => this is MirrorSuccess<T>;

  /// Returns true if this instance represents a failure.
  bool get isFailure => this is MirrorFailure<T>;

  /// Applies [onSuccess] if this is a success,
  /// or [onFailure] if this is a failure, returning a value of type [R].
  ///
  /// This method lets you destructure the result easily.
  R fold<R>({
    required R Function(Object error) onFailure,
    required R Function(T value) onSuccess,
  }) {
    if (this is MirrorSuccess<T>) {
      return onSuccess((this as MirrorSuccess<T>).value);
    } else if (this is MirrorFailure<T>) {
      return onFailure((this as MirrorFailure<T>).error);
    } else {
      throw StateError('Invalid Mirror state');
    }
  }

  /// Executes the provided [fn] callback if this is a success.
  ///
  /// Useful for side-effects on success.
  void onSuccessDo(void Function(T value) fn) {
    if (this is MirrorSuccess<T>) fn((this as MirrorSuccess<T>).value);
  }

  /// Executes the provided [fn] callback if this is a failure.
  ///
  /// Useful for side-effects on failure.
  void onFailureDo(void Function(Object error) fn) {
    if (this is MirrorFailure<T>) fn((this as MirrorFailure<T>).error);
  }

  /// Returns the success value or null if this is a failure.
  T? get valueOrNull => isSuccess ? (this as MirrorSuccess<T>).value : null;

  /// Returns the error or null if this is a success.
  Object? get errorOrNull =>
      isFailure ? (this as MirrorFailure<T>).error : null;

  /// Transforms the success value using [transform], or returns the failure unchanged.
  ///
  /// This lets you chain operations that transform the result without unwrapping manually.
  Mirror<R> map<R>(R Function(T value) transform) {
    return isSuccess
        ? MirrorSuccess<R>(transform((this as MirrorSuccess<T>).value))
        : MirrorFailure<R>((this as MirrorFailure<T>).error);
  }

  /// Recovers from failure by transforming the error into a success value using [recoverFn].
  ///
  /// If this instance is a failure, applies [recoverFn] to the error and wraps the result
  /// in a new success. If this instance is a success, returns itself.
  Mirror<T> recover(T Function(Object error) recoverFn) {
    return isFailure
        ? MirrorSuccess<T>(recoverFn((this as MirrorFailure<T>).error))
        : this;
  }

  /// Returns a Future that completes with this Mirror after a delay of [duration].
  ///
  /// Useful for simulating delayed async operations or throttling.
  Future<Mirror<T>> delay(Duration duration) async {
    await Future.delayed(duration);
    return this;
  }
}

/// Represents a successful result containing a value of type [T].
class MirrorSuccess<T> extends Mirror<T> {
  /// The successful value.
  final T value;

  /// Creates a new success instance containing the given [value].
  const MirrorSuccess(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MirrorSuccess<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MirrorSuccess($value)';
}

/// Represents a failure result containing an error.
///
/// The [error] can be any object describing the failure.
class MirrorFailure<T> extends Mirror<T> {
  /// The error describing the failure.
  final Object error;

  /// Creates a new failure instance containing the given [error].
  const MirrorFailure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MirrorFailure<T> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'MirrorFailure($error)';
}
