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
            name: 'TypeDefiningElement',
            interface: true,
            visitable: false,
            methods: [
              Method((builder) {
                builder.returns = refer('Type');
                builder.type = MethodType.getter;
                builder.name = 'definedType';
              })
            ],
          ),
          TreeNode(
            name: 'TypeParameterElement',
            implements: ['TypedElement', 'TypeDefiningElement'],
            properties: [
              StringProperty('name'),
              EnclosingElement('TypeDefinitionElement'),
              TypeProperty(initializer: refer('TypeType').call([])),
              Property('Type', 'definedType', final$: false, late: true, override: true, visitable: false),
            ],
          ),
          TreeNode(
            name: 'StructMemberElement',
            properties: [
              StringProperty('name', late: true),
              Property('ExpressionElement', 'value', late: true),
              EnclosingElement('LiteralElement'),
            ],
          ),
          // TODO(mateusfccp): Parameter Element should be completely replaced by struct element
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
              Method((builder) {
                builder.returns = refer('Object?');
                builder.type = MethodType.getter;
                builder.name = 'constantValue';
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
                  Property('Object?', 'constantValue', override: true, visitable: false),
                ],
              ),
              TreeNode(
                name: 'IdentifierElement',
                properties: [
                  StringProperty('name'),
                  TypeProperty(),
                  Property('bool', 'constant', override: true, visitable: false),
                  Property('Object?', 'constantValue', override: true, visitable: false),
                ],
              ),
              TreeNode(
                name: 'LiteralElement',
                children: [
                  TreeNode(
                    name: 'SingletonLiteralElement',
                    properties: [
                      TypeProperty(),
                      Property('bool', 'constant', override: true, visitable: false, late: true),
                      Property('Object?', 'constantValue', override: true, visitable: false, late: true),
                    ],
                  ),
                  TreeNode(
                    name: 'StructLiteralElement',
                    properties: [
                      TypeProperty(type: 'StructType', late: true, final$: true),
                      Property('List<StructMemberElement>', 'members', initializer: literalList([]), iterable: true),
                      Property('bool', 'constant', override: true, visitable: false, late: true),
                      Property('Object?', 'constantValue', override: true, visitable: false, late: true),
                    ],
                  ),
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
                name: 'LetDeclarationElement',
                implements: ['TypedElement'],
                properties: [
                  StringProperty('name'),
                  Property('ExpressionElement', 'body', late: true),
                ],
                children: [
                  TreeNode(
                    name: 'LetFunctionDeclaration',
                    properties: [
                      StringProperty('name', super$: true),
                      Property('StructLiteralElement', 'parameter'),
                      TypeProperty(type: 'FunctionType', late: true),
                    ],
                  ),
                  TreeNode(
                    name: 'LetVariableDeclaration',
                    properties: [
                      StringProperty('name', super$: true),
                      TypeProperty(),
                    ],
                  ),
                ],
              ),
              TreeNode(
                name: 'ImportedSymbolSyntheticElement',
                implements: ['TypedElement'],
                properties: [
                  StringProperty('name'),
                  Property('TypedElement', 'syntheticElement'),
                ],
                methods: [
                  Method((builder) {
                    builder.annotations.add(refer('override'));
                    builder.returns = refer('Type');
                    builder.type = MethodType.getter;
                    builder.name = 'type';
                    builder.lambda = true;
                    builder.body = refer('syntheticElement').property('type').nullChecked.code;
                  })
                ],
              ),
              TreeNode(
                name: 'TypeDefinitionElement',
                implements: ['TypedElement', 'TypeDefiningElement'],
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

    astGenerator.imports.add('package.dart');
    astGenerator.imports.add('type.dart');
    astGenerator.imports.add('visitors.dart');

    astGenerator.write(outputFile);
  }
}

final class TypeProperty extends Property {
  TypeProperty({
    String type = 'Type?',
    String name = 'type',
    Expression? initializer,
    super.late,
    super.final$ = false,
  }) : super(
          type,
          name,
          visitable: false,
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
