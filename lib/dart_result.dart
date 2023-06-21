/// Dart implementation of Rust's [Result] type.
///
/// [Result<T, E>] is the type used for returning and propagating
/// errors. It is a class with the two variants, [Ok(T)] and [Err(E)].
/// where [T] is the type of a successful value and [E] is the type of an error.
///
/// Loosely based on https://doc.rust-lang.org/src/core/result.rs.html source code.
library dart_result;

/// Includes all the [Result] classes.
part 'src/ok.dart';
part 'src/err.dart';
part 'src/default.dart';
part 'src/extensions.dart';
part 'src/unwrap_err.dart';

/// [Result] is a type that represents either success [Ok] or failure [Err].
abstract class Result<T, E> {
  /// Default constructor.
  const Result();

  /// Cast this [Result] to [Ok].
  Ok<T, E> get asOk => this as Ok<T, E>;

  /// Cast this [Result] to [Err].
  Err<T, E> get asErr => this as Err<T, E>;

  /// Get the contained [Ok] value, if [Ok], otherwise it throws an error.
  T get okValue => asOk.value;

  /// Get the contained [Err] value, if [Err], otherwise it throws an error.
  E get errValue => asErr.value;

  /// Returns `true` if the result is [Ok].
  bool isOk() => this is Ok<T, E>;

  /// Returns [true] if the result is [Ok] and the value inside of it matches a predicate.
  bool isOkAnd(bool Function(T value) f) => isOk() && f(okValue);

  /// Returns `true` if the result is [Err].
  bool isErr() => !isOk();

  /// Returns [true] if the result is [Err] and the value inside of it matches a predicate.
  bool isErrAnd(bool Function(E err) f) => isErr() && f(errValue);

  /// Converts from `Result<T, E>` to `T?`.
  ///
  /// Converts `this` into a nullable value, consuming `this`,
  /// and discarding the error, if any.
  T? ok() => isOk() ? okValue : null;

  /// Converts from `Result<T, E>` to `E?`.
  ///
  /// Converts `this` into a nullable value, consuming `this`,
  /// and discarding the success value, if any.
  E? err() => isOk() ? null : errValue;

  /// Maps a `Result<T, E>` to `Result<U, E>` by applying [op] function to a
  /// contained [Ok] value, leaving an [Err] value untouched.
  ///
  /// This function can be used to compose the results of two functions.
  Result<U, E> map<U>(U Function(T value) op) =>
      isOk() ? Ok(op(okValue)) : Err(errValue);

  /// Returns the provided default (if [Err]), or
  /// applies [f] function to the contained value (if [Ok]),
  ///
  /// Arguments passed to [mapOr] are eagerly evaluated; if you are passing
  /// the result of a function call, it is recommended to use [mapOrElse],
  /// which is lazily evaluated.
  U mapOr<U>(U defaultValue, U Function(T value) f) =>
      isOk() ? f(okValue) : defaultValue;

  /// Maps a [Result<T, E>] to [U] by applying fallback function [defaultF] to
  /// a contained [Err] value, or function [f] to a contained [Ok] value.
  ///
  /// This function can be used to unpack a successful result
  /// while handling an error.
  U mapOrElse<U>(U Function(E err) defaultF, U Function(T value) f) =>
      isOk() ? f(okValue) : defaultF(errValue);

  /// Maps a [Result<T, E>] to [Result<T, F>] by applying [op] function to a
  /// contained [Err] value, leaving an [Ok] value untouched.
  ///
  /// This function can be used to pass through a successful result while
  /// handling an error.
  Result<T, F> mapErr<F>(F Function(E err) op) =>
      isOk() ? Ok(okValue) : Err(op(errValue));

  /// Calls the provided closure with a reference to the contained value (if [Ok]).
  Result<T, E> inspect(void Function(T value) f) {
    if (isOk()) {
      f(okValue);
    }

    return this;
  }

  /// Calls the provided closure with a reference to the contained error (if [Err]).
  Result<T, E> inspectErr(void Function(E err) f) {
    if (isErr()) {
      f(errValue);
    }

    return this;
  }

  /// Returns an iterable over the possibly contained value.
  ///
  /// The iterable yields one value if the result is [Ok], otherwise none.
  Iterable<T> iter() => isOk() ? [okValue] : const [];

