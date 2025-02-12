// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// VisitorGenerator
// **************************************************************************

import 'ast.dart';

abstract interface class AstNodeVisitor<R> {
  R? visitTopTypeIdentifier(TopTypeIdentifier node);
  R? visitBottomTypeIdentifier(BottomTypeIdentifier node);
  R? visitListTypeIdentifier(ListTypeIdentifier node);
  R? visitSetTypeIdentifier(SetTypeIdentifier node);
  R? visitMapTypeIdentifier(MapTypeIdentifier node);
  R? visitIdentifiedTypeIdentifier(IdentifiedTypeIdentifier node);
  R? visitOptionTypeIdentifier(OptionTypeIdentifier node);
  R? visitTypeVariantParameterNode(TypeVariantParameterNode node);
  R? visitTypeVariantNode(TypeVariantNode node);
  R? visitIdentifierExpression(IdentifierExpression node);
  R? visitInvocationExpression(InvocationExpression node);
  R? visitLetExpression(LetExpression node);
  R? visitBooleanLiteral(BooleanLiteral node);
  R? visitUnitLiteral(UnitLiteral node);
  R? visitStringLiteral(StringLiteral node);
  R? visitIntegerLiteral(IntegerLiteral node);
  R? visitDoubleLiteral(DoubleLiteral node);
  R? visitImportDeclaration(ImportDeclaration node);
  R? visitTypeDefinition(TypeDefinition node);
  R? visitLetDeclaration(LetDeclaration node);
}

abstract base class SimpleAstNodeVisitor<R> implements AstNodeVisitor {
  @override
  R? visitTopTypeIdentifier(TopTypeIdentifier node) => null;

  @override
  R? visitBottomTypeIdentifier(BottomTypeIdentifier node) => null;

  @override
  R? visitListTypeIdentifier(ListTypeIdentifier node) => null;

  @override
  R? visitSetTypeIdentifier(SetTypeIdentifier node) => null;

  @override
  R? visitMapTypeIdentifier(MapTypeIdentifier node) => null;

  @override
  R? visitIdentifiedTypeIdentifier(IdentifiedTypeIdentifier node) => null;

  @override
  R? visitOptionTypeIdentifier(OptionTypeIdentifier node) => null;

  @override
  R? visitTypeVariantParameterNode(TypeVariantParameterNode node) => null;

  @override
  R? visitTypeVariantNode(TypeVariantNode node) => null;

  @override
  R? visitIdentifierExpression(IdentifierExpression node) => null;

  @override
  R? visitInvocationExpression(InvocationExpression node) => null;

  @override
  R? visitLetExpression(LetExpression node) => null;

  @override
  R? visitBooleanLiteral(BooleanLiteral node) => null;

  @override
  R? visitUnitLiteral(UnitLiteral node) => null;

  @override
  R? visitStringLiteral(StringLiteral node) => null;

  @override
  R? visitIntegerLiteral(IntegerLiteral node) => null;

  @override
  R? visitDoubleLiteral(DoubleLiteral node) => null;

  @override
  R? visitImportDeclaration(ImportDeclaration node) => null;

  @override
  R? visitTypeDefinition(TypeDefinition node) => null;

  @override
  R? visitLetDeclaration(LetDeclaration node) => null;
}

abstract base class GeneralizingAstNodeVisitor<R> implements AstNodeVisitor {
  R? visitAstNode(AstNode node) {
    node.visitChildren(this);
    return null;
  }

  R? visitTypeIdentifier(TypeIdentifier node) => visitAstNode(node);

  @override
  R? visitTopTypeIdentifier(TopTypeIdentifier node) =>
      visitTypeIdentifier(node);

  @override
  R? visitBottomTypeIdentifier(BottomTypeIdentifier node) =>
      visitTypeIdentifier(node);

  @override
  R? visitListTypeIdentifier(ListTypeIdentifier node) =>
      visitTypeIdentifier(node);

  @override
  R? visitSetTypeIdentifier(SetTypeIdentifier node) =>
      visitTypeIdentifier(node);

  @override
  R? visitMapTypeIdentifier(MapTypeIdentifier node) =>
      visitTypeIdentifier(node);

  @override
  R? visitIdentifiedTypeIdentifier(IdentifiedTypeIdentifier node) =>
      visitTypeIdentifier(node);

  @override
  R? visitOptionTypeIdentifier(OptionTypeIdentifier node) =>
      visitTypeIdentifier(node);

  R? visitNode(Node node) => visitAstNode(node);

  @override
  R? visitTypeVariantParameterNode(TypeVariantParameterNode node) =>
      visitNode(node);

  @override
  R? visitTypeVariantNode(TypeVariantNode node) => visitNode(node);

  R? visitExpression(Expression node) => visitAstNode(node);

  @override
  R? visitIdentifierExpression(IdentifierExpression node) =>
      visitExpression(node);

  @override
  R? visitInvocationExpression(InvocationExpression node) =>
      visitExpression(node);

  @override
  R? visitLetExpression(LetExpression node) => visitExpression(node);

  R? visitLiteral(Literal node) => visitExpression(node);

  @override
  R? visitBooleanLiteral(BooleanLiteral node) => visitLiteral(node);

  @override
  R? visitUnitLiteral(UnitLiteral node) => visitLiteral(node);

  @override
  R? visitStringLiteral(StringLiteral node) => visitLiteral(node);

  @override
  R? visitIntegerLiteral(IntegerLiteral node) => visitLiteral(node);

  @override
  R? visitDoubleLiteral(DoubleLiteral node) => visitLiteral(node);

  R? visitDeclaration(Declaration node) => visitAstNode(node);

  @override
  R? visitImportDeclaration(ImportDeclaration node) => visitDeclaration(node);

  @override
  R? visitTypeDefinition(TypeDefinition node) => visitDeclaration(node);

  @override
  R? visitLetDeclaration(LetDeclaration node) => visitDeclaration(node);
}
