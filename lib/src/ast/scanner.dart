import 'package:pinto/error.dart';

import 'token.dart';

/// A Lox scanner.
final class Scanner {
  /// Creates a Lox scanner for [source].
  Scanner({
    required String source,
    ErrorHandler? errorHandler,
  })  : _errorHandler = errorHandler,
        _source = source;

  final String _source;
  final ErrorHandler? _errorHandler;
  final _tokens = <Token>[];

  var _start = 0;
  var _current = 0;
  var _line = 1;
  var _column = 0;

  static const _keywords = {
    'import': TokenType.importKeyword,
    'type': TokenType.typeKeyword, // TODO(mateusfccp): We'll probably want to remove it from here and make it a contextual keyword
  };

  bool get _isAtEnd => _current >= _source.length;

  /// Scans the source and returns the tokens.
  List<Token> scanTokens() {
    while (!_isAtEnd) {
      _start = _current;
      _scanToken();
    }

    _tokens.add(
      Token(
        type: TokenType.endOfFile,
        lexeme: '',
        column: _column,
        line: _line,
      ),
    );
    return _tokens;
  }

  void _scanToken() {
    final character = _advance();
    return switch (character) {
      '⊤' => _addToken(TokenType.verum),
      '⊥' => _addToken(TokenType.falsum),
      '@' => _addToken(TokenType.at),
      '?' => _addToken(TokenType.eroteme),
      '(' => _addToken(TokenType.leftParenthesis),
      ')' => _addToken(TokenType.rightParenthesis),
      '[' => _addToken(TokenType.leftBracket),
      ']' => _addToken(TokenType.rightBracket),
      '{' => _addToken(TokenType.leftBrace),
      '}' => _addToken(TokenType.rightBrace),
      ',' => _addToken(TokenType.comma),
      '+' => _addToken(TokenType.plusSign),
      '=' => _addToken(TokenType.equalitySign),
      ':' => _addToken(TokenType.colon),
      '/' => _slash(),
      ' ' || '\r' || '\t' => null,
      '\n' => _lineBreak(),
      final character => _character(character),
    };
  }

  void _slash() {
    if (_match('/')) {
      while (_peek != '\n' && !_isAtEnd) {
        _advance();
      }
    } else if (_match('*')) {
      _advanceUntilCommentEnd();
    } else {
      _addToken(TokenType.slash);
    }
  }

  void _lineBreak() {
    _line++;
    _column = 0;
  }

  void _character(String character) {
    if (_isIdentifierStart(character)) {
      _identifier();
    } else {
      _errorHandler?.emit(
        UnexpectedCharacterError(
          location: ScanLocation(
            offset: _current,
            line: _line,
            column: _column,
          ),
          character: character,
        ),
      );
    }
  }

  void _addToken(TokenType type, [Object? literal]) {
    final text = _source.substring(_start, _current);
    final token = Token(
      type: type,
      lexeme: text,
      column: _column,
      line: _line,
    );

    _tokens.add(token);
  }

  String _advance() {
    _column++;
    return _source[_current++];
  }

  void _advanceUntilCommentEnd() {
    int commentLevel = 1;

    while (commentLevel > 0 && !_isAtEnd) {
      if (_match('\n')) {
        _line++;
        _column = 0;
        continue;
      } else if (_match('/') && _peek == '*') {
        commentLevel = commentLevel + 1;
      } else if (_match('*') && _peek == '/') {
        commentLevel = commentLevel - 1;
      }

      _advance();
    }
  }

  bool _match(String expected) {
    if (_isAtEnd || _source[_current] != expected) {
      return false;
    } else {
      _column++;
      _current++;
      return true;
    }
  }

  String get _peek => _isAtEnd ? '\x00' : _source[_current];

  String get _peekNext => _current + 1 >= _source.length ? '\x00' : _source[_current + 1];

  bool _isIdentifierStart(String character) {
    assert(character.length == 1);
    return RegExp(r'[A-Za-z_$]').hasMatch(character);
  }

  bool _isIdentifierPart(String character) {
    assert(character.length == 1);
    return RegExp(r'[A-Za-z_$0-9]').hasMatch(character);
  }

  void _identifier() {
    while (_isIdentifierPart(_peek)) {
      _advance();
    }

    final text = _source.substring(_start, _current);
    final tokenType = _keywords[text] ?? TokenType.identifier;

    _addToken(tokenType);
  }
}
