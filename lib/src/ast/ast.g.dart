// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast.dart';

// **************************************************************************
// TreeGenerator
// **************************************************************************

base mixin _AstNode {
  get _length => (this as AstNode).length;
  @override
  String toString() => 'AstNode(length: $_length)';
}

base mixin _TypeIdentifier {
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'TypeIdentifier';
}

base mixin _TopTypeIdentifier {
  get _verum => (this as TopTypeIdentifier).verum;
  get _offset => (this as TopTypeIdentifier).offset;
  get _end => (this as TopTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTopTypeIdentifier((this as TopTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'TopTypeIdentifier(verum: $_verum, offset: $_offset, end: $_end)';
}

base mixin _BottomTypeIdentifier {
  get _falsum => (this as BottomTypeIdentifier).falsum;
  get _offset => (this as BottomTypeIdentifier).offset;
  get _end => (this as BottomTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitBottomTypeIdentifier((this as BottomTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'BottomTypeIdentifier(falsum: $_falsum, offset: $_offset, end: $_end)';
}

base mixin _ListTypeIdentifier {
  get _leftBracket => (this as ListTypeIdentifier).leftBracket;
  get _identifier => (this as ListTypeIdentifier).identifier;
  get _rightBracket => (this as ListTypeIdentifier).rightBracket;
  get _offset => (this as ListTypeIdentifier).offset;
  get _end => (this as ListTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitListTypeIdentifier((this as ListTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifier.accept(visitor);
  }

  @override
  String toString() =>
      'ListTypeIdentifier(leftBracket: $_leftBracket, identifier: $_identifier, rightBracket: $_rightBracket, offset: $_offset, end: $_end)';
}

base mixin _SetTypeIdentifier {
  get _leftBrace => (this as SetTypeIdentifier).leftBrace;
  get _identifier => (this as SetTypeIdentifier).identifier;
  get _rightBrace => (this as SetTypeIdentifier).rightBrace;
  get _offset => (this as SetTypeIdentifier).offset;
  get _end => (this as SetTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitSetTypeIdentifier((this as SetTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifier.accept(visitor);
  }

  @override
  String toString() =>
      'SetTypeIdentifier(leftBrace: $_leftBrace, identifier: $_identifier, rightBrace: $_rightBrace, offset: $_offset, end: $_end)';
}

base mixin _MapTypeIdentifier {
  get _leftBrace => (this as MapTypeIdentifier).leftBrace;
  get _key => (this as MapTypeIdentifier).key;
  get _colon => (this as MapTypeIdentifier).colon;
  get _value => (this as MapTypeIdentifier).value;
  get _rightBrace => (this as MapTypeIdentifier).rightBrace;
  get _offset => (this as MapTypeIdentifier).offset;
  get _end => (this as MapTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitMapTypeIdentifier((this as MapTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _key.accept(visitor);
    _value.accept(visitor);
  }

  @override
  String toString() =>
      'MapTypeIdentifier(leftBrace: $_leftBrace, key: $_key, colon: $_colon, value: $_value, rightBrace: $_rightBrace, offset: $_offset, end: $_end)';
}

base mixin _IdentifiedTypeIdentifier {
  get _identifier => (this as IdentifiedTypeIdentifier).identifier;
  get _leftParenthesis => (this as IdentifiedTypeIdentifier).leftParenthesis;
  get _arguments => (this as IdentifiedTypeIdentifier).arguments;
  get _rightParenthesis => (this as IdentifiedTypeIdentifier).rightParenthesis;
  get _offset => (this as IdentifiedTypeIdentifier).offset;
  get _end => (this as IdentifiedTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIdentifiedTypeIdentifier((this as IdentifiedTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'IdentifiedTypeIdentifier(identifier: $_identifier, leftParenthesis: $_leftParenthesis, arguments: $_arguments, rightParenthesis: $_rightParenthesis, offset: $_offset, end: $_end)';
}

base mixin _OptionTypeIdentifier {
  get _identifier => (this as OptionTypeIdentifier).identifier;
  get _eroteme => (this as OptionTypeIdentifier).eroteme;
  get _offset => (this as OptionTypeIdentifier).offset;
  get _end => (this as OptionTypeIdentifier).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitOptionTypeIdentifier((this as OptionTypeIdentifier));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifier.accept(visitor);
  }

  @override
  String toString() =>
      'OptionTypeIdentifier(identifier: $_identifier, eroteme: $_eroteme, offset: $_offset, end: $_end)';
}

base mixin _Node {
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Node';
}

base mixin _TypeVariantParameterNode {
  get _typeIdentifier => (this as TypeVariantParameterNode).typeIdentifier;
  get _name => (this as TypeVariantParameterNode).name;
  get _offset => (this as TypeVariantParameterNode).offset;
  get _end => (this as TypeVariantParameterNode).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeVariantParameterNode((this as TypeVariantParameterNode));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _typeIdentifier.accept(visitor);
  }

  @override
  String toString() =>
      'TypeVariantParameterNode(typeIdentifier: $_typeIdentifier, name: $_name, offset: $_offset, end: $_end)';
}

base mixin _TypeVariantNode {
  get _name => (this as TypeVariantNode).name;
  get _parameters => (this as TypeVariantNode).parameters;
  get _offset => (this as TypeVariantNode).offset;
  get _end => (this as TypeVariantNode).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeVariantNode((this as TypeVariantNode));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'TypeVariantNode(name: $_name, parameters: $_parameters, offset: $_offset, end: $_end)';
}

base mixin _Expression {
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Expression';
}

base mixin _IdentifierExpression {
  get _identifier => (this as IdentifierExpression).identifier;
  get _offset => (this as IdentifierExpression).offset;
  get _end => (this as IdentifierExpression).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIdentifierExpression((this as IdentifierExpression));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'IdentifierExpression(identifier: $_identifier, offset: $_offset, end: $_end)';
}

base mixin _InvocationExpression {
  get _identifierExpression =>
      (this as InvocationExpression).identifierExpression;
  get _argument => (this as InvocationExpression).argument;
  get _offset => (this as InvocationExpression).offset;
  get _end => (this as InvocationExpression).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitInvocationExpression((this as InvocationExpression));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifierExpression.accept(visitor);
    _argument.accept(visitor);
  }

  @override
  String toString() =>
      'InvocationExpression(identifierExpression: $_identifierExpression, argument: $_argument, offset: $_offset, end: $_end)';
}

base mixin _LetExpression {
  get _identifier => (this as LetExpression).identifier;
  get _equals => (this as LetExpression).equals;
  get _binding => (this as LetExpression).binding;
  get _result => (this as LetExpression).result;
  get _offset => (this as LetExpression).offset;
  get _end => (this as LetExpression).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitLetExpression((this as LetExpression));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _binding.accept(visitor);
    _result.accept(visitor);
  }

  @override
  String toString() =>
      'LetExpression(identifier: $_identifier, equals: $_equals, binding: $_binding, result: $_result, offset: $_offset, end: $_end)';
}

base mixin _Literal {
  get _literal => (this as Literal).literal;
  get _offset => (this as Literal).offset;
  get _end => (this as Literal).end;
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'Literal(literal: $_literal, offset: $_offset, end: $_end)';
}

base mixin _BooleanLiteral {
  get _literal => (this as BooleanLiteral).literal;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitBooleanLiteral((this as BooleanLiteral));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'BooleanLiteral(literal: $_literal)';
}

base mixin _UnitLiteral {
  get _literal => (this as UnitLiteral).literal;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitUnitLiteral((this as UnitLiteral));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'UnitLiteral(literal: $_literal)';
}

base mixin _StringLiteral {
  get _literal => (this as StringLiteral).literal;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitStringLiteral((this as StringLiteral));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'StringLiteral(literal: $_literal)';
}

base mixin _IntegerLiteral {
  get _literal => (this as IntegerLiteral).literal;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIntegerLiteral((this as IntegerLiteral));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'IntegerLiteral(literal: $_literal)';
}

base mixin _DoubleLiteral {
  get _literal => (this as DoubleLiteral).literal;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitDoubleLiteral((this as DoubleLiteral));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'DoubleLiteral(literal: $_literal)';
}

base mixin _Declaration {
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Declaration';
}

base mixin _ImportDeclaration {
  get _keyword => (this as ImportDeclaration).keyword;
  get _type => (this as ImportDeclaration).type;
  get _identifier => (this as ImportDeclaration).identifier;
  get _offset => (this as ImportDeclaration).offset;
  get _end => (this as ImportDeclaration).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitImportDeclaration((this as ImportDeclaration));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'ImportDeclaration(keyword: $_keyword, type: $_type, identifier: $_identifier, offset: $_offset, end: $_end)';
}

base mixin _TypeDefinition {
  get _keyword => (this as TypeDefinition).keyword;
  get _name => (this as TypeDefinition).name;
  get _leftParenthesis => (this as TypeDefinition).leftParenthesis;
  get _parameters => (this as TypeDefinition).parameters;
  get _rightParenthesis => (this as TypeDefinition).rightParenthesis;
  get _equals => (this as TypeDefinition).equals;
  get _variants => (this as TypeDefinition).variants;
  get _offset => (this as TypeDefinition).offset;
  get _end => (this as TypeDefinition).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeDefinition((this as TypeDefinition));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'TypeDefinition(keyword: $_keyword, name: $_name, leftParenthesis: $_leftParenthesis, parameters: $_parameters, rightParenthesis: $_rightParenthesis, equals: $_equals, variants: $_variants, offset: $_offset, end: $_end)';
}

base mixin _LetDeclaration {
  get _keyword => (this as LetDeclaration).keyword;
  get _identifier => (this as LetDeclaration).identifier;
  get _parameter => (this as LetDeclaration).parameter;
  get _equals => (this as LetDeclaration).equals;
  get _body => (this as LetDeclaration).body;
  get _offset => (this as LetDeclaration).offset;
  get _end => (this as LetDeclaration).end;
  @override
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitLetDeclaration((this as LetDeclaration));
  @override
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _body.accept(visitor);
  }

  @override
  String toString() =>
      'LetDeclaration(keyword: $_keyword, identifier: $_identifier, parameter: $_parameter, equals: $_equals, body: $_body, offset: $_offset, end: $_end)';
}
