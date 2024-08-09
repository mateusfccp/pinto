import 'error.dart';
import 'node.dart';
import 'statement.dart';
import 'token.dart';

/// A Lox parser.
final class Parser {
  /// Creates a Lox parser.
  Parser({
    required List<Token> tokens,
    ErrorHandler? errorHandler,
  })  : _errorHandler = errorHandler,
        _tokens = tokens;

  final List<Token> _tokens;
  final ErrorHandler? _errorHandler;

  int _current = 0;

  Token get _previous => _tokens[_current - 1];

  Token get _peek => _tokens[_current];

  bool get _isAtEnd => _peek.type == TokenType.endOfFile;

  bool get _isNotAtEnd => !_isAtEnd;

  List<Statement> parse() {
    return [
      for (; !_isAtEnd;)
        if (_declaration() case final declaration?) declaration,
    ];
  }

  bool _match(TokenType type1, [TokenType? type2, TokenType? type3, TokenType? type4]) {
    final types = [type1, type2, type3, type4].nonNulls;

    for (final type in types) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }

    return false;
  }

  bool _check(TokenType type) => _isNotAtEnd && _peek.type == type;

  Token _advance() {
    if (_isNotAtEnd) _current++;
    return _previous;
  }

  Token _consume(TokenType type, ParseError error) {
    if (_check(type)) {
      return _advance();
    } else {
      _errorHandler?.emit(error);
      throw error;
    }
  }

  Token _consumeAfter({
    required TokenType type,
    required TokenType after,
    String? description,
  }) {
    return _consume(
      type,
      ExpectAfterError(
        token: _peek,
        expectation: TokenExpectation(token: type),
        after: TokenExpectation(
          token: after,
          description: description,
        ),
      ),
    );
  }

  void _synchronize() {
    _advance();
    while (_isNotAtEnd) {
      if (_previous.type == TokenType.semicolon) {
        return;
      } else {
        switch (_peek.type) {
          case TokenType.classKeyword:
          case TokenType.forKeyword:
          case TokenType.ifKeyword:
          case TokenType.whileKeyword:
            return;
          default:
            _advance();
        }
      }
    }
  }

  Statement? _declaration() {
    try {
      return _type();
      // if (_match(TokenType.classKeyword)) {
      //   return _class();
      // } else if (_match(TokenType.funKeyword)) {
      //   return _function(RoutineType.function);
      // } else if (_match(TokenType.varKeyword)) {
      //   return _variableDeclaration();
      // } else {
      //   return _statement();
      // }
    } on ParseError {
      _synchronize();
      return null;
    }
  }

  Statement _type() {
    _consume(
      TokenType.typeKeyword,
      ExpectError(
        token: _peek,
        expectation: ExpectationType.token(token: TokenType.typeKeyword),
      ),
    );

    final name = _consumeAfter(
      type: TokenType.identifier,
      after: TokenType.typeKeyword,
    );

    final typeParameters = <Token>[];

    if (_match(TokenType.leftParenthesis)) {
      final firstTypeParameter = _consumeAfter(
        type: TokenType.identifier,
        after: TokenType.leftParenthesis,
      );

      typeParameters.add(firstTypeParameter);

      while (!_check(TokenType.rightParenthesis)) {
        _consumeAfter(
          type: TokenType.comma,
          after: TokenType.identifier,
          description: 'type parameter',
        );

        final typeParameter = _consumeAfter(
          type: TokenType.identifier,
          after: TokenType.leftParenthesis,
        );

        typeParameters.add(typeParameter);
      }

      _consumeAfter(
        type: TokenType.rightParenthesis,
        after: TokenType.identifier,
        description: 'type parameter',
      );
    }

    _consumeAfter(
      type: TokenType.equal,
      after: TokenType.identifier,
      description: 'type name',
    );

    final variations = <TypeVariationNode>[
      _typeVariant(true),
    ];

    while (_match(TokenType.plus)) {
      variations.add(_typeVariant(false));
    }

    return TypeDefinitionStatement(
      name,
      typeParameters,
      variations,
    );
  }

  TypeVariationNode _typeVariant(bool isFirstDefinition) {
    final name = _consumeAfter(
      type: TokenType.identifier,
      after: isFirstDefinition //
          ? TokenType.equal
          : TokenType.plus,
    );

    final parameters = <TypeVariationParameterNode>[];

    if (_check(TokenType.leftParenthesis)) {
      _advance();

      final type = _consumeAfter(
        type: TokenType.identifier,
        after: TokenType.leftParenthesis,
      );

      final name = _consumeAfter(
        type: TokenType.identifier,
        after: TokenType.leftParenthesis,
      );

      parameters.add(
        TypeVariationParameterNode(type, name),
      );

      while (_match(TokenType.comma)) {
        if (_check(TokenType.rightParenthesis)) break;

        final type = _consumeAfter(
          type: TokenType.identifier,
          after: TokenType.comma,
        );

        final name = _consumeAfter(
          type: TokenType.identifier,
          after: TokenType.identifier,
          description: 'type parameter',
        );

        parameters.add(
          TypeVariationParameterNode(type, name),
        );
      }

      _consumeAfter(
        type: TokenType.rightParenthesis,
        after: TokenType.identifier,
        description: 'parameter',
      );
    }

    return TypeVariationNode(
      name,
      parameters,
    );
  }
}
