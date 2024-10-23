import 'dart:async';

import 'package:code_builder/code_builder.dart' as code_builder;
import 'package:collection/collection.dart';
import 'package:macros/macros.dart';

macro class Tree implements LibraryTypesMacro, LibraryDefinitionMacro, ClassDeclarationsMacro, ClassDefinitionMacro {
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

    // final leaves = {
    //   for (final clazz in classes) 
    //     if(clazz.identifier.name != visitorName) 
    //       clazz.identifier.name:  clazz,
    // };

    // for (final clazz in classes) {
    //   if (clazz.superclass case final superclass?) {
    //     leaves.remove(superclass.identifier.name);
    //   }

    //   if (clazz == roots.single) {
    //     leaves.remove(clazz.identifier.name);
    //   }
    // }

    // builder.report(
    //   Diagnostic(
    //     DiagnosticMessage('Leaves: ${leaves.values.map((e) => e.identifier.name)}'),
    //     Severity.info,
    //   ),
    // );

    // for (final leaf in leaves.values) {
    //      final method = code_builder.Method((builder) {
    //         builder.returns = code_builder.refer('R?');
    //         builder.name = 'visit${leaf.identifier.name}';
    //         builder.requiredParameters.add(
    //           code_builder.Parameter((builder) {
    //             builder.type = code_builder.refer(leaf.identifier.name);
    //             builder.name = 'node';
    //           }),
    //         );
    //       });

    //       final typeBuilder = await builder.buildType(leaf.identifier);
    //       final methods = await typeBuilder.methodsOf(leaf);

    //       // typeBuilder.augment();
    //       // typeBuilder.buildMethod('identifier');
    // }
  }

  @override
  Future<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder declarationBuilder) async {
    // final root = await clazz.library.getRoot(declarationBuilder);

    final visitChildrenMethod = code_builder.Method((builder) {
      if (!clazz.isRoot) {
        builder.annotations.add(code_builder.refer('override'));
      }
      
      builder.returns = code_builder.refer('void');
      builder.name = 'visitChildren';
      builder.types.add(code_builder.refer('R'));

      builder.requiredParameters.add(
        code_builder.Parameter((builder) {
          builder.type = _referWithR(visitorName);
          builder.name = 'visitor';
        }),
      );
    });

    final visitChildrenMethodString = visitChildrenMethod.accept(code_builder.DartEmitter()).toString();
    declarationBuilder.declareInType(DeclarationCode.fromString(visitChildrenMethodString));

    final acceptMethod = code_builder.Method((builder) {
      if (!clazz.isRoot) {
        builder.annotations.add(code_builder.refer('override'));
      }
      
      builder.returns = code_builder.refer('R?');
      builder.name = 'accept';
      builder.types.add(code_builder.refer('R'));

      builder.requiredParameters.add(
        code_builder.Parameter((builder) {
          builder.type = _referWithR(visitorName);
          builder.name = 'visitor';
        }),
      );

      builder.lambda = true;

      builder.body = code_builder //
        .refer('visitor')
        .property('visit${clazz.identifier.name}')
        .call([code_builder.refer('this')])
        .statement;
    });

    final acceptMethodString = acceptMethod.accept(code_builder.DartEmitter()).toString();
    declarationBuilder.declareInType(DeclarationCode.fromString(acceptMethodString));
  }
  
  @override
  FutureOr<void> buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    final methods = await builder.methodsOf(clazz);

    final visitChildrenMethod = methods.singleWhereOrNull((method) => method.identifier.name == 'visitChildren');

    if (visitChildrenMethod != null) {
      final methodBuilder = await builder.buildMethod(visitChildrenMethod.identifier);
      await VisitChildrenBuilder().buildDefinitionForMethod(visitChildrenMethod, methodBuilder);
    }
  }
}

final class VisitChildrenBuilder implements MethodDefinitionMacro {
  @override
  FutureOr<void> buildDefinitionForMethod(MethodDeclaration method, FunctionDefinitionBuilder builder) async {
    final root = await method.library.getRoot(builder);
    final clazz = await builder.typeDeclarationOf(method.definingType);
    final fields = await builder.fieldsOf(clazz);

      final statements = <code_builder.Code>[];
      
      for (final field in fields) {
        final visitable = await field.visitable(root.identifier, builder);

        if (visitable) {
          final name = code_builder.refer(field.identifier.name);
          final nameProperty = field.type.isNullable ? name.nullSafeProperty : name.property;

          statements.add(
            nameProperty('accept').call([code_builder.refer('visitor')]).statement, 
          );
        }
      }

      final body = code_builder.Block.of(statements);
      final bodyString = body.accept(code_builder.DartEmitter()).toString();
      builder.augment(
        FunctionBodyCode.fromParts([
          '{',
          bodyString,
          '}',
        ]),
      );
  }
}

final class AcceptMethodBuilder implements MethodDefinitionMacro {
  const AcceptMethodBuilder(this.visitorName);

  final String visitorName;

  @override
  FutureOr<void> buildDefinitionForMethod(MethodDeclaration method, FunctionDefinitionBuilder builder) async {
    final clazz = await builder.typeDeclarationOf(method.definingType);

      final statements = <code_builder.Code>[];
      statements.add(
        code_builder.refer('visitor').call([code_builder.refer('visit${clazz.identifier.name}')]).statement, 
      );

      final body = code_builder.Block.of(statements);
      final bodyString = body.accept(code_builder.DartEmitter()).toString();
      builder.augment(
        FunctionBodyCode.fromParts([
          '{',
          bodyString,
          '}',
        ]),
      );
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

extension on Library {
  Future<TypeDeclaration> getRoot(DeclarationPhaseIntrospector introspector) async {
    final types = await introspector.typesOf(this);
    return types.singleWhere((type) => type.isRoot);
  }
}

extension on FieldDeclaration {
  Future<bool> visitable(Identifier rootIdentifier, DeclarationPhaseIntrospector inspector) async {
    final rooty = NamedTypeAnnotationCode(name: rootIdentifier);

    final a = await inspector.resolve(type.code);
    final b = await inspector.resolve(rooty.code);

    return await a.isSubtypeOf(b);
  }
  // bool get visitable {
  //   for (final metadatum in metadata) {
  //     if (metadatum is IdentifierMetadataAnnotation) {
  //       if (metadatum.identifier)
  //     }
  //   }
  // }
}