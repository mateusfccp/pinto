import 'import.dart';
import 'node.dart';
import 'token.dart';

abstract interface class Statement {
  R accept<R>(StatementVisitor<R> visitor);
}

abstract interface class StatementVisitor<R> {
  R visitImportStatement(ImportStatement statement);
  R visitTypeDefinitionStatement(TypeDefinitionStatement statement);
}

final class ImportStatement implements Statement {
  const ImportStatement(
    this.type,
    this.package,
  );
  final ImportType type;
  final String package;
  @override
  R accept<R>(StatementVisitor<R> visitor) {
    return visitor.visitImportStatement(this);
  }
}

final class TypeDefinitionStatement implements Statement {
  const TypeDefinitionStatement(
    this.name,
    this.typeParameters,
    this.variants,
  );
  final Token name;
  final List<Token>? typeParameters;
  final List<TypeVariationNode> variants;
  @override
  R accept<R>(StatementVisitor<R> visitor) {
    return visitor.visitTypeDefinitionStatement(this);
  }
}
