import 'package:fl_mirror/fl_mirror.dart';

void main() {
  // Example 1: Using Mirror with success and failure
  final success = MirrorSuccess<int>(10);
  final failure = MirrorFailure<int>(UnauthorizedFailure());

  success.fold(
    onSuccess: (value) => print('✅ Success value: $value'),
    onFailure: (error) => print('❌ Error: $error'),
  );

  failure.fold(
    onSuccess: (value) => print('✅ Success value: $value'),
    onFailure: (error) => print('❌ Error: $error'),
  );

  // Mapping success
  final doubled = success.map((value) => value * 2);
  print('Mapped success: $doubled');

  // Recovering from failure
  final recovered = failure.recover((_) => 0);
  print('Recovered from failure: $recovered');

  // Example 2: Using Mirrorable for equality
  const user1 = User(1, 'Alice');
  const user2 = User(1, 'Alice');
  const user3 = User(2, 'Bob');

  print('user1 == user2: ${user1 == user2}'); // true
  print('user1 == user3: ${user1 == user3}'); // false
  print(user1); // User(1, Alice)

  // Example 3: Handling a real Failure
  try {
    simulateApiCall();
  } catch (e, s) {
    final Failure failure = UnauthorizedFailure(
      message: e.toString(),
      stackTrace: s,
    );
    print('Caught failure: $failure');
    if (failure is UnauthorizedFailure) {
      print('Redirect to login page...');
    }
  }
}

// Example model that uses Mirrorable
class User extends Mirrorable {
  final int id;
  final String name;

  const User(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

// Simulated API call that throws a failure
void simulateApiCall() {
  throw const UnauthorizedFailure();
}
