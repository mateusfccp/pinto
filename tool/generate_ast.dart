import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: generate_ast <output directory>');
    exit(64); // exit(usage)
  } else {
    final [outputDir] = args;

    _defineAst(
      outputDir,
      'Expression',
      {
        'Let': [
          ('Token', 'identifier'),
          ('Expression', 'binding'),
          ('Expression', 'result')
        ],
        'Literal': [
          ('Token', 'literal'),
        ],
      },
      ['token.dart', 'type_literal.dart'],
    );

    _defineAst(
      outputDir,
      'Node',
      {
        'TypeVariant': [
          ('Token', 'name'),
          ('List<TypeVariantParameterNode>', 'parameters'),
        ],
        'TypeVariantParameter': [
          ('TypeLiteral', 'type'),
          ('Token', 'name'),
        ],
      },
      ['token.dart', 'type_literal.dart'],
    );

    _defineAst(
      outputDir,
      'Statement',
      {
        'Function': [
          ('Token', 'identifier'),
          // ('?', 'parameter'),
          ('Expression', 'result'),
        ],
        'Import': [
          ('ImportType', 'type'),
          ('Token', 'identifier'),
        ],
        'TypeDefinition': [
          ('Token', 'name'),
          ('List<IdentifiedTypeLiteral>?', 'parameters'),
          ('List<TypeVariantNode>', 'variants'),
        ],
      },
      ['node.dart', 'import.dart', 'token.dart', 'type_literal.dart'],
    );

    _defineAst(
      outputDir,
      'TypeLiteral',
      {
        'Top': [],
        'Bottom': [],
        'List': [('TypeLiteral', 'literal')],
        'Set': [('TypeLiteral', 'literal')],
        'Map': [
          ('TypeLiteral', 'keyLiteral'),
          ('TypeLiteral', 'valueLiteral'),
        ],
        'Identified': [
          ('Token', 'identifier'),
          ('List<TypeLiteral>?', 'arguments'),
        ],
        'Option': [('TypeLiteral', 'literal')],
      },
      ['token.dart'],
    );
  }
}

void _defineAst(
  String outputDir,
  String baseName,
  Map<String, List<(String, String)>> types, [
  List<String> imports = const [],
]) {
  final filename = ReCase(baseName).snakeCase;
  final path = '$outputDir/$filename.dart';
  final file = File(path);
  file.createSync(recursive: true);

  final library = Library((builder) {
    for (final import in imports) {
      builder.directives.add(
        Directive.import(import),
      );
    }

    builder.body.add(
      _defineBaseClass(baseName),
    );

    builder.body.add(
      _defineVisitor(baseName, types),
    );

    for (final MapEntry(key: name, value: fields) in types.entries) {
      final className = '$name$baseName';

      builder.body.add(
        _defineType(baseName, className, fields),
      );
    }
  });

  final emitter = DartEmitter(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final content = library.accept(emitter);
  final formatter = DartFormatter();
  final formattedString = formatter.format('$content');

  file.writeAsStringSync(formattedString);
}

Class _defineBaseClass(String name) {
  return Class((builder) {
    builder.sealed = true;
    builder.name = name;
    builder.methods.add(
      Method((builder) {
        builder.returns = refer('R');
        builder.name = 'accept';
        builder.types.add(refer('R'));

        builder.requiredParameters.add(
          Parameter((builder) {
            builder.type = TypeReference((builder) {
              builder.symbol = '${name}Visitor';
              builder.types.add(refer('R'));
            });
            builder.name = 'visitor';
          }),
        );
      }),
    );
  });
}

Class _defineType(String baseName, String className, List<(String, String)> fields) {
  return Class((builder) {
    builder.modifier = ClassModifier.final$;
    builder.name = className;
    builder.implements.add(refer(baseName));

    builder.constructors.add(
      Constructor((builder) {
        builder.constant = true;

        for (final (_, name) in fields) {
          builder.requiredParameters.add(
            Parameter((builder) {
              builder.toThis = true;
              builder.name = name;
            }),
          );
        }
      }),
    );

    for (final (type, name) in fields) {
      builder.fields.add(
        Field((builder) {
          builder.modifier = FieldModifier.final$;
          builder.type = refer(type);
          builder.name = name;
        }),
      );
    }

    builder.methods.add(
      Method((builder) {
        builder.annotations.add(refer('override'));
        builder.returns = refer('R');
        builder.name = 'accept';
        builder.types.add(refer('R'));

        builder.requiredParameters.add(
          Parameter((builder) {
            builder.type = TypeReference(
              (builder) {
                builder.symbol = '${baseName}Visitor';
                builder.types.add(refer('R'));
              },
            );
            builder.name = 'visitor';
          }),
        );

        builder.lambda = true;
        builder.body = refer('visitor') //
            .property('visit$className')
            .call([refer('this')]) //
            .code;
      }),
    );
  });
}

Class _defineVisitor(String baseName, Map<String, List<(String, String)>> types) {
  return Class((builder) {
    builder.name = '${baseName}Visitor';
    builder.abstract = true;
    builder.modifier = ClassModifier.interface;
    builder.types.add(refer('R'));

    for (final type in types.keys) {
      final typeName = '$type$baseName';

      final method = Method((builder) {
        builder.returns = refer('R');
        builder.name = 'visit$type$baseName';
        builder.requiredParameters.add(
          Parameter((builder) {
            builder.type = refer(typeName);
            builder.name = ReCase(baseName).camelCase;
          }),
        );
      });

      builder.methods.add(method);
    }
  });
}
