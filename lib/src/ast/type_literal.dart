import 'token.dart';

sealed class TypeLiteral {
  R accept<R>(TypeLiteralVisitor<R> visitor);
}

abstract interface class TypeLiteralVisitor<R> {
  R visitTopTypeLiteral(TopTypeLiteral typeLiteral);
  R visitBottomTypeLiteral(BottomTypeLiteral typeLiteral);
  R visitListTypeLiteral(ListTypeLiteral typeLiteral);
  R visitSetTypeLiteral(SetTypeLiteral typeLiteral);
  R visitMapTypeLiteral(MapTypeLiteral typeLiteral);
  R visitParameterizedTypeLiteral(ParameterizedTypeLiteral typeLiteral);
  R visitNamedTypeLiteral(NamedTypeLiteral typeLiteral);
  R visitOptionTypeLiteral(OptionTypeLiteral typeLiteral);
}

final class TopTypeLiteral implements TypeLiteral {
  const TopTypeLiteral();

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitTopTypeLiteral(this);
}

final class BottomTypeLiteral implements TypeLiteral {
  const BottomTypeLiteral();

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitBottomTypeLiteral(this);
}

final class ListTypeLiteral implements TypeLiteral {
  const ListTypeLiteral(this.literal);

  final TypeLiteral literal;

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitListTypeLiteral(this);
}

final class SetTypeLiteral implements TypeLiteral {
  const SetTypeLiteral(this.literal);

  final TypeLiteral literal;

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitSetTypeLiteral(this);
}

final class MapTypeLiteral implements TypeLiteral {
  const MapTypeLiteral(
    this.keyLiteral,
    this.valueLiteral,
  );

  final TypeLiteral keyLiteral;

  final TypeLiteral valueLiteral;

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitMapTypeLiteral(this);
}

final class ParameterizedTypeLiteral implements TypeLiteral {
  const ParameterizedTypeLiteral(
    this.literal,
    this.parameters,
  );

  final NamedTypeLiteral literal;

  final List<TypeLiteral> parameters;

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitParameterizedTypeLiteral(this);
}

final class NamedTypeLiteral implements TypeLiteral {
  const NamedTypeLiteral(this.identifier);

  final Token identifier;

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitNamedTypeLiteral(this);
}

final class OptionTypeLiteral implements TypeLiteral {
  const OptionTypeLiteral(this.literal);

  final TypeLiteral literal;

  @override
  R accept<R>(TypeLiteralVisitor<R> visitor) =>
      visitor.visitOptionTypeLiteral(this);
}
