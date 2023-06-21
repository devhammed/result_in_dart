part of result_in_dart;

/// [Err] is a type that represents failure and contains a [E] type error value.
class Err<T, E> extends Result<T, E> {
  const Err(this.value);

  final E value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Err<T, E> && other.value == value;
  }

  @override
  int get hashCode => Object.hash('Err()', value);

  @override
  String toString() => 'Err(${value.toString()})';
}
