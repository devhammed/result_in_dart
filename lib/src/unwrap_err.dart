part of result_in_dart;

/// Error thrown by the runtime system when `unwrap` fails.
class ResultUnwrapError extends Error {
  ResultUnwrapError(
    this.message, {
    this.obj,
  });

  final String message;
  final Object? obj;

  @override
  String toString() => obj != null ? '$message: $obj' : message;
}
