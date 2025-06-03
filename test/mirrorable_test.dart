import 'package:fl_mirror/fl_mirror.dart';
import 'package:test/test.dart';

void main() {
  group('Mirrorable', () {
    test('equality and hashCode', () {
      final a = TestMirrorable(1, 'x');
      final b = TestMirrorable(1, 'x');
      final c = TestMirrorable(2, 'y');

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
      expect(a == c, isFalse);
    });

    test('toString includes props', () {
      final a = TestMirrorable(1, 'x');
      expect(a.toString(), 'TestMirrorable(1, x)');
    });

    test('throws on empty props', () {
      expect(() => EmptyProps().hashCode, throwsA(isA<AssertionError>()));
      expect(
          () => EmptyProps() == EmptyProps(), throwsA(isA<AssertionError>()));
    });

    test('throws on duplicate props', () {
      expect(() => DuplicateProps(1).hashCode, throwsA(isA<AssertionError>()));
      expect(() => DuplicateProps(1) == DuplicateProps(1),
          throwsA(isA<AssertionError>()));
    });
  });
}

class TestMirrorable extends Mirrorable {
  final int id;
  final String name;

  TestMirrorable(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

class EmptyProps extends Mirrorable {
  @override
  List<Object?> get props => [];
}

class DuplicateProps extends Mirrorable {
  final int id;

  DuplicateProps(this.id);

  @override
  List<Object?> get props => [id, id];
}
