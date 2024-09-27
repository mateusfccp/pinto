import 'package:pinto/lexer.dart';
import 'package:pinto/error.dart';
import 'package:pinto/syntactic_entity.dart';

import 'ast.dart';
import 'import.dart';

const _expressionTokens = [
  TokenType.falseKeyword,
  TokenType.identifier,
  // TokenType.letKeyword,
  TokenType.stringLiteral,
  TokenType.trueKeyword,
  TokenType.unitLiteral,
];

/// A pint° parser.
final class Parser {
  /// Creates a pint° parser.
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

  List<Declaration> parse() {
    final body = <Declaration>[];

    while (_isNotAtEnd) {
      final declaration = _declaration();

      if (declaration != null) {
        if (body.isNotEmpty && declaration is ImportDeclaration && body[body.length - 1] is! ImportDeclaration) {
          final error = ExpectAfterError(
            syntacticEntity: declaration,
            expectation: ExpectationType.token(token: TokenType.typeKeyword),
            after: ExpectationType.declaration(declaration: declaration),
          );

          _errorHandler?.emit(error);
        }

        body.add(declaration);
      }
    }

    return body;
  }

  Declaration? _declaration() {
    try {
      if (_match(TokenType.importKeyword)) {
        return _import();
      } else if (_match(TokenType.letKeyword)) {
        return _letDeclaration();
      } else if (_match(TokenType.typeKeyword)) {
        return _typeDefinition();
      } else {
        return null;
      }
    } on ParseError {
      _synchronize();
      return null;
    }
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

  bool _match(TokenType type1, [TokenType? type2, TokenType? type3, TokenType? type4, TokenType? type5, TokenType? type6, TokenType? type7, TokenType? type8]) {
    final types = [type1, type2, type3, type4, type5, type6, type7, type8].nonNulls;

    for (final type in types) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }

    return false;
  }

  bool _matchExpressionToken() {
    return _expressionTokens.any(_match);
  }

  bool _check(TokenType type) => _isNotAtEnd && _peek.type == type;

