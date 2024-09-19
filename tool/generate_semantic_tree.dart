import 'dart:io';

import 'package:code_builder/code_builder.dart';

import 'tree_generator.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: generate_ast <output directory>');
    exit(64); // exit(usage)
  } else {
    final [outputFileString] = args;

    final outputFile = File(outputFileString);

    final astGenerator = TreeGenerator(
      root: TreeNode(
        name: 'Element',
        methods: [
          Method((builder) {
            builder.type = MethodType.getter;
            builder.returns = refer('Element?');
            builder.name = 'enclosingElement';
          }),
          Method((builder) {
            builder.returns = refer('R?');
            builder.name = 'accept';
            builder.types.add(refer('R'));
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = TypeReference((builder) {
                  builder.url = 'visitors.dart';
                  builder.symbol = 'ElementVisitor';
                  builder.types.add(refer('R'));
                });
                builder.name = 'visitor';
              }),
            );
          }),
          Method((builder) {
            builder.returns = refer('void');
            builder.name = 'visitChildren';
            builder.types.add(refer('R'));
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = TypeReference((builder) {
                  builder.url = 'visitors.dart';
                  builder.symbol = 'ElementVisitor';
                  builder.types.add(refer('R'));
                });
                builder.name = 'visitor';
              }),
            );
          }),
        ],
        children: [
          TreeNode(
            name: 'ParameterElement',
            properties: [
              Property('String', 'name', visitable: false),
              Property('PintoType?', 'type', final$: false, visitable: false),
              EnclosingElement('Element'),
            ],
          ),
          TreeNode(
            name: 'TypeVariantElement',
            properties: [
              Property('String', 'name', visitable: false),
              EmptyList('List<ParameterElement>', 'parameters'),
              EnclosingElement('TypeDefinitionElement'),
            ],
          ),
          TreeNode(
            name: 'DeclarationElement',
            properties: [
              EnclosingElement('ProgramElement'),
            ],
            children: [
              TreeNode(
                name: 'ImportElement',
                properties: [
                  Property('Package', 'package', visitable: false),
                ],
              ),
              TreeNode(
                name: 'TypeDefinitionElement',
                properties: [
                  Property('String', 'name', visitable: false),
                  EmptyList(
                    'List<TypeParameterType>',
                    'parameters',
                    visitable: false,
                  ),
                  EmptyList('List<TypeVariantElement>', 'variants'),
                ],
              ),
            ],
          ),
          TreeNode(
            name: 'ProgramElement',
            properties: [
              EmptyList('List<ImportElement>', 'imports'),
              EmptyList('List<TypeDefinitionElement>', 'typeDefinitions'),
              EnclosingElement('Null', initializer: literalNull, final$: true),
            ],
          ),
        ],
      ),
      constructorRule: TreeGeneratorConstructorRule.named,
    );

    astGenerator.imports.add('package.dart');
    astGenerator.imports.add('type.dart');

    astGenerator.write(outputFile);
  }
}

final class EnclosingElement extends Property {
  EnclosingElement(String type, {super.initializer, super.final$ = false})
      : super(
          type,
          'enclosingElement',
          override: true,
          late: true,
          visitable: false,
        );
}
