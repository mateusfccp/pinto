// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ast.dart';

// **************************************************************************
// TreeGenerator
// **************************************************************************

base mixin _AstNode {
  int get _length => (this as AstNode).length;
  @override
  String toString() => 'AstNode(length: $_length)';
}

base mixin _TypeIdentifier {
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'TypeIdentifier';
}

base mixin _TopTypeIdentifier {
  Token get _verum => (this as TopTypeIdentifier).verum;
  int get _offset => (this as TopTypeIdentifier).offset;
  int get _end => (this as TopTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTopTypeIdentifier((this as TopTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'TopTypeIdentifier(verum: $_verum, offset: $_offset, end: $_end)';
}

base mixin _BottomTypeIdentifier {
  Token get _falsum => (this as BottomTypeIdentifier).falsum;
  int get _offset => (this as BottomTypeIdentifier).offset;
  int get _end => (this as BottomTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitBottomTypeIdentifier((this as BottomTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'BottomTypeIdentifier(falsum: $_falsum, offset: $_offset, end: $_end)';
}

base mixin _ListTypeIdentifier {
  Token get _leftBracket => (this as ListTypeIdentifier).leftBracket;
  TypeIdentifier get _identifier => (this as ListTypeIdentifier).identifier;
  Token get _rightBracket => (this as ListTypeIdentifier).rightBracket;
  int get _offset => (this as ListTypeIdentifier).offset;
  int get _end => (this as ListTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitListTypeIdentifier((this as ListTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifier.accept(visitor);
  }

  @override
  String toString() =>
      'ListTypeIdentifier(leftBracket: $_leftBracket, identifier: $_identifier, rightBracket: $_rightBracket, offset: $_offset, end: $_end)';
}

base mixin _SetTypeIdentifier {
  Token get _leftBrace => (this as SetTypeIdentifier).leftBrace;
  TypeIdentifier get _identifier => (this as SetTypeIdentifier).identifier;
  Token get _rightBrace => (this as SetTypeIdentifier).rightBrace;
  int get _offset => (this as SetTypeIdentifier).offset;
  int get _end => (this as SetTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitSetTypeIdentifier((this as SetTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifier.accept(visitor);
  }

  @override
  String toString() =>
      'SetTypeIdentifier(leftBrace: $_leftBrace, identifier: $_identifier, rightBrace: $_rightBrace, offset: $_offset, end: $_end)';
}

base mixin _MapTypeIdentifier {
  Token get _leftBrace => (this as MapTypeIdentifier).leftBrace;
  TypeIdentifier get _key => (this as MapTypeIdentifier).key;
  Token get _colon => (this as MapTypeIdentifier).colon;
  TypeIdentifier get _value => (this as MapTypeIdentifier).value;
  Token get _rightBrace => (this as MapTypeIdentifier).rightBrace;
  int get _offset => (this as MapTypeIdentifier).offset;
  int get _end => (this as MapTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitMapTypeIdentifier((this as MapTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _key.accept(visitor);
    _value.accept(visitor);
  }

  @override
  String toString() =>
      'MapTypeIdentifier(leftBrace: $_leftBrace, key: $_key, colon: $_colon, value: $_value, rightBrace: $_rightBrace, offset: $_offset, end: $_end)';
}

base mixin _IdentifiedTypeIdentifier {
  Token get _identifier => (this as IdentifiedTypeIdentifier).identifier;
  Token? get _leftParenthesis =>
      (this as IdentifiedTypeIdentifier).leftParenthesis;
  SyntacticEntityList<TypeIdentifier>? get _arguments =>
      (this as IdentifiedTypeIdentifier).arguments;
  Token? get _rightParenthesis =>
      (this as IdentifiedTypeIdentifier).rightParenthesis;
  int get _offset => (this as IdentifiedTypeIdentifier).offset;
  int get _end => (this as IdentifiedTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIdentifiedTypeIdentifier((this as IdentifiedTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'IdentifiedTypeIdentifier(identifier: $_identifier, leftParenthesis: $_leftParenthesis, arguments: $_arguments, rightParenthesis: $_rightParenthesis, offset: $_offset, end: $_end)';
}

base mixin _OptionTypeIdentifier {
  TypeIdentifier get _identifier => (this as OptionTypeIdentifier).identifier;
  Token get _eroteme => (this as OptionTypeIdentifier).eroteme;
  int get _offset => (this as OptionTypeIdentifier).offset;
  int get _end => (this as OptionTypeIdentifier).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitOptionTypeIdentifier((this as OptionTypeIdentifier));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifier.accept(visitor);
  }

  @override
  String toString() =>
      'OptionTypeIdentifier(identifier: $_identifier, eroteme: $_eroteme, offset: $_offset, end: $_end)';
}

base mixin _Node {
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Node';
}

base mixin _TypeVariantParameterNode {
  TypeIdentifier get _typeIdentifier =>
      (this as TypeVariantParameterNode).typeIdentifier;
  Token get _name => (this as TypeVariantParameterNode).name;
  int get _offset => (this as TypeVariantParameterNode).offset;
  int get _end => (this as TypeVariantParameterNode).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeVariantParameterNode((this as TypeVariantParameterNode));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _typeIdentifier.accept(visitor);
  }

  @override
  String toString() =>
      'TypeVariantParameterNode(typeIdentifier: $_typeIdentifier, name: $_name, offset: $_offset, end: $_end)';
}

base mixin _TypeVariantNode {
  Token get _name => (this as TypeVariantNode).name;
  SyntacticEntityList<TypeVariantParameterNode> get _parameters =>
      (this as TypeVariantNode).parameters;
  int get _offset => (this as TypeVariantNode).offset;
  int get _end => (this as TypeVariantNode).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeVariantNode((this as TypeVariantNode));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'TypeVariantNode(name: $_name, parameters: $_parameters, offset: $_offset, end: $_end)';
}

base mixin _Expression {
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Expression';
}

base mixin _IdentifierExpression {
  Token get _identifier => (this as IdentifierExpression).identifier;
  int get _offset => (this as IdentifierExpression).offset;
  int get _end => (this as IdentifierExpression).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIdentifierExpression((this as IdentifierExpression));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'IdentifierExpression(identifier: $_identifier, offset: $_offset, end: $_end)';
}

base mixin _InvocationExpression {
  IdentifierExpression get _identifierExpression =>
      (this as InvocationExpression).identifierExpression;
  Expression get _argument => (this as InvocationExpression).argument;
  int get _offset => (this as InvocationExpression).offset;
  int get _end => (this as InvocationExpression).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitInvocationExpression((this as InvocationExpression));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _identifierExpression.accept(visitor);
    _argument.accept(visitor);
  }

  @override
  String toString() =>
      'InvocationExpression(identifierExpression: $_identifierExpression, argument: $_argument, offset: $_offset, end: $_end)';
}

base mixin _LetExpression {
  Token get _identifier => (this as LetExpression).identifier;
  Token get _equals => (this as LetExpression).equals;
  Expression get _binding => (this as LetExpression).binding;
  Expression get _result => (this as LetExpression).result;
  int get _offset => (this as LetExpression).offset;
  int get _end => (this as LetExpression).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitLetExpression((this as LetExpression));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _binding.accept(visitor);
    _result.accept(visitor);
  }

  @override
  String toString() =>
      'LetExpression(identifier: $_identifier, equals: $_equals, binding: $_binding, result: $_result, offset: $_offset, end: $_end)';
}

base mixin _Literal {
  Token get _literal => (this as Literal).literal;
  int get _offset => (this as Literal).offset;
  int get _end => (this as Literal).end;
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'Literal(literal: $_literal, offset: $_offset, end: $_end)';
}

base mixin _BooleanLiteral {
  Token get _literal => (this as BooleanLiteral).literal;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitBooleanLiteral((this as BooleanLiteral));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'BooleanLiteral(literal: $_literal)';
}

base mixin _UnitLiteral {
  Token get _literal => (this as UnitLiteral).literal;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitUnitLiteral((this as UnitLiteral));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'UnitLiteral(literal: $_literal)';
}

base mixin _StringLiteral {
  Token get _literal => (this as StringLiteral).literal;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitStringLiteral((this as StringLiteral));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'StringLiteral(literal: $_literal)';
}

base mixin _IntegerLiteral {
  Token get _literal => (this as IntegerLiteral).literal;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitIntegerLiteral((this as IntegerLiteral));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'IntegerLiteral(literal: $_literal)';
}

base mixin _DoubleLiteral {
  Token get _literal => (this as DoubleLiteral).literal;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitDoubleLiteral((this as DoubleLiteral));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'DoubleLiteral(literal: $_literal)';
}

base mixin _Declaration {
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() => 'Declaration';
}

base mixin _ImportDeclaration {
  Token get _keyword => (this as ImportDeclaration).keyword;
  ImportType get _type => (this as ImportDeclaration).type;
  Token get _identifier => (this as ImportDeclaration).identifier;
  int get _offset => (this as ImportDeclaration).offset;
  int get _end => (this as ImportDeclaration).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitImportDeclaration((this as ImportDeclaration));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'ImportDeclaration(keyword: $_keyword, type: $_type, identifier: $_identifier, offset: $_offset, end: $_end)';
}

base mixin _TypeDefinition {
  Token get _keyword => (this as TypeDefinition).keyword;
  Token get _name => (this as TypeDefinition).name;
  Token? get _leftParenthesis => (this as TypeDefinition).leftParenthesis;
  SyntacticEntityList<IdentifiedTypeIdentifier>? get _parameters =>
      (this as TypeDefinition).parameters;
  Token? get _rightParenthesis => (this as TypeDefinition).rightParenthesis;
  Token get _equals => (this as TypeDefinition).equals;
  SyntacticEntityList<TypeVariantNode> get _variants =>
      (this as TypeDefinition).variants;
  int get _offset => (this as TypeDefinition).offset;
  int get _end => (this as TypeDefinition).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitTypeDefinition((this as TypeDefinition));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {}
  @override
  String toString() =>
      'TypeDefinition(keyword: $_keyword, name: $_name, leftParenthesis: $_leftParenthesis, parameters: $_parameters, rightParenthesis: $_rightParenthesis, equals: $_equals, variants: $_variants, offset: $_offset, end: $_end)';
}

base mixin _LetDeclaration {
  Token get _keyword => (this as LetDeclaration).keyword;
  Token get _identifier => (this as LetDeclaration).identifier;
  Token? get _parameter => (this as LetDeclaration).parameter;
  Token get _equals => (this as LetDeclaration).equals;
  Expression get _body => (this as LetDeclaration).body;
  int get _offset => (this as LetDeclaration).offset;
  int get _end => (this as LetDeclaration).end;
  R? accept<R>(AstNodeVisitor<R> visitor) =>
      visitor.visitLetDeclaration((this as LetDeclaration));
  void visitChildren<R>(AstNodeVisitor<R> visitor) {
    _body.accept(visitor);
  }

  @override
  String toString() =>
      'LetDeclaration(keyword: $_keyword, identifier: $_identifier, parameter: $_parameter, equals: $_equals, body: $_body, offset: $_offset, end: $_end)';
}
