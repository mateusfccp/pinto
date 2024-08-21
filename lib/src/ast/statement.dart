import 'expression.dart';
import 'import.dart';
import 'node.dart';
import 'token.dart';
import 'type_literal.dart';

sealed class Statement {
  R accept<R>(StatementVisitor<R> visitor);
}

abstract interface class StatementVisitor<R> {
  R visitFunctionStatement(FunctionStatement statement);
  R visitImportStatement(ImportStatement statement);
  R visitTypeDefinitionStatement(TypeDefinitionStatement statement);
}

final class FunctionStatement implements Statement {
  const FunctionStatement(
    this.identifier,
    this.result,
  );

  final Token identifier;

  final Expression result;

  @override
  R accept<R>(StatementVisitor<R> visitor) => visitor.visitFunctionStatement(this);
}

final class ImportStatement implements Statement {
  const ImportStatement(
    this.type,
    this.identifier,
  );

  final ImportType type;

  final Token identifier;

  @override
  R accept<R>(StatementVisitor<R> visitor) => visitor.visitImportStatement(this);
}

final class TypeDefinitionStatement implements Statement {
  const TypeDefinitionStatement(
    this.name,
    this.parameters,
    this.variants,
  );

  final Token name;

  final List<IdentifiedTypeLiteral>? parameters;

  final List<TypeVariantNode> variants;

  @override
  R accept<R>(StatementVisitor<R> visitor) => visitor.visitTypeDefinitionStatement(this);
}
