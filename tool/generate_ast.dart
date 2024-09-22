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
        name: 'AstNode',
        methods: [
          Method((builder) {
            builder.annotations.add(refer('override'));
            builder.type = MethodType.getter;
            builder.returns = refer('int');
            builder.name = 'length';
            builder.lambda = true;
            builder.body = refer('end').operatorSubtract(refer('offset')).code;
          }),
          Method((builder) {
            builder.returns = refer('R?');
            builder.name = 'accept';
            builder.types.add(refer('R'));
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = TypeReference((builder) {
                  builder.url = 'visitors.dart';
                  builder.symbol = 'AstNodeVisitor';
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
                  builder.symbol = 'AstNodeVisitor';
                  builder.types.add(refer('R'));
                });
                builder.name = 'visitor';
              }),
            );
          }),
        ],
        children: [
          TreeNode(
            name: 'TypeIdentifier',
            children: [
              TreeNode(
                name: 'TopTypeIdentifier',
                properties: [Token('verum')],
              ),
              TreeNode(
                name: 'BottomTypeIdentifier',
                properties: [Token('falsum')],
              ),
              TreeNode(
                name: 'ListTypeIdentifier',
                properties: [
                  Token('leftBracket'),
                  Property('TypeIdentifier', 'identifier'),
                  Token('rightBracket'),
                ],
              ),
              TreeNode(
                name: 'SetTypeIdentifier',
                properties: [
                  Token('leftBrace'),
                  Property('TypeIdentifier', 'identifier'),
                  Token('rightBrace'),
                ],
              ),
              TreeNode(
                name: 'MapTypeIdentifier',
                properties: [
                  Token('leftBrace'),
                  Property('TypeIdentifier', 'key'),
                  Token('colon'),
                  Property('TypeIdentifier', 'value'),
                  Token('rightBrace'),
                ],
              ),
              TreeNode(
                name: 'IdentifiedTypeIdentifier',
                properties: [
                  Token('identifier'),
                  Token('leftParenthesis', optional: true),
                  Property('SyntacticEntityList<TypeIdentifier>?', 'arguments', iterable: true),
                  Token('rightParenthesis', optional: true),
                ],
              ),
              TreeNode(
                name: 'OptionTypeIdentifier',
                properties: [
                  Property('TypeIdentifier', 'identifier'),
                  Token('eroteme'),
                ],
              ),
            ],
          ),
          TreeNode(
            name: 'Node',
            children: [
              TreeNode(
                name: 'TypeVariantParameterNode',
                properties: [
                  Property('TypeIdentifier', 'typeIdentifier'),
                  Token('name'),
                ],
              ),
              TreeNode(
                name: 'TypeVariantNode',
                properties: [
                  Token('name'),
                  Property('SyntacticEntityList<TypeVariantParameterNode>', 'parameters', iterable: true),
                ],
              ),
            ],
          ),
          TreeNode(
            name: 'Expression',
            children: [
              TreeNode(
                name: 'IdentifierExpression',
                properties: [
                  Token('identifier'),
                ],
              ),
              TreeNode(
                name: 'LetExpression',
                properties: [
                  Token('identifier'),
                  Token('equals'),
                  Property('Expression', 'binding'),
                  Property('Expression', 'result'),
                ],
              ),
              TreeNode(
                name: 'Literal',
                methods: [
                  Method((builder) {
                    builder.returns = refer('Token');
                    builder.type = MethodType.getter;
                    builder.name = 'literal';
                  }),
                ],
                children: [
                  TreeNode(
                    name: 'UnitLiteral',
                    properties: [
                      Token('literal', override: true),
                    ],
                  ),
                  TreeNode(
                    name: 'BooleanLiteral',
                    properties: [
                      Token('literal', override: true),
                    ],
                  ),
                  // TreeNode(
                  //   name: 'IntegerLiteral',
                  //   properties: [
                  //     Token('literal'),
                  //   ],
                  // ),
                  // TreeNode(
                  //   name: 'DoubleLiteral',
                  //   properties: [
                  //     Token('literal'),
                  //   ],
                  // ),
                  TreeNode(
                    name: 'StringLiteral',
                    properties: [
                      Token('literal', override: true),
                    ],
                  ),
                ],
              ),
            ],
          ),
          TreeNode(
            name: 'Declaration',
            children: [
              TreeNode(
                name: 'ImportDeclaration',
                properties: [
                  Token('keyword'),
                  Property('ImportType', 'type', visitable: false),
                  Token('identifier'),
                ],
              ),
              TreeNode(
                name: 'TypeDefinition',
                properties: [
                  Token('keyword'),
                  Token('name'),
                  Token('leftParenthesis', optional: true),
                  Property('SyntacticEntityList<IdentifiedTypeIdentifier>?', 'parameters', iterable: true),
                  Token('rightParenthesis', optional: true),
                  Token('equals'),
                  Property('SyntacticEntityList<TypeVariantNode>', 'variants', iterable: true),
                ],
              ),
              TreeNode(
                name: 'LetDeclaration',
                properties: [
                  Token('keyword'),
                  Token('identifier'),
                  Token('parameter', optional: true),
                  Token('equals'),
                  Property('Expression', 'body'),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    astGenerator.imports.add('package:pinto/ast.dart');
    astGenerator.imports.add('package:pinto/lexer.dart');
    astGenerator.imports.add('package:pinto/syntactic_entity.dart');

    void syntacticEntityImplementation(ClassBuilder builder, TreeNode node) {
      if (node.root == node) {
        builder.implements.add(refer('SyntacticEntity'));
      }

      if (node.value.properties.isNotEmpty) {
        builder.methods.add(
          Method((builder) {
            builder.annotations.add(refer('override'));
            builder.type = MethodType.getter;
            builder.returns = refer('int');
            builder.name = 'offset';
            builder.lambda = true;
            builder.body = node.value.getOffsetBody().code;
          }),
        );

        builder.methods.add(
          Method((builder) {
            builder.annotations.add(refer('override'));
            builder.type = MethodType.getter;
            builder.returns = refer('int');
            builder.name = 'end';
            builder.lambda = true;
            builder.body = node.value.getEndBody().code;
          }),
        );
      }
    }

    astGenerator.addMethodBuilder(syntacticEntityImplementation);

    astGenerator.write(outputFile);
  }
}
