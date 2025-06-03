# fl_mirror

A robust Dart utility package for representing and handling operation results, failures, and value equality with ease.

---

![null safety](https://img.shields.io/badge/null%20safety-✅-blue)
[![build](https://github.com/Mbouziani/fl_mirror/actions/workflows/test.yml/badge.svg)](https://github.com/Mbouziani/fl_mirror/actions)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## ✨ Features

- `Mirror<T>`: A generic container to represent either a successful result (`MirrorSuccess`) or a failure (`MirrorFailure`), enabling functional-style handling of success/failure without exceptions.
- `Failure` hierarchy: Rich set of failure types (e.g., `ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, ...) with severity levels, error codes, hints, and stack traces for detailed error management.
- `Mirrorable` base class: Implements value equality based on specified properties (`props`), with validation to ensure correctness. A lightweight alternative to packages like `equatable`.
- 🧪 Utilities for:
  - Mapping, recovering, and delaying asynchronous or synchronous results.
  - Easily branching logic based on success or failure outcomes.
  - Clean and consistent error classification for server, network, cache, local, and authorization issues.
- 🧪 Fully testable.
  
---

## 🛠️ Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  fl_mirror: ^1.0.0
```

Then run:

```bash
dart pub get
```

## 🚀 Getting Started

### 1. Handling success and failure with `Mirror<T>`

```dart
  Mirror<int> result = MirrorSuccess(42);

  result.fold(
    onSuccess: (value) => print('Success: $value'),
    onFailure: (error) => print('Failure: $error'),
  );

```

### 2. Defining and using failures

```dart
  void handleFailure(Failure failure) {
    print('Error: ${failure.message}');
    if (failure.hint != null) {
      print('Hint: ${failure.hint}');
    }
  }
  
  // Example usage
  final failure = ServerFailure();
  handleFailure(failure);
  // Output:
  // Error: A server error occurred.
  // Hint: Try again later.
```

### 3. Creating value objects with `Mirrorable`

```dart
class Person extends Mirrorable {
  final int id;
  final String name;

  Person(this.id, this.name);

  @override
  List<Object?> get props => [id, name];
}

void main() {
  final a = Person(1, 'Alice');
  final b = Person(1, 'Alice');

  print(a == b); // true
  print(a.hashCode == b.hashCode); // true
  print(a); // Person(1, Alice)
}
```

## 👁️ API Overview

### `Mirror<T>`

- `MirrorSuccess<T>(value)` — success container.
- `MirrorFailure<T>(error)` — failure container.
- `fold()`, `map()`, `recover()`, `delay()`, `onSuccessDo()`, `onFailureDo()` — utilities for functional handling.

### `Failure` and subclasses

- Base class with message, code, level, hint, source, stackTrace.
- Predefined subclasses:
  - `ServerFailure`
  - `UnauthorizedFailure`
  - `ForbiddenFailure`
  - `NotFoundFailure`
  - `LocalFailure`
  - `CacheFailure`
  - `NetworkFailure`
  - `TimeoutFailure`

### `Mirrorable`

- Abstract base class for value equality.
- Enforces non-empty and unique props.
- Provides ==, hashCode, and toString() implementations.

---

## ❓ Why use this package ?

- Avoid exceptions: Handle success and failure explicitly and safely.
- Consistent failure handling: Use predefined failure types with detailed info.
- Simplify equality: Easily implement value objects without boilerplate.
- Functional style: Fluent API for transforming and recovering from failures.

---

## 📦 Contributing

Contributions and suggestions are welcome! Feel free to open issues or pull requests.

---

## 📁 Example

See [`example/main.dart`](example/main.dart) for a working login use case.

## 🧪 Tests

Run tests using:

```bash
dart test
```

## 📄 License

This project is licensed under the [MIT License](LICENSE).
