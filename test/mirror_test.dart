import 'package:fl_mirror/src/mirror.dart';
import 'package:test/test.dart';

void main() {
  group('MirrorSuccess', () {
    test('equality and value', () {
      final a = MirrorSuccess<int>(42);
      final b = MirrorSuccess<int>(42);
      final c = MirrorSuccess<int>(100);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
      expect(a == c, isFalse);
      expect(a.isSuccess, isTrue);
      expect(a.isFailure, isFalse);
      expect(a.valueOrNull, 42);
      expect(a.errorOrNull, isNull);
    });

    test('fold returns correct value', () {
      final a = MirrorSuccess<int>(42);
      final result = a.fold(
        onFailure: (_) => 0,
        onSuccess: (v) => v,
      );
      expect(result, 42);
    });

    test('onSuccessDo and onFailureDo', () {
      final a = MirrorSuccess<int>(42);
      var successCalled = false;
      var failureCalled = false;

      a.onSuccessDo((_) => successCalled = true);
      a.onFailureDo((_) => failureCalled = true);

      expect(successCalled, isTrue);
      expect(failureCalled, isFalse);
    });

    test('delay returns same instance', () async {
      final success = MirrorSuccess<int>(7);
      final delayed = await success.delay(Duration(milliseconds: 10));
      expect(delayed, success);
    });
  });

  group('MirrorFailure', () {
    test('equality and error', () {
      final a = MirrorFailure<int>('error');
      final b = MirrorFailure<int>('error');
      final c = MirrorFailure<int>('other error');

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
      expect(a == c, isFalse);
      expect(a.isSuccess, isFalse);
      expect(a.isFailure, isTrue);
      expect(a.valueOrNull, isNull);
      expect(a.errorOrNull, 'error');
    });

    test('fold returns correct error result', () {
      final a = MirrorFailure<int>('fail');
      final result = a.fold(
        onFailure: (_) => 'fail',
        onSuccess: (v) => 'ok',
      );
      expect(result, 'fail');
    });

    test('onSuccessDo and onFailureDo', () {
      final a = MirrorFailure<int>('fail');
      var successCalled = false;
      var failureCalled = false;

      a.onSuccessDo((_) => successCalled = true);
      a.onFailureDo((_) => failureCalled = true);

      expect(successCalled, isFalse);
      expect(failureCalled, isTrue);
    });
  });

  group('Mirror', () {
    test('map and recover work correctly', () {
      final success = MirrorSuccess<int>(5);
      final failure = MirrorFailure<int>('error');

      final mappedSuccess = success.map((v) => v * 2);
      expect(mappedSuccess, MirrorSuccess<int>(10));

      final mappedFailure = failure.map((v) => v * 2);
      expect(mappedFailure, failure);

      final recovered = failure.recover((e) => 0);
      expect(recovered, MirrorSuccess<int>(0));
    });
  });
}