  /// Returns the contained [Ok] value, consuming the `this` value.
  ///
  /// Throws an error if the value is an [Err], with an error message including
  /// the passed message, and the content of the [Err].
  T expect(String msg) =>
      isOk() ? okValue : throw ResultUnwrapError(msg, obj: errValue);

  /// Returns the contained [Ok] value, consuming the `this` value.
  ///
  /// Because this function may throw an error, its use is generally
  /// discouraged.
  /// Instead, prefer to handle the [Err] case explicitly,
  /// or call [unwrapOr] or [unwrapOrElse].
  T unwrap() => isOk()
      ? okValue
      : throw ResultUnwrapError(
          'called `Result#unwrap` on an `Err` value',
          obj: errValue,
        );

  /// Returns the contained [Ok] value or a default.
  T unwrapOrDefault() => Default.get<T, E>(this);

  /// Returns the contained [Err] value, consuming the `this` value.
  ///
  /// Throw an error if the value is an [Ok], with an error message including
  /// the passed message, and the content of the [Ok].
  E expectErr(String msg) =>
      isOk() ? throw ResultUnwrapError(msg, obj: okValue) : errValue;

  /// Returns the contained [Err] value, consuming the `this` value.
  ///
  /// Exceptions if the value is an [Ok], with a custom error message provided
  /// by the [Ok]'s value.
  E unwrapErr() => isOk()
      ? throw ResultUnwrapError(
          'called `Result#unwrapErr` on an `Ok` value',
          obj: okValue,
        )
      : errValue;

  /// Returns [res] if the result is [Ok], otherwise returns the [Err] value of
  /// [this].
  Result<U, E> and<U>(Result<U, E> res) => isOk() ? res : Err(errValue);

  /// Calls [op] if the result is [Ok], otherwise returns the [Err] value of
  /// [Result].
  ///
  /// This function can be used for control flow based on [Result] values.
  Result<U, E> andThen<U>(Result<U, E> Function(T value) op) =>
      isOk() ? op(okValue) : Err(errValue);

  /// Returns [res] if the result is [Err], otherwise returns the [Ok] value of
  /// [this].
  ///
  /// Arguments passed to [or] are eagerly evaluated; if you are passing the
  /// result of a function call, it is recommended to use [orElse], which is
  /// lazily evaluated.
  Result<T, F> or<F>(Result<T, F> res) => isOk() ? Ok(okValue) : res;

  /// Calls [op] if the result is [Err], otherwise returns the [Ok] value of
  /// [Result].
  ///
  /// This function can be used for control flow based on result values.
  Result<T, F> orElse<F>(Result<T, F> Function(E err) op) =>
      isOk() ? Ok(okValue) : op(errValue);

  /// Returns the contained [Ok] value or a provided default.
  ///
  /// Arguments passed to [unwrapOr] are eagerly evaluated; if you are passing
  /// the result of a function call, it is recommended to use
  /// [unwrapOrElse], which is lazily evaluated.
  T unwrapOr(T defaultValue) => isOk() ? okValue : defaultValue;

  /// Returns the contained [Ok] value or computes it from a closure.
  T unwrapOrElse(T Function(E err) op) => isOk() ? okValue : op(errValue);

  /// Shortcut to call [Result.unwrap()].
  ///
  /// This is as close to analogous to Rust's `?` postfix operator for `Result`
  /// values as Dart can manage.
  ///
  /// ```dart
  /// final foo = Ok(1);
  /// final bar = Ok(2);
  ///
  /// print(~foo + ~bar); // prints: 3
  /// ```
  ///
  /// **Note**: if you need to access fields or methods on the held value when
  /// using `~`, you'll need to use parentheses like so:
  ///
  /// ```dart
  /// final res = Ok(1);
  ///
  /// print((~res).toString());
  /// ```
  ///
  /// Additionally, If you need to perform a bitwise NOT on the held value of
  /// a [Result], you have a few choices:
  ///
  /// ```dart
  /// final res = Ok(1);
  ///
  /// print(~(~res)); // prints: -2
  /// print(~~res); // prints: -2
  /// print(~res.unwrap()); // prints: -2;
  /// ```
  T operator ~() => unwrap();
}
