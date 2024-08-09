import 'node.dart';
import 'token.dart';

abstract interface class Statement {
  R accept<R>(StatementVisitor<R> visitor);
}

abstract interface class StatementVisitor<R> {
  R visitTypeDefinitionStatement(TypeDefinitionStatement statement);
}

final class TypeDefinitionStatement implements Statement {
  const TypeDefinitionStatement(
    this.name,
    this.typeParameters,
    this.variations,
  );
  final Token name;
  final List<Token>? typeParameters;
  final List<TypeVariationNode> variations;
  @override
  R accept<R>(StatementVisitor<R> visitor) {
    return visitor.visitTypeDefinitionStatement(this);
  }
}
