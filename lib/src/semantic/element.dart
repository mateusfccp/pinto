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

final class StructMemberElement extends Element {
  StructMemberElement();

  late final String name;

  late final ExpressionElement value;

  @override
  late LiteralElement enclosingElement;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitStructMemberElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    value.accept(visitor);
  }

  @override
  String toString() =>
      'StructMemberElement(name: $name, value: $value, enclosingElement: $enclosingElement)';
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
  Object? get constantValue;
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
    required this.constantValue,
  });

  @override
  Type? type;

  final IdentifierElement identifier;

  final ExpressionElement argument;

  @override
  final bool constant;

  @override
  final Object? constantValue;

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
      'InvocationElement(type: $type, identifier: $identifier, argument: $argument, constant: $constant, constantValue: $constantValue, enclosingElement: $enclosingElement)';
}

final class IdentifierElement extends ExpressionElement {
  IdentifierElement({
    required this.name,
    this.type,
    required this.constant,
    required this.constantValue,
  });

  final String name;

  @override
  Type? type;

  @override
  final bool constant;

  @override
  final Object? constantValue;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitIdentifierElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'IdentifierElement(name: $name, type: $type, constant: $constant, constantValue: $constantValue, enclosingElement: $enclosingElement)';
}

sealed class LiteralElement extends ExpressionElement {
  LiteralElement();

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() => 'LiteralElement(enclosingElement: $enclosingElement)';
}

final class SingletonLiteralElement extends LiteralElement {
  SingletonLiteralElement({this.type});

  @override
  Type? type;

  @override
  late final bool constant;

  @override
  late final Object? constantValue;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitSingletonLiteralElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'SingletonLiteralElement(type: $type, constant: $constant, constantValue: $constantValue, enclosingElement: $enclosingElement)';
}

final class StructLiteralElement extends LiteralElement {
  StructLiteralElement();

  @override
  late final StructType type;

  final List<StructMemberElement> members = [];

  @override
  late final bool constant;

  @override
  late final Object? constantValue;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitStructLiteralElement(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    for (final node in members) {
      node.visitChildren(visitor);
    }
  }

  @override
  String toString() =>
      'StructLiteralElement(type: $type, members: $members, constant: $constant, constantValue: $constantValue, enclosingElement: $enclosingElement)';
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

sealed class LetDeclarationElement extends DeclarationElement
    implements TypedElement {
  LetDeclarationElement({required this.name});

  final String name;

  late final ExpressionElement body;

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    body.accept(visitor);
  }

  @override
  String toString() =>
      'LetDeclarationElement(name: $name, body: $body, enclosingElement: $enclosingElement)';
}

final class LetFunctionDeclaration extends LetDeclarationElement {
  LetFunctionDeclaration({
    required super.name,
    required this.parameter,
  });

  final StructLiteralElement parameter;

  @override
  late FunctionType type;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLetFunctionDeclaration(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {
    parameter.accept(visitor);
  }

  @override
  String toString() =>
      'LetFunctionDeclaration(name: $name, parameter: $parameter, type: $type, name: $name, body: $body, enclosingElement: $enclosingElement)';
}

final class LetVariableDeclaration extends LetDeclarationElement {
  LetVariableDeclaration({
    required super.name,
    this.type,
  });

  @override
  Type? type;

  @override
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLetVariableDeclaration(this);

  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'LetVariableDeclaration(name: $name, type: $type, name: $name, body: $body, enclosingElement: $enclosingElement)';
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
