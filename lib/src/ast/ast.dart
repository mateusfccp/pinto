import 'package:pinto/annotations.dart';
import 'package:pinto/ast.dart' hide Node;
import 'package:pinto/lexer.dart';
import 'package:pinto/syntactic_entity.dart';

part 'ast.g.dart';

@TreeRoot()
sealed class AstNode with _AstNode implements SyntacticEntity {
  const AstNode();

  @override
  int get length => end - offset;

  R? accept<R>(AstNodeVisitor<R> visitor);

  void visitChildren<R>(AstNodeVisitor<R> visitor);
}

sealed class TypeIdentifier extends AstNode with _TypeIdentifier {
  const TypeIdentifier();
}

final class TopTypeIdentifier extends TypeIdentifier with _TopTypeIdentifier {
  const TopTypeIdentifier(this.verum);

  final Token verum;

  @override
  int get offset => verum.offset;

  @override
  int get end => verum.end;
}

final class BottomTypeIdentifier extends TypeIdentifier with _BottomTypeIdentifier {
  const BottomTypeIdentifier(this.falsum);

  final Token falsum;

  @override
  int get offset => falsum.offset;

  @override
  int get end => falsum.end;
}

final class ListTypeIdentifier extends TypeIdentifier with _ListTypeIdentifier {
  const ListTypeIdentifier(
    this.leftBracket,
    this.identifier,
    this.rightBracket,
  );

  final Token leftBracket;

  final TypeIdentifier identifier;

  final Token rightBracket;

  @override
  int get offset => leftBracket.offset;

  @override
  int get end => rightBracket.end;
}

final class SetTypeIdentifier extends TypeIdentifier with _SetTypeIdentifier {
  const SetTypeIdentifier(
    this.leftBrace,
    this.identifier,
    this.rightBrace,
  );

  final Token leftBrace;

  final TypeIdentifier identifier;

  final Token rightBrace;

  @override
  int get offset => leftBrace.offset;

  @override
  int get end => rightBrace.end;
}

final class MapTypeIdentifier extends TypeIdentifier with _MapTypeIdentifier {
  const MapTypeIdentifier(
    this.leftBrace,
    this.key,
    this.colon,
    this.value,
    this.rightBrace,
  );

  final Token leftBrace;

  final TypeIdentifier key;

  final Token colon;

  final TypeIdentifier value;

  final Token rightBrace;

  @override
  int get offset => leftBrace.offset;

  @override
  int get end => rightBrace.end;
}

final class IdentifiedTypeIdentifier extends TypeIdentifier with _IdentifiedTypeIdentifier {
  const IdentifiedTypeIdentifier(
    this.identifier,
    this.leftParenthesis,
    this.arguments,
    this.rightParenthesis,
  );

  final Token identifier;

  final Token? leftParenthesis;

  final SyntacticEntityList<TypeIdentifier>? arguments;

  final Token? rightParenthesis;

  @override
  int get offset => identifier.offset;

  @override
  int get end => rightParenthesis?.end ?? arguments?.end ?? leftParenthesis?.end ?? identifier.end;
}

final class OptionTypeIdentifier extends TypeIdentifier with _OptionTypeIdentifier {
  const OptionTypeIdentifier(
    this.identifier,
    this.eroteme,
  );

  final TypeIdentifier identifier;

  final Token eroteme;

  @override
  int get offset => identifier.offset;

  @override
  int get end => eroteme.end;
}

sealed class Node extends AstNode with _Node {
  const Node();
}

final class TypeVariantParameterNode extends Node with _TypeVariantParameterNode {
  const TypeVariantParameterNode(
    this.typeIdentifier,
    this.name,
  );

  final TypeIdentifier typeIdentifier;

  final Token name;

  @override
  int get offset => typeIdentifier.offset;

  @override
  int get end => name.end;
}

final class TypeVariantNode extends Node with _TypeVariantNode {
  const TypeVariantNode(
    this.name,
    this.parameters,
  );

  final Token name;

  final SyntacticEntityList<TypeVariantParameterNode> parameters;

  @override
  int get offset => name.offset;

  @override
  int get end => parameters.end;
}

sealed class Expression extends AstNode with _Expression {
  const Expression();
}

final class IdentifierExpression extends Expression with _IdentifierExpression {
  const IdentifierExpression(this.identifier);

  final Token identifier;

  @override
  int get offset => identifier.offset;

  @override
  int get end => identifier.end;
}

final class InvocationExpression extends Expression with _InvocationExpression {
  const InvocationExpression(
    this.identifierExpression,
    this.argument,
  );

  final IdentifierExpression identifierExpression;

  final Expression argument;

  @override
  int get offset => identifierExpression.offset;

  @override
  int get end => argument.end;
}

final class LetExpression extends Expression with _LetExpression {
  const LetExpression(
    this.identifier,
    this.equals,
    this.binding,
    this.result,
  );

  final Token identifier;

  final Token equals;

  final Expression binding;

  final Expression result;

  @override
  int get offset => identifier.offset;

  @override
  int get end => result.end;
}

sealed class Literal extends Expression with _Literal {
  const Literal();

  Token get literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;
}

final class BooleanLiteral extends Literal with _BooleanLiteral {
  const BooleanLiteral(this.literal);

  @override
  final Token literal;
}

final class UnitLiteral extends Literal with _UnitLiteral {
  const UnitLiteral(this.literal);

  @override
  final Token literal;
}

final class StringLiteral extends Literal with _StringLiteral {
  const StringLiteral(this.literal);

  @override
  final Token literal;
}

final class IntegerLiteral extends Literal with _IntegerLiteral {
  const IntegerLiteral(this.literal);

  @override
  final Token literal;
}

final class DoubleLiteral extends Literal with _DoubleLiteral {
  const DoubleLiteral(this.literal);

  @override
  final Token literal;
}

sealed class Declaration extends AstNode with _Declaration {
  const Declaration();
}

final class ImportDeclaration extends Declaration with _ImportDeclaration {
  const ImportDeclaration(
    this.keyword,
    this.type,
    this.identifier,
  );

  final Token keyword;

  final ImportType type;

  final Token identifier;

  @override
  int get offset => keyword.offset;

  @override
  int get end => identifier.end;
}

final class TypeDefinition extends Declaration with _TypeDefinition {
  const TypeDefinition(
    this.keyword,
    this.name,
    this.leftParenthesis,
    this.parameters,
    this.rightParenthesis,
    this.equals,
    this.variants,
  );

  final Token keyword;

  final Token name;

  final Token? leftParenthesis;

  final SyntacticEntityList<IdentifiedTypeIdentifier>? parameters;

  final Token? rightParenthesis;

  final Token equals;

  final SyntacticEntityList<TypeVariantNode> variants;

  @override
  int get offset => keyword.offset;

  @override
  int get end => variants.end;
}

final class LetDeclaration extends Declaration with _LetDeclaration {
  const LetDeclaration(
    this.keyword,
    this.identifier,
    this.parameter,
    this.equals,
    this.body,
  );

  final Token keyword;

  final Token identifier;

  final Token? parameter;

  final Token equals;

  final Expression body;

  @override
  int get offset => keyword.offset;

  @override
  int get end => body.end;
}
