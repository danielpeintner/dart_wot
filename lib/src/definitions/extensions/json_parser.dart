import '../validation/validation_exception.dart';

/// Extension for parsing fields of JSON objects.
extension ParseField on Map<String, dynamic> {
  /// Parses a single field with a given [name].
  ///
  /// Ensures that the field value is of type [T] and returns `null` if the
  /// value does not have this type or is not present.
  ///
  /// If a [Set] of [parsedFields] is passed to this function, the field [name]
  /// will added. This can be used for filtering when parsing additional fields.
  T? parseField<T>(String name, [Set<String>? parsedFields]) {
    final value = this[name];
    parsedFields?.add(name);
    if (value is T) {
      return value;
    }

    return null;
  }

  /// Parses a single field with a given [name] and throws a
  /// [ValidationException] if the field is not present or does not have the
  /// type [T].
  ///
  /// Like [parseField], it adds the field [name] to the set of [parsedFields],
  /// if present.
  T parseRequiredField<T>(String name, [Set<String>? parsedFields]) {
    final value = parseField(name, parsedFields);

    if (value is! T) {
      throw ValidationException(
        'Value for field $name has wrong data type or is missing. '
        'Expected ${T.runtimeType}, got ${value.runtimeType}.',
      );
    }

    return value;
  }

  /// Parses a map field with a given [name].
  ///
  /// Ensures that the field value is of type [T] and returns `null` if the
  /// value does not have this type or is not present.
  ///
  /// If a [Set] of [parsedFields] is passed to this function, the field [name]
  /// will added. This can be used for filtering when parsing additional fields.
  Map<String, T>? parseMapField<T>(String name, [Set<String>? parsedFields]) {
    final dynamic mapField = this[name];
    parsedFields?.add(name);

    if (mapField is Map<String, dynamic>) {
      final Map<String, T> result = {};

      for (final entry in mapField.entries) {
        final value = entry.value;
        if (value is T) {
          result[entry.key] = value;
        }
      }

      return result;
    }
    return null;
  }

  /// Parses a field with a given [name] that can contain either a single value
  /// or a list of values of type [T].
  ///
  /// Ensures that the field value is of type [T] or `List<T>` and returns
  /// `null` if the value does not have one of these types or is not present.
  ///
  /// If a [Set] of [parsedFields] is passed to this function, the field [name]
  /// will added. This can be used for filtering when parsing additional fields.
  List<T>? parseArrayField<T>(String name, [Set<String>? parsedFields]) {
    final value = this[name];
    parsedFields?.add(name);

    if (value is T) {
      return [value];
    } else if (value is List<dynamic>) {
      return value.whereType<T>().toList(growable: false);
    }

    return null;
  }
}
