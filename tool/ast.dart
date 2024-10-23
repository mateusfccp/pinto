@Tree('Ast')
library;

import 'package:pinto/lexer.dart';
import 'package:pinto/syntactic_entity.dart';

import 'tree_generator_macro.dart';
import 'types_of_test.dart';

const tree = Tree('Ast');

@root
@Tree('Ast')
sealed class AstNode implements SyntacticEntity {
  const AstNode();

  @override
  int get length => end - offset;
}

@Tree('Ast')
sealed class TypeIdentifier extends AstNode {}

@Tree('Ast')
final class TopTypeIdentifier extends TypeIdentifier {
  final Token verum;
}

@Tree('Ast')
final class BottomTypeIdentifier extends TypeIdentifier {
  final Token falsum;
}

@Tree('Ast')
final class ListTypeIdentifier extends TypeIdentifier {
  final Token leftBracket;

  final TypeIdentifier identifier;

  final Token rightBracket;
}

@Tree('Ast')
final class SetTypeIdentifier extends TypeIdentifier {
  final Token leftBrace;

  final TypeIdentifier identifier;

  final Token rightBrace;
}

@Tree('Ast')
final class MapTypeIdentifier extends TypeIdentifier {
  final Token leftBrace;

  final TypeIdentifier key;

  final Token colon;

  final TypeIdentifier value;

  final Token rightBrace;
}

@Tree('Ast')
final class IdentifiedTypeIdentifier extends TypeIdentifier {
  final Token identifier;

  final Token? leftParenthesis;

  final SyntacticEntityList<TypeIdentifier>? arguments;

  final Token? rightParenthesis;
}

@Tree('Ast')
final class OptionTypeIdentifier extends TypeIdentifier {
  final TypeIdentifier identifier;

  final Token eroteme;
}

// sealed class Node extends AstNode {}

// final class TypeVariantParameterNode extends Node {
//   final TypeIdentifier typeIdentifier;

//   final Token name;
// }

// final class TypeVariantNode extends Node {
//   final Token name;

//   final SyntacticEntityList<TypeVariantParameterNode> parameters;
// }

// sealed class Expression extends AstNode {
//   @override
//   void visitChildren<R>(AstNodeVisitor<R> visitor) {}
// }

// final class IdentifierExpression extends Expression {
//   final Token identifier;
// }

// final class InvocationExpression extends Expression {
//   final IdentifierExpression identifierExpression;

//   final Expression argument;
// }

// final class LetExpression extends Expression {
//   final Token identifier;

//   final Token equals;

//   final Expression binding;

//   final Expression result;
// }

// sealed class Literal extends Expression {
//   Token get literal;
// }

// final class BooleanLiteral extends Literal {
//   @override
//   final Token literal;
// }

// final class UnitLiteral extends Literal {
//   @override
//   final Token literal;
// }

// final class StringLiteral extends Literal {
//   @override
//   final Token literal;
// }

// final class IntegerLiteral extends Literal {
//   @override
//   final Token literal;
// }

// final class DoubleLiteral extends Literal {
//   @override
//   final Token literal;
// }

// sealed class Declaration extends AstNode {}

// final class ImportDeclaration extends Declaration {
//   final Token keyword;

//   final ImportType type;

//   final Token identifier;
// }

// final class TypeDefinition extends Declaration {
//   final Token keyword;

//   final Token name;

//   final Token? leftParenthesis;

//   final SyntacticEntityList<IdentifiedTypeIdentifier>? parameters;

//   final Token? rightParenthesis;

//   final Token equals;

//   final SyntacticEntityList<TypeVariantNode> variants;
// }

// final class LetDeclaration extends Declaration {
//   final Token keyword;

//   final Token identifier;

//   final Token? parameter;

//   final Token equals;

//   final Expression body;
// }
