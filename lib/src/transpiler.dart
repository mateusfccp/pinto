import 'dart:collection';

import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart' hide ClassBuilder;

import 'class_builder.dart';
import 'import.dart';
import 'node.dart';
import 'token.dart';
import 'statement.dart';

final class Transpiler implements StatementVisitor<void>, NodeVisitor<void> {
  final _context = DoubleLinkedQueue<Object?>();

  Object? get _currentContext => _context.last;

  final _directives = ListBuilder<Directive>();
  final _body = ListBuilder<Spec>();

  ClassBuilder? _currentClass;

  void writeToSink(StringSink sink) {
    final emmiter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final library = Library((builder) {
      builder.directives = _directives;
      builder.body = _body;
    });

    sink.write(library.accept(emmiter));
  }

  @override
  void visitImportStatement(ImportStatement statement) {
    assert(_currentContext == null);
    assert(_currentClass == null);

    final url = switch (statement.type) {
      ImportType.dart => 'dart:${statement.package}',
      ImportType.package => 'package:${statement.package}.dart',
    };

    _directives.add(
      Directive.import(url),
    );
  }

  @override
  void visitTypeDefinitionStatement(TypeDefinitionStatement statement) {
    _context.addLast(statement);

    if (statement.variants case [final definition]) {
      definition.accept(this);
    } else {
      final topClass = ClassBuilder(name: statement.name.lexeme);

      _pushClass(topClass);
      topClass.sealed = true;

      final typeParameters = statement.typeParameters;

      if (typeParameters != null) {
        for (final parameter in typeParameters) {
          topClass.addParameter(parameter);
        }
      }

      _body.add(
        topClass.asCodeBuilderClass(),
      );

      _popClass();

      for (final definition in statement.variants) {
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

    _pushClass(variantClass);

    final shouldStreamline = context.variants.length == 1;
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

    _popClass();
    // _context.removeLast();
  }

  void _pushClass(ClassBuilder classBuilder) => _currentClass = classBuilder;

  void _popClass() {
    assert(_currentClass != null);

    final class$ = _currentClass!.asCodeBuilderClass();
    _body.add(class$);
    _currentClass = null;
  }
}
