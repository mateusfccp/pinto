import 'element.dart';

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

  final _definedSymbols = <String, TypedElement>{};

  /// Get a variable with the given [name] in the environment.
  ///
  /// If the environment has not the expected [name], it will rescursively look
  /// in the [enclosing] environment until it is found and return the value.
  ///
  /// If this environment is a root environment and [name] is not found, `null`
  /// will be returned.
  TypedElement? getDefinition(String name) {
    if (_definedSymbols[name] case final type?) {
      return type;
    } else if (enclosing case final enclosing?) {
      return enclosing.getDefinition(name);
    } else {
      return null;
    }
  }

  /// Defines a [name] in the environment with the passed [value].
  void defineSymbol(String name, TypedElement type) {
    // TODO(mateusfccp): Consider when we want to allow shadowing or not
    _definedSymbols[name] = type;
  }

  Environment fork() => Environment(enclosing: this);
}
