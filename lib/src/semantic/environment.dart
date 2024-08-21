import 'package:pinto/compiler.dart';

import 'type.dart';

/// An environment that carries the context's identifiers.
///
/// An environment can belong to another [enclosing] environment, which  will be
/// considered when looking for an identifier.
final class Environment {
  /// Creates an environment.
  ///
  /// If [enclosing] is `null`, it will be a root environment, usually the
  /// global scope of the program.
  Environment({this.enclosing});

  /// The enclosing environment.
  ///
  /// If `null`, the environment is a root environment, usually the global
  /// scope of the program.
  final Environment? enclosing;

  final _definedTypes = <String, PintoType>{};

  /// Get a variable with the given [name] in the environment.
  ///
  /// If the environment has not the expected [name], it will rescursively look
  /// in the [enclosing] environment until it is found and return the value.
  ///
  /// If this environment is a root environment and [name] is not found, `null`
  /// will be returned.
  PintoType? getType(String name) {
    if (_definedTypes[name] case final type?) {
      return type;
    } else if (enclosing case final enclosing?) {
      return enclosing.getType(name);
    } else {
      return null;
    }
  }

  /// Defines a [name] in the environment with the passed [value].
  void defineType(PintoType type) {
    final name = buildTypeName(type);

    if (type is TopType) {
      throw "Can't redefine the top type.";
    }

    if (type is BottomType) {
      throw "Can't redefine the bottom type.";
    }

    final existingType = getType(name);

    if (type case PolymorphicType(:final source)) {
      if (existingType case PolymorphicType(source: final existingTypeSource)) {
        if (source != existingTypeSource) {
          // Type is being shadowed
        }
      }
    }

    _definedTypes[name] = type;
  }

  Environment fork() => Environment(enclosing: this);
}
