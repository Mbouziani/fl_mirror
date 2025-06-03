import 'package:fl_mirror/fl_mirror.dart'; // Update to your actual import
import 'package:test/test.dart';

void main() {
  group('Failure subclasses', () {
    test('ServerFailure defaults are correct', () {
      const failure = ServerFailure();
      expect(failure.message, 'A server error occurred.');
      expect(failure.code, 500);
      expect(failure.level, FailureLevel.error);
      expect(failure.source, 'Server');
    });

    test('UnauthorizedFailure defaults are correct', () {
      const failure = UnauthorizedFailure();
      expect(failure.message, 'Unauthorized access.');
      expect(failure.code, 401);
      expect(failure.hint, 'Please login to continue.');
    });

    test('ValidationFailure with custom message', () {
      const failure = ValidationFailure(message: 'Invalid name');
      expect(failure.message, 'Invalid name');
      expect(failure.level, FailureLevel.info);
    });

    test('TimeoutFailure level and source', () {
      const failure = TimeoutFailure();
      expect(failure.level, FailureLevel.warning);
      expect(failure.source, 'Network');
    });

    test('PermissionFailure values', () {
      const failure = PermissionFailure();
      expect(failure.source, 'Permissions');
      expect(failure.hint, 'Please allow permissions from the app settings.');
    });

    test('Equality works correctly for same values', () {
      const f1 = NetworkFailure(message: 'Net issue');
      const f2 = NetworkFailure(message: 'Net issue');
      expect(f1 == f2, true);
    });

    test('toString is formatted correctly', () {
      const failure = ConflictFailure();
      expect(failure.toString(), contains('Conflict occurred'));
    });
  });
}
