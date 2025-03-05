import 'dart:collection';

/// Prints an object with an indented format.
///
/// This works with the `toString` methods of the trees node generated by
/// `build_runner`, and is only guaranteed to work with them.
///
/// The default [indentation] is two spaces.
void debugPrint(Object? object, {String indentation = '  '}) {
  final buffer = StringBuffer();
  final indentationTokens = Queue<String>();
  int charIndex = 0;

  final string = object.toString().replaceAll(', ', ',');

  void indent() => buffer.write('\n${indentation * indentationTokens.length}');

  while (charIndex < string.length) {
    final char = string[charIndex];

    if (_isOpeningToken(char)) {
      indentationTokens.add(char);
      buffer.write(char);
      indent();
    } else if (_isClosingToken(char)) {
      final last = indentationTokens.removeLast();

      if (char != _inverseToken(last)) {
        throw ArgumentError('Token mismatch. Expected: $last, found: $char.');
      }

      indent();
      buffer.write(char);
    } else if (char == ',') {
      indent();
    } else {
      buffer.write(char);
    }

    charIndex++;
  }

  print(buffer.toString());
}

@pragma('vm:prefer-inline')
bool _isOpeningToken(String token) {
  return token == '{' || token == '[' || token == '(';
}

@pragma('vm:prefer-inline')
bool _isClosingToken(String token) {
  return token == '}' || token == ']' || token == ')';
}

@pragma('vm:prefer-inline')
String _inverseToken(String token) {
  return switch (token) {
    '{' => '}',
    '[' => ']',
    '(' => ')',
    _ => throw ArgumentError('Invalid token: $token'),
  };
}
