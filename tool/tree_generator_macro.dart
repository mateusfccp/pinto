import 'dart:async';

import 'package:code_builder/code_builder.dart' as code_builder;
import 'package:macros/macros.dart';

macro class Tree implements LibraryTypesMacro, LibraryDefinitionMacro, ClassDeclarationsMacro {
  const Tree(this.name);

  final String name;

  String get visitorName => '${name}Visitor';

  @override
  Future<void> buildTypesForLibrary(Library library, TypeBuilder builder) async {
    builder.declareType(
      visitorName,
      DeclarationCode.fromParts([
        'abstract interface class $visitorName<R> {',
        '}',
      ]),
    );
  }

  @override
  Future<void> buildDefinitionForLibrary(Library library, LibraryDefinitionBuilder builder) async {
    final types = await builder.typesOf(library);
    final classes = types.whereType<ClassDeclaration>();
    final roots = classes.where((clazz) => clazz.isRoot);

    final c = await builder.resolveIdentifier(library.uri, visitorName);
    final cb = await builder.buildType(c);
    final ms = await cb.methodsOf(c);
    for (final m in ms) {
      final mb = await cb.buildMethod(m.identifier);
      // mb.augment(body)
    }

    if (roots.isEmpty) {
      return builder.report(
          Diagnostic(
            DiagnosticMessage('A tree structure should have a root.'),
            Severity.error,
          ),
        );
    } else if (roots.length > 1) {
      for (final root in roots.skip(1)) {
        return builder.report(
          Diagnostic(
            DiagnosticMessage(
              'A tree structure should have a single root. ${roots.first.identifier.name} is already the root of this tree.',
              target: root.asDiagnosticTarget,
            ),
            Severity.error,
          ),
        );
      }
    }

    final leaves = {
      for (final clazz in classes) 
        if(clazz.identifier.name != visitorName) 
          clazz.identifier.name:  clazz,
    };

    for (final clazz in classes) {
      if (clazz.superclass case final superclass?) {
        leaves.remove(superclass.identifier.name);
      }

      if (clazz == roots.single) {
        leaves.remove(clazz.identifier.name);
      }
    }

    builder.report(
      Diagnostic(
        DiagnosticMessage('Leaves: ${leaves.values.map((e) => e.identifier.name)}'),
        Severity.info,
      ),
    );

    for (final leaf in leaves.values) {
         final method = code_builder.Method((builder) {
            builder.returns = code_builder.refer('R?');
            builder.name = 'visit${leaf.identifier.name}';
            builder.requiredParameters.add(
              code_builder.Parameter((builder) {
                builder.type = code_builder.refer(leaf.identifier.name);
                builder.name = 'node';
              }),
            );
          });

          final typeBuilder = await builder.buildType(leaf.identifier);
          final methods = await typeBuilder.methodsOf(leaf);

          // typeBuilder.augment();
          // typeBuilder.buildMethod('identifier');
    }
  }

  @override
  Future<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder declarationBuilder) async {
    // final root = await declarationBuilder.typesOf(clazz.library);

    //     @override
    // R? accept<R>(AstNodeVisitor<R> visitor) =>
    //     visitor.visitTopTypeIdentifier(this);

    // @override
    // void visitChildren<R>(AstNodeVisitor<R> visitor) {}

    final fields = await declarationBuilder.fieldsOf(clazz);

    final method = code_builder.Method((builder) {
      builder.annotations.add(code_builder.refer('override'));
      builder.returns = code_builder.refer('void');
      builder.name = 'visitChildren';
      builder.types.add(code_builder.refer('R'));

      builder.requiredParameters.add(
        code_builder.Parameter((builder) {
          builder.type = _referWithR(visitorName);
          builder.name = 'visitor';
        }),
      );

      builder.body = code_builder.Block((builder) async {
        for (final field in fields) {
          // final visitable = false;
          // if (visitable) {
          //   final name = code_builder.refer(field.identifier.name);
          //   final nameProperty = field.type.isNullable ? name.nullSafeProperty : name.property;

          //   builder.statements.add(
          //     nameProperty('accept').call([code_builder.refer('visitor')]).statement,
          //   );
          // }
          // if (property.iterable && property.visitable) {
          //   final block = Block.of([
          //     if (property.optional) Code('if (${property.name} case final ${property.name}Nodes?) {'),
          //     Code('for (final node in ${property.optional ? '${property.name}Nodes' : property.name}) {'),
          //     refer('node').property('visitChildren').call([refer('visitor')]).statement,
          //     Code('}'),
          //     if (property.optional) Code('}'),
          //   ]);

          //   builder.statements.add(block);
          // } else if (property.visitable) {

          // }
        }
      });
    });

    final str = method.accept(code_builder.DartEmitter()).toString();
    declarationBuilder.declareInType(DeclarationCode.fromString(str));
  }
}

const root = Root();

final class Root {
  const Root();
}

code_builder.TypeReference _referWithR(String symbol) {
  return code_builder.TypeReference((builder) {
    builder.symbol = symbol;
    builder.types.add(code_builder.refer('R'));
  });
}

extension on Annotatable {
  bool get isRoot {
    for (final metadatum in metadata) {
      if ((metadatum is IdentifierMetadataAnnotation && metadatum.identifier.name == 'root') ||
          (metadatum is ConstructorMetadataAnnotation && metadatum.type.identifier.name == 'Root')) { 
        return true;
      }
    }

    return false;
  }
}

extension on FieldDeclaration {
  Future<bool> visitable(Identifier rootIdentifier, DeclarationPhaseIntrospector inspector) async {
    final rooty = NamedTypeAnnotationCode(name: rootIdentifier);

    final _ = await inspector.resolve(type.code);
    final __ = await inspector.resolve(rooty.code);

    return await _.isSubtypeOf(__);
  }
  // bool get visitable {
  //   for (final metadatum in metadata) {
  //     if (metadatum is IdentifierMetadataAnnotation) {
  //       if (metadatum.identifier)
  //     }
  //   }
  // }
}