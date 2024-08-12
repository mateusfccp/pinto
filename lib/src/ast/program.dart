import 'statement.dart';

abstract interface class ProgramVisitor<R> {
  R visitProgram(Program program);
}

final class Program {
  const Program(
    this.imports,
    this.body,
  );

  final List<ImportStatement> imports;

  final List<Statement> body;

  R accept<R>(ProgramVisitor<R> visitor) => visitor.visitProgram(this);
}
