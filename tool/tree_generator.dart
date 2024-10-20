import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';

import 'node.dart';

base class Property {
  const Property(
    this.type,
    this.name, {
    this.initializer,
    this.iterable = false,
    this.final$ = true,
    this.visitable = true,
    this.late = false,
    this.override = false,
  });

  final String type;
  final String name;
  final Expression? initializer;

  final bool iterable;
  final bool final$;
  final bool visitable;
  final bool late;
  final bool override;

  bool get optional => type.endsWith('?');
}

final class StringProperty extends Property {
  StringProperty(String name)
      : super(
          'String',
          name,
          visitable: false,
        );
}

final class EmptyList extends Property {
  EmptyList(
    super.type,
    super.name, {
    super.final$,
    super.visitable,
  }) : super(
          iterable: true,
          initializer: literalList([]),
        );
}

final class Token extends Property {
  Token(String name, {super.late, bool optional = false, super.override = false})
      : super(
          'Token${optional ? '?' : ''}',
          name,
          visitable: false,
        );
}

extension type TreeNode._(Node<_NodeDescription> _node) implements Node<_NodeDescription> {
  TreeNode({
    required String name,
    List<Property> properties = const [],
    List<Method> methods = const [],
    List<TreeNode> children = const [],
    List<String> implements = const [],
    bool visitable = true,
    bool interface = false,
  }) : _node = Node(
          value: _NodeDescription(
            name: name,
            properties: properties,
            methods: methods,
            implements: implements,
            visitable: visitable,
            interface: interface,
          ),
          children: children,
        );

  String get name => _node.value.name;
  List<Property> get properties => _node.value.properties;
  List<Method> get methods => _node.value.methods;
  List<String> get implements => _node.value.implements;
  bool get visitable => _node.value.visitable;
  bool get interface => _node.value.interface;

  TreeNode get root => _node.root as TreeNode;
  TreeNode? get parent => _node.parent as TreeNode?;

  void descent(void Function(TreeNode) executor) {
    _node.descent((node) => executor(node as TreeNode));
  }

  bool canHaveConstConstructor() {
    bool check(TreeNode node) => !node.properties.any((property) => !property.final$ || property.initializer != null);

    TreeNode current = this;

    while (current.root != current) {
      if (!check(current)) return false;
      current = current.parent!;
    }

    return true;
  }

  List<Property> getAllProperties() => [..._node.value.properties, ...?parent?.getAllProperties()];
}

final class _NodeDescription {
  const _NodeDescription({
    required this.name,
    required this.properties,
    required this.methods,
    required this.implements,
    required this.visitable,
    required this.interface,
  });

  final String name;
  final List<Property> properties;
  final List<Method> methods;
  final List<String> implements;
  final bool visitable;
  final bool interface;

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

typedef NodeBuilder = void Function(ClassBuilder builder, TreeNode node);

enum TreeGeneratorConstructorRule { positional, named }

final class TreeGenerator {
  TreeGenerator({
    required this.root,
    this.constructorRule = TreeGeneratorConstructorRule.positional,
  });

  final TreeNode root;
  final TreeGeneratorConstructorRule constructorRule;

  final imports = <String>{};

