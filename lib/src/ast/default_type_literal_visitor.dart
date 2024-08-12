import 'type_literal.dart';

base mixin DefaultTypeLiteralVisitor<T> implements TypeLiteralVisitor<T> {
  T visitTypeLiteral(TypeLiteral typeLiteral);

  @override
  T visitBottomTypeLiteral(BottomTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitListTypeLiteral(ListTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitMapTypeLiteral(MapTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitNamedTypeLiteral(NamedTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitOptionTypeLiteral(OptionTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitParameterizedTypeLiteral(ParameterizedTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitSetTypeLiteral(SetTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }

  @override
  visitTopTypeLiteral(TopTypeLiteral typeLiteral) {
    return visitTypeLiteral(typeLiteral);
  }
}
