import 'dart:collection';

import 'class_builder.dart';
import 'node.dart';
import 'token.dart';
import 'statement.dart';

final class Transpiler implements StatementVisitor<void>, NodeVisitor<void> {
  Transpiler(this.sink);

  final StringSink sink;

  final _context = DoubleLinkedQueue<Object?>();

  Object? get _currentContext => _context.last;

  ClassBuilder? _currentClass;

  @override
  void visitTypeDefinitionStatement(TypeDefinitionStatement statement) {
    _context.addLast(statement);

    if (statement.variations case [final definition]) {
      definition.accept(this);
    } else {
      final topClass = ClassBuilder(name: statement.name.lexeme);
      _currentClass = topClass;

      topClass.sealed = true;

      final typeParameters = statement.typeParameters;

      if (typeParameters != null) {
        for (final parameter in typeParameters) {
          topClass.addParameter(parameter);
        }
      }

      topClass.writeToSink(sink);

      _currentClass = null;

      for (final definition in statement.variations) {
        definition.accept(this);
      }
    }

    _context.removeLast();
  }

  @override
  void visitTypeVariationParameterNode(TypeVariationParameterNode node) {
    assert(_currentContext is TypeDefinitionStatement);
    assert(_currentClass != null);

    final context = _currentContext as TypeDefinitionStatement;

    if (context.typeParameters case final typeParameters?) {
      bool equal(Token t) => Token.same(t, node.type);

      if (typeParameters.any(equal)) {
        _currentClass!.addParameter(node.type);
      }
    }

    _currentClass!.addField(node);
  }

  @override
  void visitTypeVariationNode(TypeVariationNode node) {
    assert(_currentContext is TypeDefinitionStatement);
    final context = _currentContext as TypeDefinitionStatement;

    // _context.addLast(node);

    final variantClass = ClassBuilder(
      name: node.name.lexeme,
      withEquality: true,
    )..final$ = true;

    _currentClass = variantClass;

    final shouldStreamline = context.variations.length == 1;
    final implementingTypeParameters = <String>[];

    for (final parameter in node.parameters) {
      parameter.accept(this);
    }

    if (context.typeParameters case final definitionTypeParameters?) {
      for (final parameter in definitionTypeParameters) {
        bool equal(TypeVariationParameterNode t) => Token.same(t.type, parameter);

        final parameterIsUsed = node.parameters.any(equal);

        if (parameterIsUsed) {
          implementingTypeParameters.add(parameter.lexeme);
        } else {
          implementingTypeParameters.add('Never');
        }
      }
    }

    if (!shouldStreamline) {
      variantClass.setSupertype(
        context.name.lexeme,
        implementingTypeParameters,
      );
    }

    variantClass.writeToSink(sink);

    _currentClass = null;
    // _context.removeLast();
  }
}
