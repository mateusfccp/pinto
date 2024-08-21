import 'package:pinto/error.dart';

import 'import.dart';
import 'node.dart';
import 'program.dart';
import 'statement.dart';
import 'token.dart';
import 'type_literal.dart';

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

  ProgramAst parse() {
    final imports = <ImportStatement>[];
    final body = <Statement>[];

    while (_isNotAtEnd) {
      try {
        if (body.isEmpty) {
          if (_match(TokenType.importKeyword)) {
            imports.add(_import());
            continue;
          }
        }

        _consume(
          TokenType.typeKeyword,
          ExpectAfterError(
            token: _peek,
            expectation: ExpectationType.oneOf(
              expectations: [
                if (body.isEmpty) ExpectationType.token(token: TokenType.importKeyword),
                ExpectationType.token(token: TokenType.typeKeyword),
              ],
            ),
            after: body.isEmpty //
                ? ExpectationType.token(token: TokenType.identifier)
                : ExpectationType.statement(statement: body[body.length - 1]),
          ),
        );

        body.add(_typeDefinition());
      } on ParseError {
        _synchronize();
      }
    }

    return ProgramAst(imports, body);
  }

  void _synchronize() {
    _advance();
    while (_isNotAtEnd) {
      switch (_peek.type) {
        case TokenType.importKeyword || TokenType.typeKeyword:
          return;
        default:
          _advance();
      }
    }
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

  Token _consumeExpecting(TokenType type) {
    return _consume(
      type,
      ExpectError(
        token: _peek,
        expectation: TokenExpectation(token: type),
      ),
    );
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

  ImportStatement _import() {
    final identifier = _consumeExpecting(TokenType.importIdentifier);

    final ImportType type;

    if (identifier.lexeme[0] == '@') {
      type = ImportType.dart;
    } else {
      type = ImportType.package;
    }

    return ImportStatement(type, identifier);
  }

  TypeDefinitionStatement _typeDefinition() {
    final name = _consumeAfter(
      type: TokenType.identifier,
      after: TokenType.typeKeyword,
    );

    final typeParameters = <IdentifiedTypeLiteral>[];

    if (_match(TokenType.leftParenthesis)) {
      final firstTypeParameter = _typeParameterLiteral();

      typeParameters.add(firstTypeParameter);

      while (!_check(TokenType.rightParenthesis)) {
        _consumeAfter(
          type: TokenType.comma,
          after: TokenType.identifier,
          description: 'type parameter',
        );

        final typeParameter = _typeParameterLiteral();

        typeParameters.add(typeParameter);
      }

      _consumeAfter(
        type: TokenType.rightParenthesis,
        after: TokenType.identifier,
        description: 'type parameter',
      );
    }

    _consumeAfter(
      type: TokenType.equalitySign,
      after: TokenType.identifier,
      description: 'type name',
    );

    final variants = <TypeVariantNode>[
      _typeVariant(true),
    ];

    while (_match(TokenType.plusSign)) {
      variants.add(_typeVariant(false));
    }

    return TypeDefinitionStatement(
      name,
      typeParameters,
      variants,
    );
  }

  TypeVariantNode _typeVariant(bool isFirstDefinition) {
    final name = _consumeAfter(
      type: TokenType.identifier,
      after: isFirstDefinition //
          ? TokenType.equalitySign
          : TokenType.plusSign,
    );

    final parameters = <TypeVariantParameterNode>[];

    if (_match(TokenType.leftParenthesis)) {
      parameters.add(_typeVariationParameter());

      while (_match(TokenType.comma)) {
        if (_match(TokenType.rightParenthesis)) break;

        parameters.add(_typeVariationParameter());
      }

      _consumeAfter(
        type: TokenType.rightParenthesis,
        after: TokenType.identifier,
      );
    }

    return TypeVariantNode(
      name,
      parameters,
    );
  }

  TypeVariantParameterNode _typeVariationParameter() {
    final type = _typeLiteral();

    final name = _consumeAfter(
      type: TokenType.identifier,
      after: TokenType.leftParenthesis, // TODO(mateusfccp): Fix it
      description: 'parameter type',
    );

    return TypeVariantParameterNode(type, name);
  }

  TypeLiteral _typeLiteral() {
    if (_match(TokenType.verum)) {
      return TopTypeLiteral();
    } else if (_match(TokenType.falsum)) {
      return BottomTypeLiteral();
    } else if (_match(TokenType.leftBracket)) {
      final literal = _typeLiteral();

      _consumeAfter(
        type: TokenType.rightBracket,
        after: TokenType.identifier, // TODO(mateusfccp): Fix this
      );

      return ListTypeLiteral(literal);
    } else if (_match(TokenType.leftBrace)) {
      final literal = _typeLiteral();

      final valueLiteral = _match(TokenType.colon) ? _typeLiteral() : null;

      _consumeAfter(
        type: TokenType.rightBrace,
        after: TokenType.identifier, // TODO(mateusfccp): Fix this
      );

      if (valueLiteral == null) {
        return SetTypeLiteral(literal);
      } else {
        return MapTypeLiteral(literal, valueLiteral);
      }
    } else {
      final identifier = _consumeExpecting(TokenType.identifier);
      final parameters = <TypeLiteral>[];

      if (_match(TokenType.leftParenthesis)) {
        parameters.add(_typeLiteral());

        while (_match(TokenType.comma)) {
          parameters.add(_typeLiteral());
        }

        _consumeAfter(
          type: TokenType.rightParenthesis,
          after: TokenType.identifier, // TODO(mateusfccp): Fix this
        );
      }

      final literal = IdentifiedTypeLiteral(identifier, parameters);

      if (_match(TokenType.eroteme)) {
        return OptionTypeLiteral(literal);
      } else {
        return literal;
      }
    }
  }

  IdentifiedTypeLiteral _typeParameterLiteral() {
    final identifier = _consumeExpecting(TokenType.identifier);
    return IdentifiedTypeLiteral(identifier, null);
  }
}
