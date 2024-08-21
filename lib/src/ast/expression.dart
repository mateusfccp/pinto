import 'token.dart';

sealed class Expression {
  R accept<R>(ExpressionVisitor<R> visitor);
}

abstract interface class ExpressionVisitor<R> {
  R visitLetExpression(LetExpression expression);
  R visitLiteralExpression(LiteralExpression expression);
}

final class LetExpression implements Expression {
  const LetExpression(
    this.identifier,
    this.binding,
    this.result,
  );

  final Token identifier;

  final Expression binding;

  final Expression result;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) => visitor.visitLetExpression(this);
}

final class LiteralExpression implements Expression {
  const LiteralExpression(this.literal);

  final Token literal;

  @override
  R accept<R>(ExpressionVisitor<R> visitor) =>
      visitor.visitLiteralExpression(this);
}
