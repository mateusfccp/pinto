import 'package:pinto/lexer.dart';
import 'package:pinto/error.dart';
import 'package:pinto/syntactic_entity.dart';

import 'ast.dart';
import 'import.dart';

const _expressionTokens = [
  TokenType.doubleLiteral,
  TokenType.falseKeyword,
  TokenType.identifier,
  TokenType.integerLiteral,
  TokenType.leftParenthesis,
  // TokenType.letKeyword,
  TokenType.stringLiteral,
  TokenType.symbolLiteral,
  TokenType.trueKeyword,
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
          final error = MisplacedImport(importDeclaration: declaration);

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
        final error = ExpectedError(
          syntacticEntity: _peek,
          expectation: ExpectationType.declaration(),
        );

        _errorHandler?.emit(error);
        throw error;
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
        case TokenType.importKeyword || //
              TokenType.typeKeyword ||
              TokenType.letKeyword:
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

  Token _consume(TokenType tokenType, ParseError error) {
    if (_check(tokenType)) {
      return _advance();
    } else {
      _errorHandler?.emit(error);
      throw error;
    }
  }

  Token _consumeOneOf(List<TokenType> tokenTypes, ParseError error) {
    if (tokenTypes.any(_check)) {
      return _advance();
    } else {
      _errorHandler?.emit(error);
      throw error;
    }
  }

  Token _consumeExpecting(TokenType tokenType) {
    return _consume(
      tokenType,
      ExpectedError(
        syntacticEntity: _peek,
        expectation: TokenExpectation(token: tokenType),
      ),
    );
  }

  Token _consumeExpectingMany(List<TokenType> tokenTypes) {
    return _consumeOneOf(
      tokenTypes,
      ExpectedError(
        syntacticEntity: _peek,
        expectation: ExpectationType.oneOf(
          expectations: [
            for (final tokenType in tokenTypes) TokenExpectation(token: tokenType),
          ],
        ),
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
      ExpectedAfterError(
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

    final Token identifier = _consumeExpectingMany(
      [
        TokenType.identifier,
        TokenType.importIdentifier,
      ],
    );

    final ImportType type;

    if (identifier.type == TokenType.importIdentifier) {
      type = ImportType.dart;
    } else {
      type = ImportType.package;
    }

    return ImportDeclaration(keyword, type, identifier);
  }

  Expression _expression() {
    if (_matchExpressionToken()) {
      switch (_previous.type) {
        case TokenType.doubleLiteral:
          return DoubleLiteral(_previous);
        case TokenType.falseKeyword:
          return BooleanLiteral(_previous);
        case TokenType.identifier:
          return _identifier();
        case TokenType.integerLiteral:
          return IntegerLiteral(_previous);
        case TokenType.leftParenthesis:
          return _structLiteral();
        case TokenType.stringLiteral:
          return StringLiteral(_previous);
        case TokenType.symbolLiteral:
          return _symbolLiteral();
        case TokenType.trueKeyword:
          return BooleanLiteral(_previous);
        default:
          // TODO(mateusfccp): We may exhaustively check this case by using a sealed class for tokens instead of enums
          throw StateError('This branch should be unreachable.');
      }
    } else {
      throw ExpectedError(
        syntacticEntity: _previous,
        expectation: ExpectationType.expression(),
      );
    }
  }

  Expression _identifier() {
    final identifier = IdentifierExpression(_previous);
    if (_checkExpressionToken()) {
      return InvocationExpression(
        identifier,
        _expression(),
      );
    } else {
      return identifier;
    }
  }

  StructLiteral _structLiteral() {
    final leftParenthesis = _previous;

    final SyntacticEntityList<StructMember>? members;

    if (_check(TokenType.rightParenthesis)) {
      members = null;
    } else {
      members = SyntacticEntityList();

      while (!_check(TokenType.rightParenthesis)) {
        members.add(_structMember());
        final comma = _match(TokenType.comma);

        if (!comma) break;
      }
    }

    final rightParenthesis = _consumeExpecting(TokenType.rightParenthesis);

    return StructLiteral(
      leftParenthesis,
      members,
      rightParenthesis,
    );
  }

  StructMember _structMember() {
    if (_match(TokenType.symbolLiteral)) {
      final name = _symbolLiteral();

      if (_checkExpressionToken()) {
        return FullStructMember(
          name,
          _expression(),
        );
      } else {
        return ValuelessStructMember(name);
      }
    } else {
      final value = _expression();

      return NamelessStructMember(value);
    }
  }

  SymbolLiteral _symbolLiteral() {
    assert(_previous.type == TokenType.symbolLiteral);
    return SymbolLiteral(_previous);
  }

  LetDeclaration _letDeclaration() {
    final keyword = _previous;
    final identifier = _consumeExpecting(TokenType.identifier);

    final StructLiteral? parameter;
    if (_check(TokenType.equalitySign)) {
      parameter = null;
    } else {
      _consumeExpecting(TokenType.leftParenthesis);
      parameter = _structLiteral();
    }

    final equals = _consume(
      TokenType.equalitySign,
      ExpectedAfterError(
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
      after: TokenType.identifier,
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
      final IdentifiedTypeIdentifier literal;

      final identifier = _consumeExpecting(TokenType.identifier);
      final parameters = <TypeIdentifier>[];

      if (_match(TokenType.leftParenthesis)) {
        final leftParenthesis = _previous;

        parameters.add(_typeIdentifier());

        while (_match(TokenType.comma)) {
          parameters.add(_typeIdentifier());
        }

        final rightParenthesis = _consumeAfter(
          type: TokenType.rightParenthesis,
          after: TokenType.identifier, // TODO(mateusfccp): Fix this
        );

        literal = IdentifiedTypeIdentifier(
          identifier,
          leftParenthesis,
          SyntacticEntityList(parameters),
          rightParenthesis,
        );
      } else {
        literal = IdentifiedTypeIdentifier.raw(
          identifier,
        );
      }

      if (_match(TokenType.eroteme)) {
        return OptionTypeIdentifier(literal, _previous);
      } else {
        return literal;
      }
    }
  }

  IdentifiedTypeIdentifier _typeParameterLiteral() {
    final identifier = _consumeExpecting(TokenType.identifier);
    return IdentifiedTypeIdentifier.raw(identifier);
  }
}
