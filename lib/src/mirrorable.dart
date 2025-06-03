// lib/mirrorable.dart

/// A base class that provides value equality based on the fields
/// listed in [props]. Extend this in your data classes to
/// get `==` and `hashCode` implementations automatically.
///
/// This is similar to `Equatable` but with validation to ensure
/// that [props] is not empty and contains no duplicates.
///
/// Throws an [AssertionError] if [props] is empty or
/// contains duplicate entries.
///
/// Example usage:
/// ```dart
/// class Person extends Mirrorable {
///   final int id;
///   final String name;
///
///   Person(this.id, this.name);
///
///   @override
///   List<Object?> get props => [id, name];
/// }
///
/// void main() {
///   final a = Person(1, 'Alice');
///   final b = Person(1, 'Alice');
///   print(a == b); // true
///   print(a.hashCode == b.hashCode); // true
///   print(a); // Person(1, Alice)
/// }
/// ```
abstract class Mirrorable {
  const Mirrorable(); // Add this

  /// Override this getter to list all fields that should be
  /// considered for equality and hashCode.
  List<Object?> get props;

  /// Validates that [props] is not empty and contains no duplicates.
  void _validateProps() {
    assert(
      props.isNotEmpty,
      'Mirrorable: props cannot be empty. You must override props getter.',
    );
    final duplicates = _findDuplicates(props);
    assert(
      duplicates.isEmpty,
      'Mirrorable: props contains duplicate fields: $duplicates',
    );
  }

  /// Helper method to find duplicates in a list.
  List<Object?> _findDuplicates(List<Object?> list) {
    final seen = <Object?>{};
    final duplicates = <Object?>[];
    for (final item in list) {
      if (!seen.add(item)) {
        duplicates.add(item);
      }
    }
    return duplicates;
  }

  @override
  bool operator ==(Object other) {
    _validateProps();
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is Mirrorable) {
      if (props.length != other.props.length) return false;
      for (int i = 0; i < props.length; i++) {
        if (props[i] != other.props[i]) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode {
    _validateProps();
    int result = 17;
    for (final prop in props) {
      result = 37 * result + (prop?.hashCode ?? 0);
    }
    return result;
  }

  @override
  String toString() {
    _validateProps();
    return '$runtimeType(${props.join(", ")})';
  }
}
