import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

import 'ast/node.dart';
import 'type.dart';

final class ClassBuilder {
  ClassBuilder({
    required this.name,
    this.withEquality = false,
  });

  final String name;
  final bool withEquality;

  final _typeParameters = <String>{};
  final _constructorParameters = ListBuilder<Parameter>();
  final _fields = ListBuilder<Field>();
  TypeReferenceBuilder? _supertype;

  bool sealed = false;
  bool final$ = false;

  void addParameterToSupertype(String supertype, String parameter) {
    _supertype ??= TypeReferenceBuilder()..symbol = supertype;
    _supertype?.types.add(refer(parameter));
  }

  void addParameter(Type parameter) {
    _typeParameters.add(parameter.name);
  }

  void addField(Type type, TypeVariantParameterNode field) {
    _constructorParameters.add(
      Parameter((builder) {
        builder.name = field.name.lexeme;
        builder.named = true;
        builder.required = true;
        builder.toThis = true;
      }),
    );

    _fields.add(
      Field((builder) {
        builder.modifier = FieldModifier.final$;
        builder.name = field.name.lexeme;
        builder.type = _buildType(type);
      }),
    );
  }

  Class asCodeBuilderClass() {
    return Class((builder) {
      builder.name = name;
      builder.types = ListBuilder([
        for (final parameter in _typeParameters) refer(parameter),
      ]);

      if (final$) {
        builder.modifier = ClassModifier.final$;
      }

      builder.sealed = sealed;

      if (_supertype case final supertype?) {
        builder.implements.add(
          TypeReference((builder) {
            // TODO(mateusfccp): fix this
            builder.symbol = supertype.symbol;
            builder.types = supertype.types;
          }),
        );
      }

      if (!sealed) {
        // TODO(mateusfccp): Improve this
        builder.constructors.add(
          Constructor((builder) {
            builder.constant = true;
            // See: https://github.com/dart-lang/code_builder/issues/385
            builder.optionalParameters = _constructorParameters;
          }),
        );
      }

      builder.fields = _fields;

      if (withEquality) {
        builder.methods.addAll([
          _equals(),
          _hashCode(),
          _toString(),
        ]);
      }
    });
  }

  Method _toString() {
    return Method((builder) {
      builder.annotations.add(
        refer('override'),
      );
      builder.returns = refer('String');
      builder.name = 'toString';
      builder.lambda = true;

      final fieldsDescription = StringBuffer();

      if (_fields.isNotEmpty) {
        final fields = _fields.build();
        fieldsDescription.write('(');

        for (int i = 0; i < fields.length; i = i + 1) {
          fieldsDescription.write(fields[i].name);
          fieldsDescription.write(r': $');
          fieldsDescription.write(fields[i].name);

          if (i < fields.length - 1) {
            fieldsDescription.write(', ');
          }
        }

        fieldsDescription.write(')');
      }

      final string = '$name$fieldsDescription';
      builder.body = literalString(string).code;
    });
  }

  Method _equals() {
    return Method((builder) {
      builder.annotations.add(
        refer('override'),
      );
      builder.returns = refer('bool');
      builder.name = 'operator==';
      builder.requiredParameters.add(
        Parameter((builder) {
          builder.type = refer('Object');
          builder.name = 'other';
        }),
      );

      final className = TypeReference((builder) {
        builder.symbol = name;
        builder.types = ListBuilder([
          for (final parameter in _typeParameters) refer(parameter),
        ]);
      });

      final expression = refer('other').isA(className);

      if (_fields.isEmpty) {
        builder.body = expression.code;
      } else {
        Expression returnExpression = expression;

        final fields = _fields.build();

        for (final field in fields) {
          final other = refer('other').property(field.name);
          final this$ = refer(field.name);
          final comparison = other.equalTo(this$);
          returnExpression = returnExpression.and(comparison);
        }

        builder.body = Block((builder) {
          builder.statements.addAll([
            Code('if (identical(this, other)) return true;'),
            returnExpression.returned.statement,
          ]);
        });
      }
    });
  }

  Method _hashCode() {
    return Method((builder) {
      builder.annotations.add(
        refer('override'),
      );
      builder.type = MethodType.getter;
      builder.returns = refer('int');
      builder.name = 'hashCode';
      builder.lambda = true;

      Expression expression;

      final fields = _fields.build();

      if (fields.isEmpty) {
        expression = refer('runtimeType').property('hashCode');
      } else if (fields.length == 1) {
        expression = refer(fields.single.name).property('hashCode');
      } else {
        expression = refer('Object');

        final parameters = [
          for (final field in fields) refer(field.name),
        ];

        if (fields.length <= 20) {
          expression = expression.property('hash').call(parameters);
        } else {
          expression = expression.property('hashAll').call([
            literalList(parameters),
          ]);
        }
      }

      builder.body = expression.code;
    });
  }
}

Reference _buildType(Type type) {
  return TypeReference((builder) {
    builder.symbol = type.name;

    for (final type in type.parameters) {
      builder.types.add(_buildType(type));
    }
  });
}
