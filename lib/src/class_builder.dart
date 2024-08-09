import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:pint/src/node.dart';

import 'token.dart';

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
  TypeReference? _supertype;

  bool sealed = false;
  bool final$ = false;

  void setSupertype(String supertype, [List<String> parameters = const []]) {
    _supertype = TypeReference((builder) {
      builder.symbol = supertype;

      for (final parameter in parameters) {
        builder.types.add(
          refer(parameter),
        );
      }
    });
  }

  void addParameter(Token parameter) {
    _typeParameters.add(parameter.lexeme);
  }

  void addField(TypeVariationParameterNode field) {
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
        builder.type = refer(field.type.lexeme);
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
        builder.implements.add(supertype);
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
        ]);
      }
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
