import 'package:code_builder/code_builder.dart' hide ClassBuilder, Expression;
import 'package:pinto/semantic.dart';

import 'class_builder.dart';

final class Compiler implements ElementVisitor<List<Spec>> {
  Compiler(this.programElement);

  final ProgramElement programElement;

  void writeToSink(StringSink sink) {
    final emmiter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final [library] = programElement.accept(this) as List<Library>;

    sink.write(library.accept(emmiter));
  }

  @override
  List<Code> visitIdentifierElement(IdentifierElement node) {
    return [Code(node.name)];
  }

  @override
  Null visitImportedSymbolSyntheticElement(ImportedSymbolSyntheticElement node) {}

  @override
  List<Directive> visitImportElement(ImportElement importElement) {
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

    return [Directive.import(url)];
  }

  @override
  List<Field>? visitLetVariableDeclaration(LetVariableDeclaration node) {
    if (node.type is! UnitType) {
      final [code] = node.body.accept(this) as List<Code>;

      final field = Field((builder) {
        if (node.body.constant) {
          builder.modifier = FieldModifier.constant;
        } else {
          builder.modifier = FieldModifier.final$;
        }
        builder.name = node.name;
        builder.assignment = code;
      });

      return [field];
    } else {
      return null;
    }
  }

  @override
  List<Code> visitLiteralElement(LiteralElement node) {
    return [literal(node.constantValue).code];
  }

  @override
  List<Library> visitProgramElement(ProgramElement programElement) {
    final library = Library((builder) {
      for (final import in programElement.imports) {
        final [element] = import.accept(this) as List<Directive>;
        builder.directives.add(element);
      }

      for (final declaration in programElement.declarations) {
        final elements = declaration.accept(this);
        if (elements != null) {
          builder.body.addAll(elements);
        }
      }
    });

    return [library];
  }

  @override
  List<Class> visitTypeDefinitionElement(TypeDefinitionElement typeDefinitionElement) {
    final classes = <Class>[];

    if (typeDefinitionElement.variants case [final variant]) {
      final [class_] = variant.accept(this) as List<Class>;
      classes.add(class_);
    } else {
      final topClass = ClassBuilder(name: typeDefinitionElement.name);

      topClass.sealed = true;

      for (final parameter in typeDefinitionElement.parameters) {
        final [reference] = parameter.accept(this) as List<Reference>;
        topClass.addParameter(reference);
      }

      classes.add(topClass.asCodeBuilderClass());

      for (final variant in typeDefinitionElement.variants) {
        final [class_] = variant.accept(this) as List<Class>;
        classes.add(class_);
      }
    }

    return classes;
  }

  @override
  Null visitParameterElement(ParameterElement node) {
    // We still don't have a way to compile it to a single element, as for classes we have to both add constructor parameters and fields
  }

  @override
  List<Reference> visitTypeParameterElement(TypeParameterElement node) {
    return [_typeReferenceFromType(node.definedType)];
  }

  @override
  List<Class> visitTypeVariantElement(TypeVariantElement node) {
    final typeDefinitionElement = node.enclosingElement;

    final variantClass = ClassBuilder(
      name: node.name,
      withEquality: true,
    )..final$ = true;

    for (final parameter in node.parameters) {
      for (final type in _typeParametersFromType(parameter.type!)) {
        variantClass.addParameter(_typeReferenceFromType(type));
      }

      variantClass.addField(
        _typeReferenceFromType(parameter.type!),
        parameter,
      );
    }

    if (typeDefinitionElement.variants.length > 1) {
      variantClass.defineSupertypeName(typeDefinitionElement.name);

      final currentVariantTypes = [
        for (final parameter in node.parameters) parameter.type!,
      ];

      final typeParameters = _typeParametersFromTypeList(currentVariantTypes);

      for (final typeParameter in typeDefinitionElement.parameters) {
        final argument = typeParameters.contains(typeParameter.type) //
            ? typeParameter.type!
            : const BottomType();

        final parameter = _typeReferenceFromType(argument);
        variantClass.addParameterToSupertype(parameter);
      }
    }

    return [variantClass.asCodeBuilderClass()];
  }
}

@pragma('vm:prefer-inline')
String _buildTypeName(Type type) {
  return switch (type) {
    BooleanType() => 'bool',
    BottomType() => 'Never',
    PolymorphicType(:final name) || TypeParameterType(:final name) => name,
    StringType() => 'String',
    TopType() => 'Object?',
    TypeType() => 'Type',
    UnitType() => 'Null',
  };
}

TypeReference _typeReferenceFromType(Type type) {
  if (type case PolymorphicType(name: '?')) {
    final innerType = _typeReferenceFromType(type.arguments[0]);

    return innerType.rebuild((builder) {
      builder.isNullable = true;
    });
  } else {
    return TypeReference((builder) {
      if (type case PolymorphicType(name: '?')) {
        builder.symbol = _buildTypeName(type.arguments[0]);
        builder.isNullable = true;
      } else {
        builder.symbol = _buildTypeName(type);
      }

      if (type is PolymorphicType) {
        for (final type in type.arguments) {
          builder.types.add(_typeReferenceFromType(type));
        }
      }
    });
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
