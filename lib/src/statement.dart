import 'token.dart';

abstract interface class Statement {
  R accept<R>(StatementVisitor<R> visitor);
}

abstract interface class StatementVisitor<R> {
  R visitTypeStatement(TypeStatement statement);
  R visitTypeDefinitionStatement(TypeDefinitionStatement statement);
}

final class TypeStatement implements Statement {
  const TypeStatement(
    this.name,
    this.typeParameters,
    this.definitions,
  );
  final Token name;
  final List<Token>? typeParameters;
  final List<TypeDefinitionStatement> definitions;
  @override
  R accept<R>(StatementVisitor<R> visitor) {
    return visitor.visitTypeStatement(this);
  }
}

final class TypeDefinitionStatement implements Statement {
  const TypeDefinitionStatement(
    this.name,
    this.parameters,
  );
  final Token name;
  final List<(Token, Token)> parameters;
  @override
  R accept<R>(StatementVisitor<R> visitor) {
    return visitor.visitTypeDefinitionStatement(this);
  }
}
