// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element.dart';

// **************************************************************************
// TreeGenerator
// **************************************************************************

base mixin _Element {
  Element? get _enclosingElement => (this as Element).enclosingElement;
  @override
  String toString() => 'Element(enclosingElement: $_enclosingElement)';
}

base mixin _TypedElement {
  Type? get _type => (this as TypedElement).type;
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() => 'TypedElement(type: $_type)';
}

base mixin _TypeDefiningElement {
  Type get _definedType => (this as TypeDefiningElement).definedType;
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() => 'TypeDefiningElement(definedType: $_definedType)';
}

base mixin _TypeParameterElement {
  String get _name => (this as TypeParameterElement).name;
  TypeDefinitionElement get _enclosingElement =>
      (this as TypeParameterElement).enclosingElement;
  Type? get _type => (this as TypeParameterElement).type;
  Type get _definedType => (this as TypeParameterElement).definedType;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeParameterElement((this as TypeParameterElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _enclosingElement.accept(visitor);
  }

  @override
  String toString() =>
      'TypeParameterElement(name: $_name, enclosingElement: $_enclosingElement, type: $_type, definedType: $_definedType)';
}

base mixin _ParameterElement {
  String get _name => (this as ParameterElement).name;
  Type? get _type => (this as ParameterElement).type;
  Element get _enclosingElement => (this as ParameterElement).enclosingElement;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitParameterElement((this as ParameterElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _enclosingElement.accept(visitor);
  }

  @override
  String toString() =>
      'ParameterElement(name: $_name, type: $_type, enclosingElement: $_enclosingElement)';
}

base mixin _ExpressionElement {
  Element get _enclosingElement => (this as ExpressionElement).enclosingElement;
  bool get _constant => (this as ExpressionElement).constant;
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _enclosingElement.accept(visitor);
  }

  @override
  String toString() =>
      'ExpressionElement(enclosingElement: $_enclosingElement, constant: $_constant)';
}

base mixin _InvocationElement {
  Type? get _type => (this as InvocationElement).type;
  IdentifierElement get _identifier => (this as InvocationElement).identifier;
  ExpressionElement get _argument => (this as InvocationElement).argument;
  bool get _constant => (this as InvocationElement).constant;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitInvocationElement((this as InvocationElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _identifier.accept(visitor);
    _argument.accept(visitor);
  }

  @override
  String toString() =>
      'InvocationElement(type: $_type, identifier: $_identifier, argument: $_argument, constant: $_constant)';
}

base mixin _IdentifierElement {
  String get _name => (this as IdentifierElement).name;
  Type? get _type => (this as IdentifierElement).type;
  bool get _constant => (this as IdentifierElement).constant;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitIdentifierElement((this as IdentifierElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'IdentifierElement(name: $_name, type: $_type, constant: $_constant)';
}

base mixin _LiteralElement {
  Type? get _type => (this as LiteralElement).type;
  bool get _constant => (this as LiteralElement).constant;
  Object? get _constantValue => (this as LiteralElement).constantValue;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLiteralElement((this as LiteralElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() =>
      'LiteralElement(type: $_type, constant: $_constant, constantValue: $_constantValue)';
}

base mixin _TypeVariantElement {
  String get _name => (this as TypeVariantElement).name;
  List<ParameterElement> get _parameters =>
      (this as TypeVariantElement).parameters;
  TypeDefinitionElement get _enclosingElement =>
      (this as TypeVariantElement).enclosingElement;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeVariantElement((this as TypeVariantElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    for (final node in _parameters) {
      node.visitChildren(visitor);
    }
    _enclosingElement.accept(visitor);
  }

  @override
  String toString() =>
      'TypeVariantElement(name: $_name, parameters: $_parameters, enclosingElement: $_enclosingElement)';
}

base mixin _DeclarationElement {
  ProgramElement get _enclosingElement =>
      (this as DeclarationElement).enclosingElement;
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _enclosingElement.accept(visitor);
  }

  @override
  String toString() =>
      'DeclarationElement(enclosingElement: $_enclosingElement)';
}

base mixin _ImportElement {
  Package get _package => (this as ImportElement).package;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitImportElement((this as ImportElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {}
  @override
  String toString() => 'ImportElement(package: $_package)';
}

base mixin _LetFunctionDeclaration {
  String get _name => (this as LetFunctionDeclaration).name;
  Token get _parameter => (this as LetFunctionDeclaration).parameter;
  FunctionType get _type => (this as LetFunctionDeclaration).type;
  ExpressionElement get _body => (this as LetFunctionDeclaration).body;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLetFunctionDeclaration((this as LetFunctionDeclaration));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _body.accept(visitor);
  }

  @override
  String toString() =>
      'LetFunctionDeclaration(name: $_name, parameter: $_parameter, type: $_type, body: $_body)';
}

base mixin _LetVariableDeclaration {
  String get _name => (this as LetVariableDeclaration).name;
  Type? get _type => (this as LetVariableDeclaration).type;
  ExpressionElement get _body => (this as LetVariableDeclaration).body;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitLetVariableDeclaration((this as LetVariableDeclaration));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _body.accept(visitor);
  }

  @override
  String toString() =>
      'LetVariableDeclaration(name: $_name, type: $_type, body: $_body)';
}

base mixin _ImportedSymbolSyntheticElement {
  String get _name => (this as ImportedSymbolSyntheticElement).name;
  TypedElement get _syntheticElement =>
      (this as ImportedSymbolSyntheticElement).syntheticElement;
  Type get _type => (this as ImportedSymbolSyntheticElement).type;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitImportedSymbolSyntheticElement(
          (this as ImportedSymbolSyntheticElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    _syntheticElement.accept(visitor);
  }

  @override
  String toString() =>
      'ImportedSymbolSyntheticElement(name: $_name, syntheticElement: $_syntheticElement, type: $_type)';
}

base mixin _TypeDefinitionElement {
  String get _name => (this as TypeDefinitionElement).name;
  List<TypeParameterElement> get _parameters =>
      (this as TypeDefinitionElement).parameters;
  List<TypeVariantElement> get _variants =>
      (this as TypeDefinitionElement).variants;
  Type? get _type => (this as TypeDefinitionElement).type;
  Type get _definedType => (this as TypeDefinitionElement).definedType;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitTypeDefinitionElement((this as TypeDefinitionElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    for (final node in _parameters) {
      node.visitChildren(visitor);
    }
    for (final node in _variants) {
      node.visitChildren(visitor);
    }
  }

  @override
  String toString() =>
      'TypeDefinitionElement(name: $_name, parameters: $_parameters, variants: $_variants, type: $_type, definedType: $_definedType)';
}

base mixin _ProgramElement {
  List<ImportElement> get _imports => (this as ProgramElement).imports;
  List<DeclarationElement> get _declarations =>
      (this as ProgramElement).declarations;
  Null get _enclosingElement => (this as ProgramElement).enclosingElement;
  R? accept<R>(ElementVisitor<R> visitor) =>
      visitor.visitProgramElement((this as ProgramElement));
  void visitChildren<R>(ElementVisitor<R> visitor) {
    for (final node in _imports) {
      node.visitChildren(visitor);
    }
    for (final node in _declarations) {
      node.visitChildren(visitor);
    }
  }

  @override
  String toString() =>
      'ProgramElement(imports: $_imports, declarations: $_declarations, enclosingElement: $_enclosingElement)';
}
