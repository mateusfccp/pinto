import 'token.dart';

abstract interface class Node {
  R accept<R>(NodeVisitor<R> visitor);
}

abstract interface class NodeVisitor<R> {
  R visitTypeVariationNode(TypeVariationNode node);
  R visitTypeVariationParameterNode(TypeVariationParameterNode node);
}

final class TypeVariationNode implements Node {
  const TypeVariationNode(
    this.name,
    this.parameters,
  );
  final Token name;
  final List<TypeVariationParameterNode> parameters;
  @override
  R accept<R>(NodeVisitor<R> visitor) {
    return visitor.visitTypeVariationNode(this);
  }
}

final class TypeVariationParameterNode implements Node {
  const TypeVariationParameterNode(
    this.type,
    this.name,
  );
  final Token type;
  final Token name;
  @override
  R accept<R>(NodeVisitor<R> visitor) {
    return visitor.visitTypeVariationParameterNode(this);
  }
}
