import 'package:pinto/annotations.dart';
import 'package:pinto/lexer.dart';

import 'package.dart';
import 'type.dart';
import 'element.visitors.dart';

part 'element.g.dart';

@TreeRoot()
sealed class Element with _Element {
  const Element();

  Element? get enclosingElement;

  R? accept<R>(ElementVisitor<R> visitor);

  void visitChildren<R>(ElementVisitor<R> visitor);
}

abstract final class TypedElement extends Element {
  Type? get type;
}

abstract final class TypeDefiningElement extends Element {
  Type get definedType;
}

final class TypeParameterElement extends Element with _TypeParameterElement implements TypedElement, TypeDefiningElement {
  TypeParameterElement({required this.name});

  final String name;

  @override
  late TypeDefinitionElement enclosingElement;

  @override
  Type? type = TypeType();

  @override
  late Type definedType;
}

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

final class TypeVariantElement extends Element with _TypeVariantElement {
  TypeVariantElement({required this.name});

  final String name;

  final parameters = <ParameterElement>[];

  @override
  late TypeDefinitionElement enclosingElement;
}

sealed class DeclarationElement extends Element with _DeclarationElement {
  DeclarationElement();

  @override
  late ProgramElement enclosingElement;
}

final class ImportElement extends DeclarationElement with _ImportElement {
  ImportElement({required this.package});

  final Package package;
}

final class LetFunctionDeclaration extends DeclarationElement with _LetFunctionDeclaration implements TypedElement {
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

final class LetVariableDeclaration extends DeclarationElement with _LetVariableDeclaration implements TypedElement {
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

final class ImportedSymbolSyntheticElement extends DeclarationElement with _ImportedSymbolSyntheticElement implements TypedElement {
  ImportedSymbolSyntheticElement({
    required this.name,
    required this.syntheticElement,
  });

  final String name;

  final TypedElement syntheticElement;

  @override
  Type get type => syntheticElement.type!;
}

final class TypeDefinitionElement extends DeclarationElement with _TypeDefinitionElement implements TypedElement, TypeDefiningElement {
  TypeDefinitionElement({required this.name});

  final String name;

  final parameters = <TypeParameterElement>[];

  final variants = <TypeVariantElement>[];

  @override
  Type? type = TypeType();

  @override
  late Type definedType;
}

final class ProgramElement extends Element with _ProgramElement {
  ProgramElement();

  final imports = <ImportElement>[];

  final declarations = <DeclarationElement>[];

  @override
  late final Null enclosingElement = null;
}
