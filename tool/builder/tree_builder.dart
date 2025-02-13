import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:pinto/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'common.dart';

Builder treeBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [TreeGenerator()],
    'tree',
  );
}

final _emitter = DartEmitter();

final class TreeGenerator extends GeneratorForAnnotation<TreeNode> {
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
        'The class ${classElement.name} is private. Tree nodes must be public.',
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
              builder.returns = refer(field.type.toString());
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
    builder.returns = refer('R?');
    builder.name = 'accept';
    builder.types.add(refer('R'));

    builder.requiredParameters.add(
      Parameter((builder) {
        builder.type = referWithR('${element.root.name}Visitor');
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
    builder.returns = refer('void');
    builder.name = 'visitChildren';
    builder.types.add(refer('R'));

    builder.requiredParameters.add(
      Parameter((builder) {
        builder.type = referWithR('${element.root.name}Visitor');
        builder.name = 'visitor';
      }),
    );

    builder.body = Block((builder) {
      for (final field in element.fields) {
        final typeSystem = field.enclosingElement3.library!.typeSystem;
        final isNullable = typeSystem.isNullable(field.type);

        if (field.isIterableOfVisitable) {
          final block = Block.of([
            if (isNullable) Code('if (_${field.name} case final nodes?) {'),
            Code('for (final node in ${isNullable ? 'nodes' : '_${field.name}'}) {'),
            if (field.isIterableOfNullable) //
              refer('node').nullSafeProperty('visitChildren').call([refer('visitor')]).statement
            else
              refer('node').property('visitChildren').call([refer('visitor')]).statement,
            Code('}'),
            if (isNullable) Code('}'),
          ]);

          builder.statements.add(block);
        } else if (field.isVisitable) {
          final name = refer('_${field.name}');
          final nameProperty = isNullable ? name.nullSafeProperty : name.property;

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