  bool _checkExpressionToken() {
    return _expressionTokens.any(_check);
  }

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
        syntacticEntity: _peek,
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
        syntacticEntity: _peek,
        expectation: TokenExpectation(token: type),
        after: TokenExpectation(
          token: after,
          description: description,
        ),
      ),
    );
  }

  ImportDeclaration _import() {
    final keyword = _previous;

    final Token identifier;

    // TODO(mateusfccp): Improve this to allow multiple expectations
    if (_check(TokenType.identifier)) {
      identifier = _consumeExpecting(TokenType.identifier);
    } else {
      identifier = _consumeExpecting(TokenType.importIdentifier);
    }

    final ImportType type;

    if (identifier.lexeme[0] == '@') {
      type = ImportType.dart;
    } else {
      type = ImportType.package;
    }

    return ImportDeclaration(keyword, type, identifier);
  }

  Expression _expression() {
    // TODO(mateusfccp): Implement let expression parsing

    if (_matchExpressionToken()) {
      switch (_previous.type) {
        case TokenType.falseKeyword:
        case TokenType.trueKeyword:
          return BooleanLiteral(_previous);
        case TokenType.stringLiteral:
          return StringLiteral(_previous);
        case TokenType.unitLiteral:
          return UnitLiteral(_previous);
        case TokenType.identifier:
          final identifier = IdentifierExpression(_previous);
          if (_checkExpressionToken()) {
            return InvocationExpression(
              identifier,
              _expression(),
            );
          } else {
            return identifier;
          }
        default:
          throw StateError('This branch should be unreachable.');
      }
    } else {
      throw ExpectError(
        syntacticEntity: _previous,
        expectation: ExpectationType.expression(),
      );
    }
  }

  LetDeclaration _letDeclaration() {
    final keyword = _previous;
    final identifier = _consumeExpecting(TokenType.identifier);

    final Token? parameter;
    if (_match(TokenType.identifier)) {
      parameter = _previous;
    } else {
      parameter = null;
    }

    final equals = _consume(
      TokenType.equalitySign,
      ExpectAfterError(
        syntacticEntity: _peek,
        expectation: ExpectationType.token(token: TokenType.equalitySign),
        after: ExpectationType.token(
          token: TokenType.identifier,
          description: parameter == null ? 'declaration name' : 'parameter name',
        ),
      ),
    );

    final body = _expression();

    return LetDeclaration(
      keyword,
      identifier,
      parameter,
      equals,
      body,
    );
  }

  TypeDefinition _typeDefinition() {
    final keyword = _previous;

    final name = _consumeAfter(
      type: TokenType.identifier,
      after: TokenType.typeKeyword,
    );

    final typeParameters = <IdentifiedTypeIdentifier>[];

    final Token? leftParenthesis;
    final Token? rightParenthesis;

    if (_match(TokenType.leftParenthesis)) {
      leftParenthesis = _previous;

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

      rightParenthesis = _consumeAfter(
        type: TokenType.rightParenthesis,
        after: TokenType.identifier,
        description: 'type parameter',
      );
    } else {
      leftParenthesis = null;
      rightParenthesis = null;
    }

    final equals = _consumeAfter(
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

    return TypeDefinition(
      keyword,
      name,
      leftParenthesis,
      SyntacticEntityList(typeParameters),
      rightParenthesis,
      equals,
      SyntacticEntityList(variants),
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
      SyntacticEntityList(parameters),
    );
  }

  TypeVariantParameterNode _typeVariationParameter() {
    final type = _typeIdentifier();

    final name = _consumeAfter(
      type: TokenType.identifier,
      after: TokenType.leftParenthesis, // TODO(mateusfccp): Fix this
      description: 'parameter type',
    );

    return TypeVariantParameterNode(type, name);
  }

  TypeIdentifier _typeIdentifier() {
    if (_match(TokenType.verum)) {
      return TopTypeIdentifier(_previous);
    } else if (_match(TokenType.falsum)) {
      return BottomTypeIdentifier(_previous);
    } else if (_match(TokenType.leftBracket)) {
      final leftBracket = _previous;
      final literal = _typeIdentifier();

      final rightBracket = _consumeAfter(
        type: TokenType.rightBracket,
        after: TokenType.identifier, // TODO(mateusfccp): Fix this
      );

      return ListTypeIdentifier(
        leftBracket,
        literal,
        rightBracket,
      );
    } else if (_match(TokenType.leftBrace)) {
      final leftBrace = _previous;
      final literal = _typeIdentifier();

      final Token? colon;
      final TypeIdentifier? valueLiteral;

      if (_match(TokenType.colon)) {
        colon = _previous;
        valueLiteral = _typeIdentifier();
      } else {
        colon = null;
        valueLiteral = null;
      }

      final rightBrace = _consumeAfter(
        type: TokenType.rightBrace,
        after: TokenType.identifier, // TODO(mateusfccp): Fix this
      );

      if (colon == null || valueLiteral == null) {
        return SetTypeIdentifier(
          leftBrace,
          literal,
          rightBrace,
        );
      } else {
        return MapTypeIdentifier(
          leftBrace,
          literal,
          colon,
          valueLiteral,
          rightBrace,
        );
      }
    } else {
      final identifier = _consumeExpecting(TokenType.identifier);
      final parameters = <TypeIdentifier>[];

      final Token? leftParenthesis;
      final Token? rightParenthesis;

      if (_match(TokenType.leftParenthesis)) {
        leftParenthesis = _previous;
        parameters.add(_typeIdentifier());

        while (_match(TokenType.comma)) {
          parameters.add(_typeIdentifier());
        }

        rightParenthesis = _consumeAfter(
          type: TokenType.rightParenthesis,
          after: TokenType.identifier, // TODO(mateusfccp): Fix this
        );
      } else {
        leftParenthesis = null;
        rightParenthesis = null;
      }

      final literal = IdentifiedTypeIdentifier(
        identifier,
        leftParenthesis,
        SyntacticEntityList(parameters),
        rightParenthesis,
      );

      if (_match(TokenType.eroteme)) {
        return OptionTypeIdentifier(literal, _previous);
      } else {
        return literal;
      }
    }
  }

  IdentifiedTypeIdentifier _typeParameterLiteral() {
    final identifier = _consumeExpecting(TokenType.identifier);
    return IdentifiedTypeIdentifier(
      identifier,
      null,
      null,
      null,
    );
  }
}
