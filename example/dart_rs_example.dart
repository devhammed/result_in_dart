import 'package:dart_rs/dart_rs.dart';

enum Version {
  version1,
  version2;
}

Result<Version, String> parseVersion(int versionNum) {
  if (versionNum == 1) {
    return const Ok(Version.version1);
  }

  if (versionNum == 2) {
    return const Ok(Version.version2);
  }

  return const Err('invalid version');
}

void main() {
  final version = parseVersion(3);

  // you can then unwrap...
  if (version.isOk()) {
    print('unwrap: working with version: ${version.unwrap()}');
  } else {
    print('unwrap: error parsing header: ${version.unwrapErr()}');
  }

  // or mapping...
  parseVersion(1).mapOrElse(
    (err) => print('mapOrElse: error parsing header: $err'),
    (v) => print('mapOrElse: working with version: $v'),
  );

  // or using Dart 3.0 patterns...
  if (version case Ok(value: Version v)) {
    print('patterns: working with version: $v');
  }

  if (version case Err(value: String err)) {
    print('patterns: error parsing header: $err');
  }

  // unwrapping using the ~ operator
  final a = Ok(1);
  final b = Ok(2);

  print('~ operator: ${~a + ~b}');
}
