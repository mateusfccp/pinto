import 'token.dart';
import 'type_literal.dart';

sealed class Node {
  R accept<R>(NodeVisitor<R> visitor);
}

abstract interface class NodeVisitor<R> {
  R visitTypeVariantNode(TypeVariantNode node);
  R visitTypeVariantParameterNode(TypeVariantParameterNode node);
}

final class TypeVariantNode implements Node {
  const TypeVariantNode(
    this.name,
    this.parameters,
  );

  final Token name;

  final List<TypeVariantParameterNode> parameters;

  @override
  R accept<R>(NodeVisitor<R> visitor) => visitor.visitTypeVariantNode(this);
}

final class TypeVariantParameterNode implements Node {
  const TypeVariantParameterNode(
    this.type,
    this.name,
  );

  final TypeLiteral type;

  final Token name;

  @override
  R accept<R>(NodeVisitor<R> visitor) =>
      visitor.visitTypeVariantParameterNode(this);
}
