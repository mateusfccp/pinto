import 'element.dart';

abstract interface class ElementVisitor<R> {
  R? visitTypeParameterElement(TypeParameterElement node);
  R? visitParameterElement(ParameterElement node);
  R? visitInvocationElement(InvocationElement node);
  R? visitIdentifierElement(IdentifierElement node);
  R? visitLiteralElement(LiteralElement node);
  R? visitTypeVariantElement(TypeVariantElement node);
  R? visitImportElement(ImportElement node);
  R? visitLetFunctionDeclaration(LetFunctionDeclaration node);
  R? visitLetVariableDeclaration(LetVariableDeclaration node);
  R? visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node);
  R? visitTypeDefinitionElement(TypeDefinitionElement node);
  R? visitProgramElement(ProgramElement node);
}

abstract base class SimpleElementVisitor<R> implements ElementVisitor {
  @override
  R? visitTypeParameterElement(TypeParameterElement node) => null;

  @override
  R? visitParameterElement(ParameterElement node) => null;

  @override
  R? visitInvocationElement(InvocationElement node) => null;

  @override
  R? visitIdentifierElement(IdentifierElement node) => null;

  @override
  R? visitLiteralElement(LiteralElement node) => null;

  @override
  R? visitTypeVariantElement(TypeVariantElement node) => null;

  @override
  R? visitImportElement(ImportElement node) => null;

  @override
  R? visitLetFunctionDeclaration(LetFunctionDeclaration node) => null;

  @override
  R? visitLetVariableDeclaration(LetVariableDeclaration node) => null;

  @override
  R? visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node) =>
      null;

  @override
  R? visitTypeDefinitionElement(TypeDefinitionElement node) => null;

  @override
  R? visitProgramElement(ProgramElement node) => null;
}

abstract base class GeneralizingElementVisitor<R> implements ElementVisitor {
  R? visitElement(Element node) {
    node.visitChildren(this);
    return null;
  }

  @override
  R? visitTypeParameterElement(TypeParameterElement node) => visitElement(node);

  @override
  R? visitParameterElement(ParameterElement node) => visitElement(node);

  R? visitExpressionElement(ExpressionElement node) => visitElement(node);

  @override
  R? visitInvocationElement(InvocationElement node) =>
      visitExpressionElement(node);

  @override
  R? visitIdentifierElement(IdentifierElement node) =>
      visitExpressionElement(node);

  @override
  R? visitLiteralElement(LiteralElement node) => visitExpressionElement(node);

  @override
  R? visitTypeVariantElement(TypeVariantElement node) => visitElement(node);

  R? visitDeclarationElement(DeclarationElement node) => visitElement(node);

  @override
  R? visitImportElement(ImportElement node) => visitDeclarationElement(node);

  @override
  R? visitLetFunctionDeclaration(LetFunctionDeclaration node) =>
      visitDeclarationElement(node);

  @override
  R? visitLetVariableDeclaration(LetVariableDeclaration node) =>
      visitDeclarationElement(node);

  @override
  R? visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node) =>
      visitDeclarationElement(node);

  @override
  R? visitTypeDefinitionElement(TypeDefinitionElement node) =>
      visitDeclarationElement(node);

  @override
  R? visitProgramElement(ProgramElement node) => visitElement(node);
}
