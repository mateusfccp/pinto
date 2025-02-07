import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:pinto/annotations.dart';
import 'package:source_gen/source_gen.dart';

Builder astBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [AstGenerator()],
    'ast',
  );
}

final _emitter = DartEmitter();

final class AstGenerator extends GeneratorForAnnotation<TreeNode> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    assert(element is ClassElement);
    final classElement = element as ClassElement;

    if (classElement.isPrivate) {
      throw InvalidGenerationSourceError(
        'The class ${classElement.name} is private. AST nodes must be public.',
        element: classElement,
      );
    }

    final mixin = Mixin(
      (builder) {
        builder.base = true;
        builder.name = element.privateName;

        // Generate fields without definitions in the main class.
        for (final field in element.fields) {
          builder.methods.add(
            Method((builder) {
              // builder.returns =
                            builder.type = MethodType.getter;
              builder.name = '_${field.name}';
              builder.body = refer('this').asA(refer(element.name)).property(field.name).code;
            }),
          );
        }

        if (element.isVisitable) {
          if (element.isLeaf) {
            builder.methods.add(
              _acceptMethod(classElement),
            );
          }

          if (!element.isRoot) {
            builder.methods.add(
              _visitChildrenMethod(classElement),
            );
          }
        }

        builder.methods.add(
          _toStringMethod(classElement),
        );
      },
    );

    return _emitter.visitMixin(mixin).toString();
  }
}

Method _acceptMethod(ClassElement element) {
  return Method((builder) {
    builder.annotations.add(refer('override'));
    builder.returns = refer('R?');
    builder.name = 'accept';
    builder.types.add(refer('R'));

    builder.requiredParameters.add(
      Parameter((builder) {
        builder.type = _referWithR('${element.root.name}Visitor');
        builder.name = 'visitor';
      }),
    );

    builder.lambda = true;
    builder.body = refer('visitor') //
        .property('visit${element.name}')
        .call([refer('this').asA(refer(element.name))]).code;
  });
}

Method _visitChildrenMethod(ClassElement element) {
  return Method((builder) {
    builder.annotations.add(refer('override'));
    builder.returns = refer('void');
    builder.name = 'visitChildren';
    builder.types.add(refer('R'));

    builder.requiredParameters.add(
      Parameter((builder) {
        builder.type = _referWithR('${element.root.name}Visitor');
        builder.name = 'visitor';
      }),
    );

    builder.body = Block((builder) {
      for (final field in element.fields) {
        if (field.type.isIterable && field.isVisitable) {
          final ts = field.enclosingElement3.library!.typeSystem;
          final isOptional = ts.isNullable(field.type);

          final block = Block.of([
            if (isOptional) Code('if (${field.name} case final ${field.name}Nodes?) {'),
            Code('for (final node in ${field.type.isNullable ? '${field.name}Nodes' : field.name}) {'),
            refer('node').property('visitChildren').call([refer('visitor')]).statement,
            Code('}'),
            if (field.type.isNullable) Code('}'),
          ]);

          builder.statements.add(block);
        } else if (field.isVisitable) {
          final name = refer('_${field.name}');
          final nameProperty = field.type.isNullable ? name.nullSafeProperty : name.property;

          builder.statements.add(
            nameProperty('accept').call([refer('visitor')]).statement,
          );
        }
      }
    });
  });
}

Method _toStringMethod(ClassElement element) {
  return Method((builder) {
    builder.annotations.add(refer('override'));
    builder.returns = refer('String');
    builder.name = 'toString';

    final string = StringBuffer(element.name);

    if (element.fields.isNotEmpty) {
      string.write('(');

      for (int i = 0; i < element.fields.length; i = i + 1) {
        string.write(element.fields[i].name);
        string.write(r': $_');
        string.write(element.fields[i].name);

        if (i < element.fields.length - 1) {
          string.write(', ');
        }
      }

      string.write(')');
    }

    builder.body = literalString(string.toString()).code;
  });
}

TypeReference _referWithR(String symbol) {
  return TypeReference((builder) {
    builder.symbol = symbol;
    builder.types.add(refer('R'));
  });
}

extension on FieldElement {
  bool get isVisitable {
    if (type.element case final InterfaceElement element) {
      return element.isVisitable;
    } else {
      return false;
    }
  }
}

extension on InterfaceElement {
  /// Whether this class is a leaf node in the AST tree.
  bool get isLeaf {
    final classesInLibrary = library.units.expand((unit) => unit.classes);

    for (final interface in classesInLibrary) {
      if (interface.allSupertypes.any((type) => type.element == this)) {
        return false;
      }
    }

    return true;
  }

  /// Whether this class is the root of AST tree.
  bool get isRoot => root == this;

  /// Whether this class is a visitable node.
  bool get isVisitable {
    final nodeAnnotation = metadata.firstWhereOrNull(
      (element) => element.element?.enclosingElement3?.name == 'TreeNode',
    );

    if (nodeAnnotation != null) {
      final computedValue = nodeAnnotation.computeConstantValue();
      final reader = ConstantReader(computedValue);
      return reader.read('visitable').boolValue;
    } else {
      return false;
    }
  }

  /// Returns the private name of the class.
  String get privateName => '_$name';

  /// Returns the root of the AST tree.
  InterfaceElement get root {
    var current = this;

    outer:
    while (true) {
      if (current.supertype case final supertype?) {
        final metadata = supertype.element.metadata;

        for (final metadatum in metadata) {
          if (metadatum.element?.enclosingElement3?.name == 'TreeNode') {
            current = supertype.element;
            continue outer;
          }
        }

        // The superclass is not annotated with `AstNode`
        break;
      } else {
        // Current is `Object`
        break;
      }
    }

    return current;
  }
}

extension on DartType {
  bool get isIterable {
    // For now this is a simple check. We may need to improve it later.
    return isDartCoreList || isDartCoreIterable || isDartCoreSet;
  }

  bool get isNullable {
    return element!.library!.typeSystem.isNullable(this);
  }
}
