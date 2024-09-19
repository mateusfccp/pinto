import 'package.dart';
import 'type.dart';
import 'visitors.dart';

sealed class Element {
  const Element();

  Element? get enclosingElement;
  R? accept<R>(ElementVisitor<R> visitor);
  void visitChildren<R>(ElementVisitor<R> visitor);
}

final class ParameterElement extends Element {
  ParameterElement({required this.name});

  final String name;

  PintoType? type;

  @override
  late Element enclosingElement;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitParameterElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class TypeVariantElement extends Element {
  TypeVariantElement({required this.name});

  final String name;

  final List<ParameterElement> parameters = [];

  @override
  late TypeDefinitionElement enclosingElement;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeVariantElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    final parametersNodes = parameters;
    for (final node in parametersNodes) {
      node.visitChildren(visitor);
    }
  }
}

sealed class DeclarationElement extends Element {
  DeclarationElement();

  @override
  late ProgramElement enclosingElement;

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class ImportElement extends DeclarationElement {
  ImportElement({required this.package});

  final Package package;

  @override
  R? accept<R>(ElementVisitor<R> visitor) => visitor.visitImportElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class TypeDefinitionElement extends DeclarationElement {
  TypeDefinitionElement({required this.name});

  final String name;

  final List<TypeParameterType> parameters = [];

  final List<TypeVariantElement> variants = [];

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeDefinitionElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    final variantsNodes = variants;
    for (final node in variantsNodes) {
      node.visitChildren(visitor);
    }
  }
}

final class ProgramElement extends Element {
  ProgramElement();

  final List<ImportElement> imports = [];

  final List<TypeDefinitionElement> typeDefinitions = [];

  @override
  late final Null enclosingElement = null;

  @override
  R? accept<R>(ElementVisitor<R> visitor) => visitor.visitProgramElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    final importsNodes = imports;
    for (final node in importsNodes) {
      node.visitChildren(visitor);
    }
    final typeDefinitionsNodes = typeDefinitions;
    for (final node in typeDefinitionsNodes) {
      node.visitChildren(visitor);
    }
  }
}
