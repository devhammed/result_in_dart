part of result_in_dart;

extension FlattenResult<T, E> on Result<Result<T, E>, E> {
  /// Converts from [Result<Result<T, E>, E>] to [Result<T, E>]
  Result<T, E> flatten() => andThen((value) => value);
}
