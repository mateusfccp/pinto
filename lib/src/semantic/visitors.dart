import 'element.dart';

abstract interface class ElementVisitor<R> {
  R? visitParameterElement(ParameterElement node);
  R? visitTypeVariantElement(TypeVariantElement node);
  R? visitImportElement(ImportElement node);
  R? visitLetVariableDeclaration(LetVariableDeclaration node);
  R? visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node);
  R? visitTypeParameterElement(TypeParameterElement node);
  R? visitTypeDefinitionElement(TypeDefinitionElement node);
  R? visitProgramElement(ProgramElement node);
}

abstract base class SimpleElementVisitor<R> implements ElementVisitor {
  @override
  R? visitParameterElement(ParameterElement node) => null;

  @override
  R? visitTypeVariantElement(TypeVariantElement node) => null;

  @override
  R? visitImportElement(ImportElement node) => null;

  @override
  R? visitLetVariableDeclaration(LetVariableDeclaration node) => null;

  @override
  R? visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node) =>
      null;

  @override
  R? visitTypeParameterElement(TypeParameterElement node) => null;

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
  R? visitParameterElement(ParameterElement node) => visitElement(node);

  @override
  R? visitTypeVariantElement(TypeVariantElement node) => visitElement(node);

  R? visitDeclarationElement(DeclarationElement node) => visitElement(node);

  @override
  R? visitImportElement(ImportElement node) => visitDeclarationElement(node);

  @override
  R? visitLetVariableDeclaration(LetVariableDeclaration node) =>
      visitDeclarationElement(node);

  R? visitTypeDefiningDeclaration(TypeDefiningDeclaration node) =>
      visitDeclarationElement(node);

  @override
  R? visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node) =>
      visitTypeDefiningDeclaration(node);

  @override
  R? visitTypeParameterElement(TypeParameterElement node) =>
      visitTypeDefiningDeclaration(node);

  @override
  R? visitTypeDefinitionElement(TypeDefinitionElement node) =>
      visitTypeDefiningDeclaration(node);

  @override
  R? visitProgramElement(ProgramElement node) => visitElement(node);
}
