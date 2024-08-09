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

  Environment.root() : enclosing = null {
    // TODO(mateusfccp): import from `dart:core`
    _values.add('BigInt');
    _values.add('bool');
    _values.add('Comparable');
    _values.add('DateTime');
    _values.add('Deprecated');
    _values.add('double');
    _values.add('Duration');
    _values.add('Enum');
    _values.add('Expando');
    _values.add('Finalizer');
    _values.add('Function');
    _values.add('Future');
    _values.add('int');
    _values.add('Invocation');
    _values.add('Iterable');
    _values.add('Iterator');
    _values.add('List');
    _values.add('Map');
    _values.add('Mapentry');
    _values.add('Match');
    _values.add('Null');
    _values.add('num');
    _values.add('Object');
    _values.add('Pattern');
    _values.add('pragma');
    _values.add('Record');
    _values.add('Regexp');
    _values.add('Regexpmatch');
    _values.add('Runeiterator');
    _values.add('Runes');
    _values.add('Set');
    _values.add('Sink');
    _values.add('Stacktrace');
    _values.add('Stopwatch');
    _values.add('Stream');
    _values.add('String');
    _values.add('Stringbuffer');
    _values.add('Stringsink');
    _values.add('Symbol');
    _values.add('Type');
    _values.add('Uri');
    _values.add('Uridata');
    _values.add('Weakreference');
  }

  /// The enclosing environment.
  ///
  /// If `null`, the environment is a root environment, usually the global
  /// scope of the program.
  final Environment? enclosing;

  final _values = <String>[];

  /// Get a variable with the given [name] in the environment.
  ///
  /// If the environment has not the expected [name], it will rescursively look
  /// in the [enclosing] environment until it is found and return the value.
  ///
  /// If this environment is a root environment and [name] is not found, `null`
  /// will be returned.
  bool hasSymbol(String name) {
    if (_values.contains(name)) {
      return true;
    } else if (enclosing case final enclosing?) {
      return enclosing.hasSymbol(name);
    } else {
      return false;
    }
  }

  /// Defines a [name] in the environment with the passed [value].
  void defineSymbol(String name) {
    if (!hasSymbol(name)) {
      _values.add(name);
    }
  }

  Environment fork() => Environment(enclosing: this);
}
