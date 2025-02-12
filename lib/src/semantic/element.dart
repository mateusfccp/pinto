import 'package:pinto/annotations.dart';
import 'package:pinto/lexer.dart';

import 'package.dart';
import 'type.dart';
import 'visitors.dart';

part 'element.g.dart';

sealed class Element {
  const Element();

  Element? get enclosingElement;

  R? accept<R>(ElementVisitor<R> visitor);
  
  void visitChildren<R>(ElementVisitor<R> visitor);
}

abstract interface class TypedElement extends Element {
  Type? get type;
}

abstract interface class TypeDefiningElement extends Element {
  Type get definedType;
}

@TreeNode()
final class TypeParameterElement extends Element with _TypeParameterElement
    implements TypedElement, TypeDefiningElement {
  TypeParameterElement({required this.name});

  final String name;

  @override
  late TypeDefinitionElement enclosingElement;

  @override
  Type? type = TypeType();

  @override
  late Type definedType;
}

@TreeNode()
final class ParameterElement extends Element with _ParameterElement implements TypedElement {
  ParameterElement({
    required this.name,
    this.type,
  });

  final String name;

  @override
  Type? type;

  @override
  late Element enclosingElement;
}

@TreeNode()
sealed class ExpressionElement extends Element with _ExpressionElement implements TypedElement {
  ExpressionElement();

  @override
  late Element enclosingElement;

  bool get constant;
  @override
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() => 'ExpressionElement(enclosingElement: $enclosingElement)';
}

@TreeNode()
final class InvocationElement extends ExpressionElement with _InvocationElement {
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
}

@TreeNode()
final class IdentifierElement extends ExpressionElement with _IdentifierElement {
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
}

@TreeNode()
final class LiteralElement extends ExpressionElement with _LiteralElement {
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
}

@TreeNode()
final class TypeVariantElement extends Element with _TypeVariantElement {
  TypeVariantElement({required this.name});

  final String name;

  final List<ParameterElement> parameters = [];

  @override
  late TypeDefinitionElement enclosingElement;
}

@TreeNode()
sealed class DeclarationElement extends Element with _DeclarationElement {
  DeclarationElement();

  @override
  late ProgramElement enclosingElement;
}

@TreeNode()
final class ImportElement extends DeclarationElement with _ImportElement {
  ImportElement({required this.package});

  final Package package;
}

@TreeNode()
final class LetFunctionDeclaration extends DeclarationElement with _LetFunctionDeclaration
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
}

@TreeNode()
final class LetVariableDeclaration extends DeclarationElement with _LetVariableDeclaration
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
}

@TreeNode()
final class ImportedSymbolSyntheticElement extends DeclarationElement with _DeclarationElement
    implements TypedElement {
  ImportedSymbolSyntheticElement({
    required this.name,
    required this.syntheticElement,
  });

  final String name;

  final TypedElement syntheticElement;

  @override
  Type get type => syntheticElement.type!;
}

@TreeNode()
final class TypeDefinitionElement extends DeclarationElement with _TypeDefinitionElement
    implements TypedElement, TypeDefiningElement {
  TypeDefinitionElement({required this.name});

  final String name;

  final List<TypeParameterElement> parameters = [];

  final List<TypeVariantElement> variants = [];

  @override
  Type? type = TypeType();

  @override
  late Type definedType;
}

@TreeNode()
final class ProgramElement extends Element with _ProgramElement {
  ProgramElement();

  final List<ImportElement> imports = [];

  final List<DeclarationElement> declarations = [];

  @override
  late final Null enclosingElement = null;
}
