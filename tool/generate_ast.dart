import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

import 'node.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: generate_ast <output directory>');
    exit(64); // exit(usage)
  } else {
    final [outputFileString] = args;

    final outputFile = File(outputFileString);

    final astGenerator = _TreeGenerator(
      root: _TreeNode(
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
          _TreeNode(
            name: 'TypeIdentifier',
            children: [
              _TreeNode(
                name: 'TopTypeIdentifier',
                properties: [Property('Token', 'verum')],
              ),
              _TreeNode(
                name: 'BottomTypeIdentifier',
                properties: [Property('Token', 'falsum')],
              ),
              _TreeNode(
                name: 'ListTypeIdentifier',
                properties: [
                  Property('Token', 'leftBracket'),
                  Property('TypeIdentifier', 'identifier'),
                  Property('Token', 'rightBracket'),
                ],
              ),
              _TreeNode(
                name: 'SetTypeIdentifier',
                properties: [
                  Property('Token', 'leftBrace'),
                  Property('TypeIdentifier', 'identifier'),
                  Property('Token', 'rightBrace'),
                ],
              ),
              _TreeNode(
                name: 'MapTypeIdentifier',
                properties: [
                  Property('Token', 'leftBrace'),
                  Property('TypeIdentifier', 'key'),
                  Property('Token', 'colon'),
                  Property('TypeIdentifier', 'value'),
                  Property('Token', 'rightBrace'),
                ],
              ),
              _TreeNode(
                name: 'IdentifiedTypeIdentifier',
                properties: [
                  Property('Token', 'identifier'),
                  Property('Token?', 'leftParenthesis'),
                  Property('SyntacticEntityList<TypeIdentifier>?', 'arguments'),
                  Property('Token?', 'rightParenthesis'),
                ],
              ),
              _TreeNode(
                name: 'OptionTypeIdentifier',
                properties: [
                  Property('TypeIdentifier', 'identifier'),
                  Property('Token', 'eroteme'),
                ],
              ),
            ],
          ),
          _TreeNode(
            name: 'Node',
            children: [
              _TreeNode(
                name: 'TypeVariantParameterNode',
                properties: [
                  Property('TypeIdentifier', 'type'),
                  Property('Token', 'name'),
                ],
              ),
              _TreeNode(
                name: 'TypeVariantNode',
                properties: [
                  Property('Token', 'name'),
                  Property('SyntacticEntityList<TypeVariantParameterNode>', 'parameters'),
                ],
              ),
            ],
          ),
          _TreeNode(
            name: 'Expression',
            children: [
              _TreeNode(
                name: 'LetExpression',
                properties: [
                  Property('Token', 'identifier'),
                  Property('Token', 'equals'),
                  Property('Expression', 'binding'),
                  Property('Expression', 'result'),
                ],
              ),
              _TreeNode(
                name: 'Literal',
                children: [
                  _TreeNode(
                    name: 'StringLiteral',
                    properties: [
                      Property('Token', 'literal'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _TreeNode(
            name: 'Declaration',
            children: [
              _TreeNode(
                name: 'ImportDeclaration',
                properties: [
                  Property('Token', 'keyword'),
                  Property('ImportType', 'type'),
                  Property('Token', 'identifier'),
                ],
              ),
              _TreeNode(
                name: 'TypeDefinition',
                properties: [
                  Property('Token', 'keyword'),
                  Property('Token', 'name'),
                  Property('Token?', 'leftParenthesis'),
                  Property('SyntacticEntityList<IdentifiedTypeIdentifier>?', 'parameters'),
                  Property('Token?', 'rightParenthesis'),
                  Property('Token', 'equals'),
                  Property('SyntacticEntityList<TypeVariantNode>', 'variants'),
                ],
              ),
              _TreeNode(
                name: 'FunctionDeclaration',
                properties: [
                  Property('Token', 'identifier'),
                  Property('SyntacticEntityList<Token>', 'parameters'),
                  Property('Expression', 'definition'),
                ],
              ),
            ],
          ),
        ],
      ),
      outputFile: outputFile,
    );

    astGenerator.defineType('ImportType', 'package:pinto/ast.dart');
    astGenerator.defineType('SyntacticEntity', 'package:pinto/lexer.dart');
    astGenerator.defineType('Token', 'package:pinto/syntactic_entity.dart');

    astGenerator.write();

    await Process.run(
      'dart',
      ['fix', '--apply', '--code=unnecessary_import,unused_import'],
    );
  }
}

extension type Property._((String, String) _from) {
  const Property(String type, String name) : _from = (type, name);

  static final listRegexp = RegExp(r'SyntacticEntityList<(\w+)>');

  bool get optional => type.endsWith('?');

  String? get listOf {
    final match = listRegexp.firstMatch(type);
    if (match?[1] case final type?) {
      return type;
    } else {
      return null;
    }
  }

  String get type => _from.$1;
  String get name => _from.$2;
}

extension type _TreeNode._(Node<_NodeDescription> node) implements Node<_NodeDescription> {
  _TreeNode({
    required String name,
    List<Property> properties = const [],
    List<Method> methods = const [],
    List<_TreeNode> children = const [],
  }) : node = Node(
          value: _NodeDescription(
            name: name,
            properties: properties,
            methods: methods,
          ),
          children: children,
        );
}

final class _NodeDescription {
  const _NodeDescription({
    required this.name,
    this.properties = const [],
    this.methods = const [],
  });

  final String name;
  final List<Property> properties;
  final List<Method> methods;

  Expression getOffsetBody() {
    var current = 0;
    Expression body = refer(properties[current].name);

    while (current <= properties.length && properties[current].optional) {
      current = current + 1;
      body = body.nullSafeProperty('offset').ifNullThen(refer(properties[current].name));
    }

    return body.property('offset');
  }

  Expression getEndBody() {
    var current = properties.length - 1;
    Expression body = refer(properties[current].name);

    while (current >= 0 && properties[current].optional) {
      current = current - 1;
      body = body.nullSafeProperty('end').ifNullThen(refer(properties[current].name));
    }

    return body.property('end');
  }
}

final class _TreeGenerator {
  _TreeGenerator({
    required this.root,
    required this.outputFile,
  });

  final Node<_NodeDescription> root;

  final File outputFile;

  final _types = <String, TypeReference>{};
  final _nodesTypes = <String>[];

  final _dartEmitter = DartEmitter(
    allocator: Allocator(),
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final _dartFormatter = DartFormatter();

  void defineType(String name, String url, {List<String> typeParameters = const []}) {
    _types[name] = TypeReference((builder) {
      builder.symbol = name;
      builder.types.addAll(typeParameters.map(refer));
      builder.url = url;
    });

    _types['$name?'] = TypeReference((builder) {
      builder.symbol = name;
      builder.isNullable = true;
      builder.types.addAll(typeParameters.map(refer));
      builder.url = url;
    });
  }

  Future<void> write() async {
    // Define visitor files eagerly
    defineType(
      '${root.value.name}Visitor',
      'visitors.dart',
      typeParameters: ['R'],
    );

    defineType(
      'Simple${root.value.name}Visitor',
      'visitors.dart',
      typeParameters: ['R'],
    );

    defineType(
      'Generalizing${root.value.name}Visitor',
      'visitors.dart',
      typeParameters: ['R'],
    );

    // Generate tree nodes files
    final treeLibrary = LibraryBuilder();

    root.descent((current) {
      _defineNodeType(
        name: current.value.name,
        url: basename(outputFile.absolute.path),
      );

      treeLibrary.body.add(
        _classFromNode(node: current),
      );
    });

    final treeLibraryContent = treeLibrary.build().accept(_dartEmitter);
    final treeLibraryFormattedContent = _dartFormatter.format('$treeLibraryContent');

    await outputFile.create(recursive: true);
    await outputFile.writeAsString(treeLibraryFormattedContent);

    // Generate visitors file
    final path = '${outputFile.parent.absolute.path}/visitors.dart';
    final file = File(path);

    await file.create(recursive: true);

    final visitorsLibrary = Library((builder) {
      builder.body.add(
        _visitorFromNode(node: root),
      );

      builder.body.add(
        _simpleVisitorFromNode(node: root),
      );

      builder.body.add(
        _generalizingVisitorFromNode(node: root),
      );
    });

    final visitorsLibraryContent = visitorsLibrary.accept(_dartEmitter);
    final visitorsLibraryFormattedContent = _dartFormatter.format('$visitorsLibraryContent');
    file.writeAsString(visitorsLibraryFormattedContent);
  }

  Class _classFromNode({
    required Node<_NodeDescription> node,
  }) {
    return Class((builder) {
      if (node.leaf) {
        builder.modifier = ClassModifier.final$;
      } else {
        builder.sealed = true;
      }

      builder.name = node.value.name;

      if (node.parent?.value.name case final superclassName?) {
        builder.extend = _types[superclassName]!;
      }

      // TODO(mateusfccp): Generalize this code for when we use this generator also for semantic entities
      if (node.root == node) {
        builder.implements.add(
          _types['SyntacticEntity']!,
        );
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
      // ENDTODO

      builder.constructors.add(
        Constructor((builder) {
          builder.constant = true;

          for (final property in node.value.properties) {
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.toThis = true;
                builder.name = property.name;
              }),
            );
          }
        }),
      );

      for (final property in node.value.properties) {
        builder.fields.add(
          Field((builder) {
            builder.modifier = FieldModifier.final$;
            builder.type = _types[property.type]!;
            builder.name = property.name;
          }),
        );
      }

      for (final method in node.value.methods) {
        builder.methods.add(method);
      }

      if (node.leaf) {
        builder.methods.add(
          _acceptMethod(node: node),
        );
      }

      if (!builder.methods.build().any((Method method) => method.name == 'visitChildren')) {
        builder.methods.add(
          _visitChildrenMethod(node: node),
        );
      }
    });
  }

  Method _acceptMethod({
    required Node<_NodeDescription> node,
  }) {
    return Method((builder) {
      builder.annotations.add(refer('override'));
      builder.returns = refer('R?');
      builder.name = 'accept';
      builder.types.add(refer('R'));

      builder.requiredParameters.add(
        Parameter((builder) {
          builder.type = _types['${node.root.value.name}Visitor']!;
          builder.name = 'visitor';
        }),
      );

      builder.lambda = true;
      builder.body = refer('visitor') //
          .property('visit${node.value.name}')
          .call([refer('this')]) //
          .code;
    });
  }

  Method _visitChildrenMethod({
    required Node<_NodeDescription> node,
  }) {
    return Method((builder) {
      builder.annotations.add(refer('override'));
      builder.returns = refer('void');
      builder.name = 'visitChildren';
      builder.types.add(refer('R'));

      builder.requiredParameters.add(
        Parameter((builder) {
          builder.type = _types['${node.root.value.name}Visitor']!;
          builder.name = 'visitor';
        }),
      );

      builder.body = Block((builder) {
        for (final property in node.value.properties) {
          if (property.listOf case final type? when _nodesTypes.contains(type)) {
            final wrapper = refer('AstNodeList');
            final name = wrapper.call([refer(property.name)]);
            final nameProperty = property.optional ? name.property : name.nullSafeProperty;

            builder.statements.add(
              nameProperty('visitChildren').call([refer('visitor')]).statement,
            );
          } else if (_nodesTypes.contains(property.type)) {
            final name = refer(property.name);
            final nameProperty = property.optional ? name.nullSafeProperty : name.property;

            builder.statements.add(
              nameProperty('accept').call([refer('visitor')]).statement,
            );
          }
        }
      });
    });
  }

  // TODO(mateusfccp): Think about an alternative to this that is also not overwhelming
  void _defineNodeType({
    required String name,
    required String url,
  }) {
    _types[name] = TypeReference((builder) {
      builder.symbol = name;
      builder.url = url;
    });

    _types['$name?'] = TypeReference((builder) {
      builder.symbol = name;
      builder.isNullable = true;
      builder.url = url;
    });

    _types['SyntacticEntityList<$name>'] = TypeReference((builder) {
      builder.symbol = 'SyntacticEntityList';
      builder.types.add(_types[name]!);
      builder.url = 'package:pinto/syntactic_entity.dart';
    });

    _types['SyntacticEntityList<$name>?'] = TypeReference((builder) {
      builder.symbol = 'SyntacticEntityList';
      builder.types.add(_types[name]!);
      builder.isNullable = true;
      builder.url = 'package:pinto/syntactic_entity.dart';
    });

    _nodesTypes.addAll([name, '$name?', 'List<$name>', 'List<$name>?']);
  }

  Class _visitorFromNode({
    required Node<_NodeDescription> node,
  }) {
    return Class((builder) {
      builder.name = '${node.value.name}Visitor';
      builder.abstract = true;
      builder.modifier = ClassModifier.interface;
      builder.types.add(refer('R'));

      node.descent((child) {
        if (child.leaf) {
          final method = Method((builder) {
            builder.returns = refer('R?');
            builder.name = 'visit${child.value.name}';
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = _types[child.value.name]!;
                builder.name = 'node';
              }),
            );
          });

          builder.methods.add(method);
        }
      });
    });
  }

  Class _simpleVisitorFromNode({
    required Node<_NodeDescription> node,
  }) {
    return Class((builder) {
      builder.name = 'Simple${node.value.name}Visitor';
      builder.abstract = true;
      builder.modifier = ClassModifier.base;
      builder.types.add(refer('R'));
      builder.implements.add(_types['${node.value.name}Visitor']!);

      node.descent((child) {
        if (child.leaf) {
          final method = Method((builder) {
            builder.annotations.add(refer('override'));
            builder.returns = refer('R?');
            builder.name = 'visit${child.value.name}';
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = _types[child.value.name]!;
                builder.name = 'node';
              }),
            );

            builder.lambda = true;
            builder.body = literalNull.code;
          });

          builder.methods.add(method);
        }
      });
    });
  }

  Class _generalizingVisitorFromNode({
    required Node<_NodeDescription> node,
  }) {
    return Class((builder) {
      builder.name = 'Generalizing${node.value.name}Visitor';
      builder.abstract = true;
      builder.modifier = ClassModifier.base;
      builder.types.add(refer('R'));
      builder.implements.add(_types['${node.value.name}Visitor']!);

      node.descent((child) {
        final method = Method((builder) {
          if (child.leaf) {
            builder.annotations.add(refer('override'));
          }

          builder.returns = refer('R?');
          builder.name = 'visit${child.value.name}';
          builder.requiredParameters.add(
            Parameter((builder) {
              builder.type = _types[child.value.name]!;
              builder.name = 'node';
            }),
          );

          if (child.parent case final parent?) {
            builder.lambda = true;
            builder.body = refer('visit${parent.value.name}').call([refer('node')]).code;
          } else {
            builder.body = Block.of([
              refer('node').property('visitChildren').call([refer('this')]).statement,
              refer('null').returned.statement,
            ]);
          }
        });

        builder.methods.add(method);
      });
    });
  }
}
