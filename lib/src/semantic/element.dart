import 'declaration.dart';
import 'program.dart';
import 'type_definition.dart';

abstract interface class Element {
  Element? get enclosingElement;
}

abstract interface class ElementVisitor<T> implements DeclarationElementVisitor<T> {
  T visitParameterElement(ParameterElement parameterElement);
  T visitProgramElement(ProgramElement programElement);
  T visitTypeVariantElement(TypeVariantElement typeVariantElement);
}
