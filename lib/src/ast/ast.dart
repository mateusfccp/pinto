import 'package:pinto/ast.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/syntactic_entity.dart';

sealed class AstNode implements SyntacticEntity {
  const AstNode();

  @override
  int get length => end - offset;

  R? accept<R>(AstNodeVisitor<R> visitor);
  void visitChildren<R>(AstNodeVisitor<R> visitor);
  @override
  String toString() => 'AstNode';
}

sealed class TypeIdentifier extends AstNode {
  const TypeIdentifier();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'TypeIdentifier';
}

final class TopTypeIdentifier extends TypeIdentifier {
  const TopTypeIdentifier(this.verum);

  final Token verum;

  @override
  int get offset => verum.offset;

  @override
  int get end => verum.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTopTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'TopTypeIdentifier(verum: $verum)';
}

final class BottomTypeIdentifier extends TypeIdentifier {
  const BottomTypeIdentifier(this.falsum);

  final Token falsum;

  @override
  int get offset => falsum.offset;

  @override
  int get end => falsum.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitBottomTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'BottomTypeIdentifier(falsum: $falsum)';
}

final class ListTypeIdentifier extends TypeIdentifier {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitListTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    identifier.accept(visitor);
  }

  @override
  String toString() =>
      'ListTypeIdentifier(leftBracket: $leftBracket, identifier: $identifier, rightBracket: $rightBracket)';
}

final class SetTypeIdentifier extends TypeIdentifier {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitSetTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    identifier.accept(visitor);
  }

  @override
  String toString() =>
      'SetTypeIdentifier(leftBrace: $leftBrace, identifier: $identifier, rightBrace: $rightBrace)';
}

final class MapTypeIdentifier extends TypeIdentifier {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitMapTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    key.accept(visitor);
    value.accept(visitor);
  }

  @override
  String toString() =>
      'MapTypeIdentifier(leftBrace: $leftBrace, key: $key, colon: $colon, value: $value, rightBrace: $rightBrace)';
}

final class IdentifiedTypeIdentifier extends TypeIdentifier {
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
  int get end =>
      rightParenthesis?.end ??
      arguments?.end ??
      leftParenthesis?.end ??
      identifier.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIdentifiedTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    if (arguments case final argumentsNodes?) {
      for (final node in argumentsNodes) {
        node.visitChildren(visitor);
      }
    }
  }

  @override
  String toString() =>
      'IdentifiedTypeIdentifier(identifier: $identifier, leftParenthesis: $leftParenthesis, arguments: $arguments, rightParenthesis: $rightParenthesis)';
}

final class OptionTypeIdentifier extends TypeIdentifier {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitOptionTypeIdentifier(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    identifier.accept(visitor);
  }

  @override
  String toString() =>
      'OptionTypeIdentifier(identifier: $identifier, eroteme: $eroteme)';
}

sealed class Node extends AstNode {
  const Node();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Node';
}

sealed class StructMember extends Node {
  const StructMember();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'StructMember';
}

final class NamelessStructMember extends StructMember {
  const NamelessStructMember(this.value);

  final Expression value;

  @override
  int get offset => value.offset;

  @override
  int get end => value.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitNamelessStructMember(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    value.accept(visitor);
  }

  @override
  String toString() => 'NamelessStructMember(value: $value)';
}

final class ValuelessStructMember extends StructMember {
  const ValuelessStructMember(this.name);

  final SymbolLiteral name;

  @override
  int get offset => name.offset;

  @override
  int get end => name.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitValuelessStructMember(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    name.accept(visitor);
  }

  @override
  String toString() => 'ValuelessStructMember(name: $name)';
}

final class FullStructMember extends StructMember {
  const FullStructMember(
    this.name,
    this.value,
  );

  final SymbolLiteral name;

  final Expression value;

  @override
  int get offset => name.offset;

  @override
  int get end => value.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitFullStructMember(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    name.accept(visitor);
    value.accept(visitor);
  }

  @override
  String toString() => 'FullStructMember(name: $name, value: $value)';
}

final class TypeVariantParameterNode extends Node {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeVariantParameterNode(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    typeIdentifier.accept(visitor);
  }

