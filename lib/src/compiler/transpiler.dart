import 'dart:collection';

import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart' hide ClassBuilder;
import 'package:pinto/ast.dart';
import 'package:pinto/semantic.dart';

import 'class_builder.dart';

final class Transpiler with DefaultTypeLiteralVisitor<void> implements AstVisitor<void> {
  Transpiler({required this.resolver});

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
      ImportType.dart => 'dart:${statement.package}',
      ImportType.package => 'package:${statement.package}.dart',
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

    if (statement.variants case [final definition]) {
      definition.accept(this);
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

      for (final definition in statement.variants) {
        definition.accept(this);
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
      if (type is TypeParameterType) {
        class$.addParameter(type);
      }
    }
  }

  @override
  void visitTypeVariantParameterNode(TypeVariantParameterNode node) {
    assert(_currentContext is TypeVariantNode);
    assert(_currentClass != null);

    final class$ = _currentClass!;

    node.type.accept(this);

    final type = resolver.annotations[node.type]!;
    class$.addField(type, node);
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

List<Type> _typeParametersFromTypeList(List<Type> list) {
  final parameters = {
    for (final type in list) ...[
      if (type is TypeParameterType) //
        type
      else if (type is PolymorphicType)
        ..._typeParametersFromTypeList(type.arguments),
    ]
  };

  assert(parameters.every((parameter) => parameter is TypeParameterType));

  return parameters.toList();
}
