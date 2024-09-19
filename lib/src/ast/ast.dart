import 'package:pinto/ast.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/syntactic_entity.dart';


sealed class AstNode implements SyntacticEntity {
  const AstNode();

  @override
  int get length => end - offset;

  R? accept<R>(AstNodeVisitor<R> visitor);
  void visitChildren<R>(AstNodeVisitor<R> visitor);
}

sealed class TypeIdentifier extends AstNode {
  const TypeIdentifier();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
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
}

sealed class Node extends AstNode {
  const Node();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
}

final class TypeVariantParameterNode extends Node {
  const TypeVariantParameterNode(
    this.type,
    this.name,
  );

  final TypeIdentifier type;

  final Token name;

  @override
  int get offset => type.offset;

  @override
  int get end => name.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeVariantParameterNode(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    type.accept(visitor);
  }
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
}

sealed class Expression extends AstNode {
  const Expression();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
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
}

sealed class Literal extends Expression {
  const Literal();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
}

final class UnitLiteral extends Literal {
  const UnitLiteral(this.literal);

  final Token literal;

  @override
  int get offset => literal.offset;

  @override
  int get end => literal.end;

  @override
  R? accept<R>(AstNodeVisitor<R> visitor) => visitor.visitUnitLiteral(this);

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
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
}

sealed class Declaration extends AstNode {
  const Declaration();

  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
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

  final Token? parameter;

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
    body.accept(visitor);
  }
}
