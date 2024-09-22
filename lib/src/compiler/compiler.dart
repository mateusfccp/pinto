import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart' hide ClassBuilder;
import 'package:pinto/ast.dart';
import 'package:pinto/semantic.dart';

import 'class_builder.dart';

final class Compiler implements ElementVisitor<void> {
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
  void visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node) {}

  @override
  void visitImportElement(ImportElement importElement) async {
    final String url;

    switch (importElement.package) {
      case DartSdkPackage(:final name):
        url = 'dart:$name';
      case ExternalPackage(:final name):
        final parts = name.split('/');

        if (parts case [final root]) {
          url = 'package:$root/$root.dart';
        } else {
          url = 'package:$name.dart';
        }
      case CurrentPackage():
        throw 'Nope'; // TODO(mateusfccp): CurrentPackage shouldn't exist
    }

    _directives.add(
      Directive.import(url),
    );
  }

  @override
  void visitLetVariableDeclaration(LetVariableDeclaration node) {
    if (node.type is! UnitType) {
      final code = switch (node.body) {
        IdentifierExpression(:final identifier) => Code(identifier.lexeme),
        Literal(:final literal) => Code(literal.lexeme),
        LetExpression() => null,
      };

      // TODO(mateusfccp): Also make it const if its an identifier for a constant expression.
      // TODO(mateusfccp): Once we have string literals with interpolation, we should only consider them const if all the internal expressions are const
      final constant = node.body is Literal;

      _body.add(
        Field((builder) {
          if (constant) {
            builder.modifier = FieldModifier.constant;
          } else {
            builder.modifier = FieldModifier.final$;
          }
          builder.name = node.name;
          builder.assignment = code;
        }),
      );
    }
  }

  @override
  void visitProgramElement(ProgramElement programElement) {
    for (final import in programElement.imports) {
      import.accept(this);
    }

    for (final declaration in programElement.declarations) {
      declaration.accept(this);
    }
  }

  @override
  void visitTypeDefinitionElement(TypeDefinitionElement typeDefinitionElement) {
    if (typeDefinitionElement.variants case [final variant]) {
      variant.accept(this);
    } else {
      final topClass = ClassBuilder(name: typeDefinitionElement.name);

      topClass.sealed = true;

      final typeParameters = typeDefinitionElement.parameters;

      for (final parameter in typeParameters) {
        topClass.addParameter(parameter.type!);
      }

      _body.add(topClass.asCodeBuilderClass());

      for (final variant in typeDefinitionElement.variants) {
        variant.accept(this);
      }
    }
  }

  @override
  void visitParameterElement(ParameterElement parameterElement) {}

  @override
  void visitTypeParameterElement(TypeParameterElement node) {}

  @override
  void visitTypeVariantElement(TypeVariantElement typeParameterElement) {
    final typeDefinitionElement = typeParameterElement.enclosingElement;

    final variantClass = ClassBuilder(
      name: typeParameterElement.name,
      withEquality: true,
    )..final$ = true;

    for (final parameter in typeParameterElement.parameters) {
      for (final type in _typeParametersFromType(parameter.type!)) {
        variantClass.addParameter(type);
      }

      variantClass.addField(parameter.type!, parameter);
    }

    if (typeDefinitionElement.variants.length > 1) {
      variantClass.defineSuperypeName(typeDefinitionElement.name);

      final currentVariantTypes = [
        for (final parameter in typeParameterElement.parameters) parameter.type!,
      ];

      final typeParameters = _typeParametersFromTypeList(currentVariantTypes);

      for (final typeParameter in typeDefinitionElement.parameters) {
        final argument = typeParameters.contains(typeParameter.type) //
            ? typeParameter.type!
            : const BottomType();

        variantClass.addParameterToSupertype(argument);
      }
    }

    _body.add(variantClass.asCodeBuilderClass());
  }
}

List<TypeParameterType> _typeParametersFromType(Type type) {
  return switch (type) {
    PolymorphicType(:final arguments) => _typeParametersFromTypeList(arguments),
    TypeParameterType() => [type],
    TopType() || BottomType() || UnitType() || BooleanType() || TypeType() || StringType() => const [],
  };
}

List<TypeParameterType> _typeParametersFromTypeList(List<Type> list) {
  final parameters = {
    for (final type in list) ..._typeParametersFromType(type),
  };

  return [...parameters];
}
