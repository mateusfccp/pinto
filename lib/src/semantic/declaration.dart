import 'element.dart';
import 'import.dart';
import 'program.dart';
import 'type_definition.dart';

abstract class DeclarationElement implements Element {
  @override
  ProgramElement? enclosingElement;
}

abstract interface class DeclarationElementVisitor<T> {
  T visitImportElement(ImportElement importElement);
  T visitTypeDefinitionElement(TypeDefinitionElement typeDefinitionElement);
}
