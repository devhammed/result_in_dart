part of dart_rs;

/// [Ok] is a type that represents success and contains a [T] type success
/// value.
class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Ok<T, E> && other.value == value;
  }

  @override
  int get hashCode => Object.hash('Ok()', value);

  @override
  String toString() => 'Ok(${value.toString()})';
}
