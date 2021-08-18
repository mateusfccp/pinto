import 'error.dart';
import 'token.dart';

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

  final _values = <String, Object?>{};

  /// Get a variable with the given [name] in the environment.
  ///
  /// If the environment has not the expected [name], it will rescursively look
  /// in the [enclosing] environment until it is found and return the value.
  ///
  /// If this environment is a root environment and [name] is not found, `null`
  /// will be returned.
  Object? get(Token name) {
    if (_values[name.lexeme] case final value?) {
      return value;
    } else if (enclosing case final enclosing?) {
      return enclosing.get(name);
    } else {
      throw UndefinedVariableError(name);
    }
  }

  /// Sets the [value] for [name] in the environment.
  ///
  /// If the environment has not the expected [name], it will rescursively look
  /// in the [enclosing] environment until it is found, and then set the [value]
  /// in the environment in which the [name] was found.
  ///
  /// If this environment is a root environment and [name] is not found, the
  /// assignment will fail and a [RuntimeError] will be thrown.
  void assign(Token name, Object? value) {
    if (_values.containsKey(name.lexeme)) {
      _values[name.lexeme] = value;
    } else if (enclosing case final enclosing?) {
      enclosing.assign(name, value);
    } else {
      throw UndefinedVariableError(name);
    }
  }

  /// Defines a [name] in the environment with the passed [value].
  void define(String name, Object? value) => _values[name] = value;

  /// Gets [name] in the [distance]ᵗʰ ancestor.
  Object? getAt(int distance, String name) => ancestor(distance)._values[name];

  /// Sets [name] to [value] in the [distance]ᵗʰ ancestor.
  void assignAt(int distance, Token name, Object? value) => ancestor(distance)._values[name.lexeme] = value;

  /// Gets the [distance]ᵗʰ ancestor environment.
  Environment ancestor(int distance) {
    var environment = this;

    for (int i = 0; i < distance; i++) {
      if (environment.enclosing case final enclosing?) {
        environment = enclosing;
      } else {
        throw StateError('Expected to find ancestor up to $distance, but maximum depth was $i');
      }
    }

    return environment;
  }
}
