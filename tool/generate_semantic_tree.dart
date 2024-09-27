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
            name: 'TypedElement',
            interface: true,
            visitable: false,
            methods: [
              Method((builder) {
                builder.returns = refer('Type?');
                builder.type = MethodType.getter;
                builder.name = 'type';
              }),
            ],
          ),
          TreeNode(
            name: 'ParameterElement',
            implements: ['TypedElement'],
            properties: [
              StringProperty('name'),
              TypeProperty(),
              EnclosingElement('Element'),
            ],
          ),
          TreeNode(
            name: 'ExpressionElement',
            implements: ['TypedElement'],
            methods: [
              Method((builder) {
                builder.returns = refer('bool');
                builder.type = MethodType.getter;
                builder.name = 'constant';
              }),
            ],
            properties: [
              EnclosingElement('Element'),
            ],
            children: [
              TreeNode(
                name: 'InvocationElement',
                properties: [
                  TypeProperty(),
                  Property('IdentifierElement', 'identifier'),
                  Property('ExpressionElement', 'argument'),
                  Property('bool', 'constant', override: true, visitable: false),
                ],
              ),
              TreeNode(
                name: 'IdentifierElement',
                properties: [
                  StringProperty('name'),
                  TypeProperty(),
                  Property('bool', 'constant', override: true, visitable: false),
                ],
              ),
              TreeNode(
                name: 'LiteralElement',
                properties: [
                  TypeProperty(),
                  Property('bool', 'constant', override: true, visitable: false),
                  Property('Object?', 'constantValue', visitable: false),
                ],
              ),
            ],
          ),
          TreeNode(
            name: 'TypeVariantElement',
            properties: [
              StringProperty('name'),
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
                name: 'LetFunctionDeclaration',
                implements: ['TypedElement'],
                properties: [
                  StringProperty('name'),
                  Token('parameter'), // TODO(mateusfccp): have an element for this in the future
                  TypeProperty(type: 'FunctionType'),
                  Property('ExpressionElement', 'body'),
                ],
              ),
              TreeNode(
                name: 'LetVariableDeclaration',
                implements: ['TypedElement'],
                properties: [
                  StringProperty('name'),
                  TypeProperty(),
                  Property('ExpressionElement', 'body'),
                ],
              ),
              TreeNode(
                name: 'TypeDefiningDeclaration',
                methods: [
                  Method((builder) {
                    builder.returns = refer('Type');
                    builder.type = MethodType.getter;
                    builder.name = 'definedType';
                  })
                ],
                children: [
                  TreeNode(
                    name: 'ImportedSymbolSyntheticElement',
                    implements: ['TypedElement'],
                    properties: [
                      StringProperty('name'),
                      TypeProperty(),
                      Property('Type', 'definedType', final$: false, late: true, override: true, visitable: false),
                    ],
                  ),
                  TreeNode(
                    name: 'TypeParameterElement',
                    implements: ['TypedElement'],
                    properties: [
                      StringProperty('name'),
                      TypeProperty(initializer: refer('TypeType').call([])),
                      Property('Type', 'definedType', final$: false, late: true, override: true, visitable: false),
                    ],
                  ),
                  TreeNode(
                    name: 'TypeDefinitionElement',
                    implements: ['TypedElement'],
                    properties: [
                      StringProperty('name'),
                      EmptyList('List<TypeParameterElement>', 'parameters'),
                      EmptyList('List<TypeVariantElement>', 'variants'),
                      TypeProperty(initializer: refer('TypeType').call([])),
                      Property('Type', 'definedType', final$: false, late: true, override: true, visitable: false),
                    ],
                  ),
                ],
              ),
            ],
          ),
          TreeNode(
            name: 'ProgramElement',
            properties: [
              EmptyList('List<ImportElement>', 'imports'),
              EmptyList('List<DeclarationElement>', 'declarations'),
              EnclosingElement('Null', initializer: literalNull, final$: true),
            ],
          ),
        ],
      ),
      constructorRule: TreeGeneratorConstructorRule.named,
    );

    astGenerator.imports.add('package:pinto/lexer.dart');
    astGenerator.imports.add('package.dart');
    astGenerator.imports.add('type.dart');

    astGenerator.write(outputFile);
  }
}

final class TypeProperty extends Property {
  TypeProperty({String type = 'Type?', String name = 'type', Expression? initializer})
      : super(
          type,
          name,
          visitable: false,
          final$: false,
          override: true,
          initializer: initializer,
        );
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
