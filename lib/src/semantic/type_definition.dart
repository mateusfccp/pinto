import 'declaration.dart';
import 'element.dart';
import 'type.dart';

final class TypeDefinitionElement extends DeclarationElement {
  TypeDefinitionElement({required this.name});

  final String name;
  final parameters = <TypeParameterType>[];
  final variants = <TypeVariantElement>[];

  T accept<T>(DeclarationElementVisitor visitor) => visitor.visitTypeDefinitionElement(this);
}

final class TypeVariantElement implements Element {
  TypeVariantElement({required this.name});

  final String name;
  final parameters = <ParameterElement>[];

  @override
  late TypeDefinitionElement enclosingElement;

  T accept<T>(ElementVisitor visitor) => visitor.visitTypeVariantElement(this);
}

final class ParameterElement implements Element {
  ParameterElement({
    required this.name,
    this.type,
  });

  final String name;

  // Null means unresolved
  PintoType? type;

  @override
  late Element enclosingElement;

  T accept<T>(ElementVisitor visitor) => visitor.visitParameterElement(this);
}
