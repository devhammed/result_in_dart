part of dart_result;

/// Default result class.
class Default {
  static T get<T, E>(Result<T, E> result) {
    if (result.isOk()) {
      return result.okValue;
    }

    switch (T) {
      case int:
        return 0 as T;
      case double:
        return 0.0 as T;
      case String:
        return '' as T;
      case bool:
        return false as T;
      case List:
        return [] as T;
      case Map:
        return {} as T;
      case Set:
        return <dynamic>{} as T;
      case BigInt:
        return BigInt.zero as T;
      case DateTime:
        return DateTime.now() as T;
      case Duration:
        return Duration.zero as T;
      case RegExp:
        return RegExp('') as T;
      case Uri:
        return Uri() as T;
      default:
        throw ArgumentError(
          'Type $T is not supported, please use unwrapOr or unwrapOrElse.',
          T.toString(),
        );
    }
  }
}
