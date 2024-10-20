import 'package:pinto/lexer.dart';

import 'package.dart';
import 'type.dart';
import 'visitors.dart';

sealed class Element {
  const Element();

  Element? get enclosingElement;
  R? accept<R>(ElementVisitor<R> visitor);
  void visitChildren<R>(ElementVisitor<R> visitor);
  @override
  String toString() => 'Element';
}

abstract interface class TypedElement extends Element {
  Type? get type;
  @override
  String toString() => 'TypedElement';
}

abstract interface class TypeDefiningElement extends Element {
  Type get definedType;
  @override
  String toString() => 'TypeDefiningElement';
}

final class TypeParameterElement extends Element
    implements TypedElement, TypeDefiningElement {
  TypeParameterElement({required this.name});

  final String name;

  @override
  late TypeDefinitionElement enclosingElement;

  @override
  Type? type = TypeType();

  @override
  late Type definedType;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeParameterElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'TypeParameterElement(name: $name, enclosingElement: $enclosingElement, type: $type, definedType: $definedType)';
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
  @override
  String toString() =>
      'ParameterElement(name: $name, type: $type, enclosingElement: $enclosingElement)';
}

sealed class ExpressionElement extends Element implements TypedElement {
  ExpressionElement();

  @override
  late Element enclosingElement;

  bool get constant;
  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() => 'ExpressionElement(enclosingElement: $enclosingElement)';
}

final class InvocationElement extends ExpressionElement {
  InvocationElement({
    this.type,
    required this.identifier,
    required this.argument,
    required this.constant,
  });

  @override
  Type? type;

  final IdentifierElement identifier;

  final ExpressionElement argument;

  @override
  final bool constant;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitInvocationElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    identifier.accept(visitor);
    argument.accept(visitor);
  }

  @override
  String toString() =>
      'InvocationElement(type: $type, identifier: $identifier, argument: $argument, constant: $constant, enclosingElement: $enclosingElement)';
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
  @override
  String toString() =>
      'IdentifierElement(name: $name, type: $type, constant: $constant, enclosingElement: $enclosingElement)';
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
  @override
  String toString() =>
      'LiteralElement(type: $type, constant: $constant, constantValue: $constantValue, enclosingElement: $enclosingElement)';
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

  @override
  String toString() =>
      'TypeVariantElement(name: $name, parameters: $parameters, enclosingElement: $enclosingElement)';
}

sealed class DeclarationElement extends Element {
  DeclarationElement();

  @override
  late ProgramElement enclosingElement;

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'DeclarationElement(enclosingElement: $enclosingElement)';
}

final class ImportElement extends DeclarationElement {
  ImportElement({required this.package});

  final Package package;

  @override
  R? accept<R>(ElementVisitor<R> visitor) => visitor.visitImportElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'ImportElement(package: $package, enclosingElement: $enclosingElement)';
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

  @override
  String toString() =>
      'LetFunctionDeclaration(name: $name, parameter: $parameter, type: $type, body: $body, enclosingElement: $enclosingElement)';
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

  @override
  String toString() =>
      'LetVariableDeclaration(name: $name, type: $type, body: $body, enclosingElement: $enclosingElement)';
}

final class ImportedSymbolSyntheticElement extends DeclarationElement
    implements TypedElement {
  ImportedSymbolSyntheticElement({
    required this.name,
    required this.syntheticElement,
  });

  final String name;

  final TypedElement syntheticElement;

  @override
  Type get type => syntheticElement.type!;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitImportedSymbolSyntheticElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    syntheticElement.accept(visitor);
  }

  @override
  String toString() =>
      'ImportedSymbolSyntheticElement(name: $name, syntheticElement: $syntheticElement, enclosingElement: $enclosingElement)';
}

final class TypeDefinitionElement extends DeclarationElement
    implements TypedElement, TypeDefiningElement {
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

  @override
  String toString() =>
      'TypeDefinitionElement(name: $name, parameters: $parameters, variants: $variants, type: $type, definedType: $definedType, enclosingElement: $enclosingElement)';
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

  @override
  String toString() =>
      'ProgramElement(imports: $imports, declarations: $declarations, enclosingElement: $enclosingElement)';
}
