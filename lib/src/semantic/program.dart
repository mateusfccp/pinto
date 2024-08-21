import 'element.dart';
import 'import.dart';
import 'type_definition.dart';

final class ProgramElement implements Element {
  final imports = <ImportElement>[];
  final typeDefinitions = <TypeDefinitionElement>[];

  @override
  Null get enclosingElement => null;

  T accept<T>(ElementVisitor visitor) => visitor.visitProgramElement(this);
}