  @override
  String toString() =>
      'TypeVariantParameterNode(typeIdentifier: $typeIdentifier, name: $name)';
}

final class TypeVariantNode extends Node {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitTypeVariantNode(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    for (final node in parameters) {
      node.visitChildren(visitor);
    }
  }

  @override
  String toString() => 'TypeVariantNode(name: $name, parameters: $parameters)';
}

sealed class Expression extends AstNode {
  const Expression();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Expression';
}

final class IdentifierExpression extends Expression {
  const IdentifierExpression(this.identifier);

  final Token identifier;

  @override
  int get offset => identifier.offset;

  @override
  int get end => identifier.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIdentifierExpression(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'IdentifierExpression(identifier: $identifier)';
}

final class InvocationExpression extends Expression {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitInvocationExpression(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    identifierExpression.accept(visitor);
    argument.accept(visitor);
  }

  @override
  String toString() =>
      'InvocationExpression(identifierExpression: $identifierExpression, argument: $argument)';
}

final class LetExpression extends Expression {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitLetExpression(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    binding.accept(visitor);
    result.accept(visitor);
  }

  @override
  String toString() =>
      'LetExpression(identifier: $identifier, equals: $equals, binding: $binding, result: $result)';
}

sealed class Literal extends Expression {
  const Literal();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Literal';
}

final class BooleanLiteral extends Literal {
  const BooleanLiteral(this.literal);

  final Token literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitBooleanLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'BooleanLiteral(literal: $literal)';
}

final class DoubleLiteral extends Literal {
  const DoubleLiteral(this.literal);

  final Token literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitDoubleLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'DoubleLiteral(literal: $literal)';
}

final class IntegerLiteral extends Literal {
  const IntegerLiteral(this.literal);

  final Token literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitIntegerLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'IntegerLiteral(literal: $literal)';
}

final class StringLiteral extends Literal {
  const StringLiteral(this.literal);

  final Token literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitStringLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'StringLiteral(literal: $literal)';
}

final class StructLiteral extends Literal {
  const StructLiteral(
    this.leftParenthesis,
    this.members,
    this.rightParenthesis,
  );

  final Token leftParenthesis;

  final SyntacticEntityList<StructMember>? members;

  final Token rightParenthesis;

  @override
  int get offset => leftParenthesis.offset;

  @override
  int get end => rightParenthesis.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitStructLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    if (members case final membersNodes?) {
      for (final node in membersNodes) {
        node.visitChildren(visitor);
      }
    }
  }

  @override
  String toString() =>
      'StructLiteral(leftParenthesis: $leftParenthesis, members: $members, rightParenthesis: $rightParenthesis)';
}

final class SymbolLiteral extends Literal {
  const SymbolLiteral(this.literal);

  final Token literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitSymbolLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'SymbolLiteral(literal: $literal)';
}

sealed class Declaration extends AstNode {
  const Declaration();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Declaration';
}

final class ImportDeclaration extends Declaration {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitImportDeclaration(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'ImportDeclaration(keyword: $keyword, type: $type, identifier: $identifier)';
}

final class TypeDefinition extends Declaration {
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

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitTypeDefinition(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    if (parameters case final parametersNodes?) {
      for (final node in parametersNodes) {
        node.visitChildren(visitor);
      }
    }
    for (final node in variants) {
      node.visitChildren(visitor);
    }
  }

  @override
  String toString() =>
      'TypeDefinition(keyword: $keyword, name: $name, leftParenthesis: $leftParenthesis, parameters: $parameters, rightParenthesis: $rightParenthesis, equals: $equals, variants: $variants)';
}

final class LetDeclaration extends Declaration {
  const LetDeclaration(
    this.keyword,
    this.identifier,
    this.parameter,
    this.equals,
    this.body,
  );

  final Token keyword;

  final Token identifier;

  final StructLiteral? parameter;

  final Token equals;

  final Expression body;

  @override
  int get offset => keyword.offset;

  @override
  int get end => body.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitLetDeclaration(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    parameter?.accept(visitor);
    body.accept(visitor);
  }

  @override
  String toString() =>
      'LetDeclaration(keyword: $keyword, identifier: $identifier, parameter: $parameter, equals: $equals, body: $body)';
}
