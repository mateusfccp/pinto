import 'dart:collection';

import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart' hide ClassBuilder;
import 'package:pinto/ast.dart';
import 'package:pinto/semantic.dart';

import 'class_builder.dart';

final class Compiler with DefaultTypeLiteralVisitor<void> implements AstVisitor<void> {
  Compiler({required this.resolver});

  final Resolver resolver;

  ClassBuilder? _currentClass;
  List<Type>? _currentDefinitionTypes;
  final _context = DoubleLinkedQueue<Object?>();

  Object? get _currentContext => _context.last;

  final _directives = ListBuilder<Directive>();
  final _body = ListBuilder<Spec>();

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
      ImportType.dart => 'dart:${statement.identifier.lexeme.substring(1)}',
      ImportType.package => 'package:${statement.identifier.lexeme}.dart',
    };

    _directives.add(
      Directive.import(url),
    );
  }

  @override
  void visitProgram(Program program) {
    for (final import in program.imports) {
      import.accept(this);
    }

    for (final statement in program.body) {
      statement.accept(this);
    }
  }

  @override
  void visitTypeDefinitionStatement(TypeDefinitionStatement statement) {
    _context.addLast(statement);
    _currentDefinitionTypes = [];

    if (statement.variants case [final variant]) {
      variant.accept(this);
    } else {
      final topClass = ClassBuilder(name: statement.name.lexeme);

      _pushClass(topClass);
      topClass.sealed = true;

      final typeParameters = statement.typeParameters;

      if (typeParameters != null) {
        for (final parameter in typeParameters) {
          final type = resolver.annotations[parameter]!;
          _currentDefinitionTypes!.add(type);
          parameter.accept(this);
        }
      }

      _popClass();

      for (final variant in statement.variants) {
        variant.accept(this);
      }
    }

    _currentDefinitionTypes = null;
    _context.removeLast();
  }

  @override
  void visitTypeLiteral(TypeLiteral typeLiteral) {
    assert(_currentClass != null);

    final class$ = _currentClass!;
    final type = resolver.annotations[typeLiteral]!;

    if (_currentContext is TypeDefinitionStatement) {
      class$.addParameter(type);
    } else if (_currentContext is TypeVariantNode) {
      for (final type in _typeParametersFromType(type)) {
        class$.addParameter(type);
      }
    }
  }

  @override
  void visitTypeVariantParameterNode(TypeVariantParameterNode node) {
    assert(_currentContext is TypeVariantNode);
    assert(_currentClass != null);

    node.type.accept(this);

    final type = resolver.annotations[node.type]!;
    _currentClass!.addField(type, node);
  }

  @override
  void visitTypeVariantNode(TypeVariantNode node) {
    assert(_currentContext is TypeDefinitionStatement);

    final typeDefinitionStatement = _currentContext as TypeDefinitionStatement;

    _context.addLast(node);

    final variantClass = ClassBuilder(
      name: node.name.lexeme,
      withEquality: true,
    )..final$ = true;

    _pushClass(variantClass);

    for (final parameter in node.parameters) {
      parameter.accept(this);
    }

    if (_currentDefinitionTypes case final definitionTypes?) {
      // If there's a single definition, it's going to be streamlined
      if (typeDefinitionStatement.variants.length > 1) {
        final currentVariantTypes = [
          for (final parameter in node.parameters) resolver.annotations[parameter.type]!,
        ];

        final typeParameters = _typeParametersFromTypeList(currentVariantTypes);

        for (final type in definitionTypes) {
          if (typeParameters.contains(type)) {
            variantClass.addParameterToSupertype(
              typeDefinitionStatement.name.lexeme,
              type,
            );
          } else {
            variantClass.addParameterToSupertype(
              typeDefinitionStatement.name.lexeme,
              const BottomType(),
            );
          }
        }
      }
    }

    _popClass();
    _context.removeLast();
  }

  void _pushClass(ClassBuilder classBuilder) => _currentClass = classBuilder;

  void _popClass() {
    assert(_currentClass != null);

    final class$ = _currentClass!.asCodeBuilderClass();
    _body.add(class$);
    _currentClass = null;
  }
}

List<TypeParameterType> _typeParametersFromType(Type type) {
  return switch (type) { TopType() || MonomorphicType() || BottomType() => const [], PolymorphicType(:final arguments) => _typeParametersFromTypeList(arguments), TypeParameterType() => [type] };
}

List<TypeParameterType> _typeParametersFromTypeList(List<Type> list) {
  final parameters = {
    for (final type in list) ..._typeParametersFromType(type),
  };

  return [...parameters];
}
