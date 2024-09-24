import 'package:pinto/lexer.dart';

import 'package.dart';
import 'type.dart';
import 'visitors.dart';

sealed class Element {
  const Element();

  Element? get enclosingElement;
  R? accept<R>(ElementVisitor<R> visitor);
  void visitChildren<R>(ElementVisitor<R> visitor);
}

abstract interface class TypedElement extends Element {
  Type? get type;
}

final class ParameterElement extends Element implements TypedElement {
  ParameterElement({
    required this.name,
    this.type,
  });

  final String name;

  @override
  Type? type;

  @override
  late Element enclosingElement;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitParameterElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

sealed class ExpressionElement extends Element implements TypedElement {
  ExpressionElement();

  @override
  late Element enclosingElement;

  bool get constant;
  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class IdentifierElement extends ExpressionElement {
  IdentifierElement({
    required this.name,
    this.type,
    required this.constant,
  });

  final String name;

  @override
  Type? type;

  @override
  final bool constant;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitIdentifierElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class LiteralElement extends ExpressionElement {
  LiteralElement({
    this.type,
    required this.constant,
    required this.constantValue,
  });

  @override
  Type? type;

  @override
  final bool constant;

  final Object? constantValue;

  @override
  R? accept<R>(ElementVisitor<R> visitor) => visitor.visitLiteralElement(this);

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
    for (final node in parameters) {
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

final class LetFunctionDeclaration extends DeclarationElement
    implements TypedElement {
  LetFunctionDeclaration({
    required this.name,
    required this.parameter,
    required this.type,
    required this.body,
  });

  final String name;

  final Token parameter;

  @override
  FunctionType type;

  final ExpressionElement body;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLetFunctionDeclaration(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    body.accept(visitor);
  }
}

final class LetVariableDeclaration extends DeclarationElement
    implements TypedElement {
  LetVariableDeclaration({
    required this.name,
    this.type,
    required this.body,
  });

  final String name;

  @override
  Type? type;

  final ExpressionElement body;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLetVariableDeclaration(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    body.accept(visitor);
  }
}

sealed class TypeDefiningDeclaration extends DeclarationElement {
  TypeDefiningDeclaration();

  Type get definedType;
  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class ImportedSymbolSyntheticElement extends TypeDefiningDeclaration
    implements TypedElement {
  ImportedSymbolSyntheticElement({
    required this.name,
    this.type,
  });

  final String name;

  @override
  Type? type;

  @override
  late Type definedType;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitImportedSymbolSyntheticElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class TypeParameterElement extends TypeDefiningDeclaration
    implements TypedElement {
  TypeParameterElement({required this.name});

  final String name;

  @override
  Type? type = TypeType();

  @override
  late Type definedType;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeParameterElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
}

final class TypeDefinitionElement extends TypeDefiningDeclaration
    implements TypedElement {
  TypeDefinitionElement({required this.name});

  final String name;

  final List<TypeParameterElement> parameters = [];

  final List<TypeVariantElement> variants = [];

  @override
  Type? type = TypeType();

  @override
  late Type definedType;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeDefinitionElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    for (final node in parameters) {
      node.visitChildren(visitor);
    }
    for (final node in variants) {
      node.visitChildren(visitor);
    }
  }
}

final class ProgramElement extends Element {
  ProgramElement();

  final List<ImportElement> imports = [];

  final List<DeclarationElement> declarations = [];

  @override
  late final Null enclosingElement = null;

  @override
  R? accept<R>(ElementVisitor<R> visitor) => visitor.visitProgramElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    for (final node in imports) {
      node.visitChildren(visitor);
    }
    for (final node in declarations) {
      node.visitChildren(visitor);
    }
  }
}