  final _dartEmitter = DartEmitter(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  final _dartFormatter = DartFormatter();

  final _nodeBuilders = <NodeBuilder>[];

  void addMethodBuilder(NodeBuilder f) {
    _nodeBuilders.add(f);
  }

  Future<void> write(File outputFile) async {
    // Generate tree nodes files
    final treeLibrary = LibraryBuilder();

    for (final import in imports) {
      treeLibrary.directives.add(
        Directive.import(import),
      );
    }

    root.descent((current) {
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
      builder.directives.add(
        Directive.import(basename(outputFile.absolute.path)),
      );

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
    required TreeNode node,
  }) {
    return Class((builder) {
      if (node.interface) {
        builder.abstract = true;
        builder.modifier = ClassModifier.interface;
      } else if (node.leaf) {
        builder.modifier = ClassModifier.final$;
      } else {
        builder.sealed = true;
      }

      builder.name = node.name;

      if (node.parent?.name case final superclassName?) {
        builder.extend = refer(superclassName);
      }

      for (final implements in node.value.implements) {
        builder.implements.add(refer(implements));
      }

      for (final nodeBuilder in _nodeBuilders) {
        nodeBuilder(builder, node);
      }

      if (!node.interface) {
        builder.constructors.add(
          Constructor((builder) {
            builder.constant = node.canHaveConstConstructor();

            for (final property in node.properties) {
              if (property.initializer == null && !property.late) {
                switch (constructorRule) {
                  case TreeGeneratorConstructorRule.positional when property.final$:
                    builder.requiredParameters.add(
                      Parameter((builder) {
                        builder.toThis = true;
                        builder.name = property.name;
                      }),
                    );
                  case TreeGeneratorConstructorRule.positional:
                    builder.optionalParameters.add(
                      Parameter((builder) {
                        builder.toThis = true;
                        builder.name = property.name;
                      }),
                    );
                  case TreeGeneratorConstructorRule.named:
                    builder.optionalParameters.add(
                      Parameter((builder) {
                        builder.required = property.final$ || !property.optional;
                        builder.named = true;
                        builder.toThis = true;
                        builder.name = property.name;
                      }),
                    );
                }
              }
            }
          }),
        );
      }

      for (final property in node.properties) {
        builder.fields.add(
          Field((builder) {
            if (property.override) {
              builder.annotations.add(refer('override'));
            }

            if (property.final$) {
              builder.modifier = FieldModifier.final$;
            }

            if (property.late) {
              builder.late = true;
            }

            builder.type = refer(property.type);

            builder.name = property.name;

            if (property.initializer case final initializer?) {
              builder.assignment = initializer.code;
            }
          }),
        );
      }

      for (final method in node.methods) {
        builder.methods.add(method);
      }

      if (node.leaf && node.visitable) {
        builder.methods.add(
          _acceptMethod(node: node),
        );
      }

      if (node.visitable && !builder.methods.build().any((Method method) => method.name == 'visitChildren')) {
        builder.methods.add(
          _visitChildrenMethod(node: node),
        );
      }

      builder.methods.add(
        _toStringMethod(node: node),
      );
    });
  }

  Method _acceptMethod({required TreeNode node}) {
    return Method((builder) {
      builder.annotations.add(refer('override'));
      builder.returns = refer('R?');
      builder.name = 'accept';
      builder.types.add(refer('R'));

      builder.requiredParameters.add(
        Parameter((builder) {
          builder.type = _referWithR('${node.root.name}Visitor');
          builder.name = 'visitor';
        }),
      );

      builder.lambda = true;
      builder.body = refer('visitor') //
          .property('visit${node.name}')
          .call([refer('this')]) //
          .code;
    });
  }

  Method _visitChildrenMethod({required TreeNode node}) {
    return Method((builder) {
      builder.annotations.add(refer('override'));
      builder.returns = refer('void');
      builder.name = 'visitChildren';
      builder.types.add(refer('R'));

      builder.requiredParameters.add(
        Parameter((builder) {
          builder.type = _referWithR('${node.root.name}Visitor');
          builder.name = 'visitor';
        }),
      );

      builder.body = Block((builder) {
        for (final property in node.properties) {
          if (property.iterable && property.visitable) {
            final block = Block.of([
              if (property.optional) Code('if (${property.name} case final ${property.name}Nodes?) {'),
              Code('for (final node in ${property.optional ? '${property.name}Nodes' : property.name}) {'),
              refer('node').property('visitChildren').call([refer('visitor')]).statement,
              Code('}'),
              if (property.optional) Code('}'),
            ]);

            builder.statements.add(block);
          } else if (property.visitable) {
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

  Method _toStringMethod({required TreeNode node}) {
    return Method((builder) {
      builder.annotations.add(refer('override'));
      builder.returns = refer('String');
      builder.name = 'toString';

      final fieldsDescription = StringBuffer();

      if (node.getAllProperties() case List<Property>(isEmpty: false) && final properties) {
        // final fields = _fields.build();
        fieldsDescription.write('(');

        for (int i = 0; i < properties.length; i = i + 1) {
          fieldsDescription.write(properties[i].name);
          fieldsDescription.write(r': $');
          fieldsDescription.write(properties[i].name);

          if (i < properties.length - 1) {
            fieldsDescription.write(', ');
          }
        }

        fieldsDescription.write(')');
      }

      final string = '${node.name}$fieldsDescription';
      builder.body = literalString(string).code;
    });
  }

  Class _visitorFromNode({required TreeNode node}) {
    return Class((builder) {
      builder.name = '${node.name}Visitor';
      builder.abstract = true;
      builder.modifier = ClassModifier.interface;
      builder.types.add(refer('R'));

      node.descent((child) {
        if (child.leaf && child.visitable) {
          final method = Method((builder) {
            builder.returns = refer('R?');
            builder.name = 'visit${child.name}';
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = refer(child.name);
                builder.name = 'node';
              }),
            );
          });

          builder.methods.add(method);
        }
      });
    });
  }

  Class _simpleVisitorFromNode({required TreeNode node}) {
    return Class((builder) {
      builder.name = 'Simple${node.name}Visitor';
      builder.abstract = true;
      builder.modifier = ClassModifier.base;
      builder.types.add(refer('R'));
      builder.implements.add(refer('${node.name}Visitor'));

      node.descent((child) {
        if (child.leaf && child.visitable) {
          final method = Method((builder) {
            builder.annotations.add(refer('override'));
            builder.returns = refer('R?');
            builder.name = 'visit${child.name}';
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = refer(child.name);
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

  Class _generalizingVisitorFromNode({required TreeNode node}) {
    return Class((builder) {
      builder.name = 'Generalizing${node.name}Visitor';
      builder.abstract = true;
      builder.modifier = ClassModifier.base;
      builder.types.add(refer('R'));
      builder.implements.add(refer('${node.name}Visitor'));

      node.descent((child) {
        if (child.visitable) {
          final method = Method((builder) {
            if (child.leaf) {
              builder.annotations.add(refer('override'));
            }

            builder.returns = refer('R?');
            builder.name = 'visit${child.name}';
            builder.requiredParameters.add(
              Parameter((builder) {
                builder.type = refer(child.name);
                builder.name = 'node';
              }),
            );

            if (child.parent case final parent?) {
              builder.lambda = true;
              builder.body = refer('visit${parent.name}').call([refer('node')]).code;
            } else {
              builder.body = Block.of([
                refer('node').property('visitChildren').call([refer('this')]).statement,
                refer('null').returned.statement,
              ]);
            }
          });

          builder.methods.add(method);
        }
      });
    });
  }
}

TypeReference _referWithR(String symbol) {
  return TypeReference((builder) {
    builder.symbol = symbol;
    builder.types.add(refer('R'));
  });
}
