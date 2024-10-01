import 'dart:async';

import 'package:collection/collection.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';
import 'package:pinto/lexer.dart';

import 'element.dart';
import 'environment.dart';
import 'package.dart';
import 'symbols_resolver.dart';
import 'type.dart';

final class Resolver extends SimpleAstNodeVisitor<Future<Element>> {
  Resolver({
    required this.program,
    required this.symbolsResolver,
    ErrorHandler? errorHandler,
  }) : _errorHandler = errorHandler;

  final List<Declaration> program;
  final SymbolsResolver symbolsResolver;
  final ErrorHandler? _errorHandler;

  Environment _environment = Environment();

  final _unresolvedParameters = <ParameterElement, TypeVariantParameterNode>{};

  Future<ProgramElement> resolve() async {
    const core = DartSdkPackage(name: 'core');
    final programElement = ProgramElement();
    final syntheticTypeDefinitions = await _resolvePackage(core);

    final importsDeclarations = <ImportDeclaration>[];
    final importsElementsFuture = <Future<ImportElement>>[];

    // At this point, imports should be guaranteed to come before anything else.
    // This is guaranteed in the parser (maybe not the best place?).

    for (final importDeclaration in program.whereType<ImportDeclaration>()) {
      try {
        importsDeclarations.add(importDeclaration);
        importsElementsFuture.add(
          () async {
            final import = await importDeclaration.accept(this) as ImportElement;
            import.enclosingElement = programElement;
            programElement.imports.add(import);
            return import;
          }(),
        );
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    final importElements = await importsElementsFuture.wait;
    for (int i = 0; i < importElements.length; i++) {
      try {
        try {
          final element = importElements[i];

          syntheticTypeDefinitions.addAll(
            await _resolvePackage(element.package),
          );

          for (final definition in syntheticTypeDefinitions) {
            programElement.declarations.add(definition);
            definition.enclosingElement = programElement;
          }
        } on Exception {
          final declaration = importsDeclarations[i];
          throw ImportedPackageNotAvailableError(declaration.identifier);
        }
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    for (final declaration in program.whereNot((declaration) => declaration is ImportDeclaration)) {
      try {
        if (declaration is LetDeclaration) {
          final letVariableDeclaration = await declaration.accept(this) as DeclarationElement;
          letVariableDeclaration.enclosingElement = programElement;
          programElement.declarations.add(letVariableDeclaration);
        } else {
          final typeDefinition = await declaration.accept(this) as TypeDefinitionElement;
          typeDefinition.enclosingElement = programElement;
          programElement.declarations.add(typeDefinition);
        }
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    for (final MapEntry(key: parameterElement, value: node) in _unresolvedParameters.entries) {
      try {
        parameterElement.type = _resolveTypeIdentifier(node.typeIdentifier);
      } on _SymbolNotResolved {
        // TODO(mateusfccp): do better
        final type = node.typeIdentifier as IdentifiedTypeIdentifier;
        _errorHandler?.emit(
          SymbolNotInScopeError(type.identifier),
        );
      }
    }

    return programElement;
  }

  @override
  Future<Element> visitBooleanLiteral(BooleanLiteral node) async {
    return LiteralElement(
      constant: true,
      constantValue: node.literal.type == TokenType.trueKeyword ? true : false,
      type: const BooleanType(),
    );
  }

  @override
  Future<Element> visitIdentifierExpression(IdentifierExpression node) async {
    final definition = _environment.getDefinition(node.identifier.lexeme);

    if (definition == null) {
      throw SymbolNotInScopeError(node.identifier);
    }

    final constant = definition is LetVariableDeclaration && definition.body.constant;

    // TODO (mateusfccp): Deal with recursive definitions?

    return IdentifierElement(
      name: node.identifier.lexeme,
      constant: constant,
      type: definition.type,
    );
  }

  @override
  Future<Element>? visitInvocationExpression(InvocationExpression node) async {
    final identifier = await node.identifierExpression.accept(this) as IdentifierElement;
    final argument = await node.argument.accept(this) as ExpressionElement;

    final invocationElement = InvocationElement(
      identifier: identifier,
      argument: argument,
      // TODO(mateusfccp): It will be potentially constant when we have macros
      constant: false,
    );

    identifier.enclosingElement = invocationElement;
    argument.enclosingElement = invocationElement;

    if (identifier.type case final FunctionType functionType) {
      invocationElement.type = functionType.returnType;

      // Check if the argument type matches the parameter type
      return invocationElement;
    } else {
      throw NotAFunctionError(
        syntacticEntity: node.identifierExpression,
        calledType: identifier.type!,
      );
    }
  }

  @override
  Future<Element> visitImportDeclaration(ImportDeclaration node) async {
    final package = switch (node.type) {
      ImportType.dart => DartSdkPackage(name: node.identifier.lexeme.substring(1)),
      ImportType.package => ExternalPackage(name: node.identifier.lexeme),
    };

    return ImportElement(package: package);
  }

  @override
  Future<TypedElement> visitLetDeclaration(LetDeclaration node) async {
    if (_environment.getDefinition(node.identifier.lexeme) != null) {
      throw IdentifierAlreadyDefinedError(node.identifier);
    }

    final expressionElement = await node.body.accept(this) as ExpressionElement;
    final TypedElement declaration;

    if (node.parameter case final parameter?) {
      final functionType = FunctionType(returnType: expressionElement.type!);

      final element = LetFunctionDeclaration(
        name: node.identifier.lexeme,
        parameter: parameter,
        type: functionType,
        body: expressionElement,
      );

      declaration = element;
      functionType.element = element;
    } else {
      declaration = LetVariableDeclaration(
        name: node.identifier.lexeme,
        type: expressionElement.type,
        body: expressionElement,
      );
    }

    expressionElement.enclosingElement = declaration;

    _environment.defineSymbol(node.identifier.lexeme, declaration);
    _environment = _environment.fork();

    node.body.accept(this);

    _environment = _environment.enclosing!;

    return declaration;
  }

  @override
  Future<Element> visitStringLiteral(StringLiteral node) async {
    // TODO(mateusfccp): Once we have string literals with interpolation, we should only consider them const if all the internal expressions are const
    return LiteralElement(
      constant: true,
      constantValue: node.literal.lexeme.substring(1, node.literal.lexeme.length - 1),
      type: const StringType(),
    );
  }

  String _removeSeparators(String literal) => literal.replaceAll('_', '');

  @override
  Future<Element> visitIntegerLiteral(IntegerLiteral node) async {
    return LiteralElement(
      constant: true,
      constantValue: int.parse(_removeSeparators(node.literal.lexeme)),
      type: const IntegerType(),
    );
  }

  @override
  Future<Element> visitDoubleLiteral(DoubleLiteral node) async {
    return LiteralElement(
      constant: true,
      constantValue: double.parse(_removeSeparators(node.literal.lexeme)),
      type: const DoubleType(),
    );
  }

  @override
  Future<Element> visitTypeDefinition(TypeDefinition node) async {
    const source = CurrentPackage();

    final definition = TypeDefinitionElement(name: node.name.lexeme);

    final definitionType = PolymorphicType(
      name: node.name.lexeme,
      source: source,
      arguments: [
        if (node.parameters case final parameters?)
          for (final parameter in parameters) TypeParameterType(name: parameter.identifier.lexeme),
      ],
      element: definition,
    );

    definition.definedType = definitionType;

    _environment.defineSymbol(
      node.name.lexeme,
      definition,
    );
    _environment = _environment.fork();

    if (node.parameters case final parameters?) {
      for (final parameter in parameters) {
        final definedType = _environment.getDefinition(parameter.identifier.lexeme);

        if (definedType is TypeParameterType) {
          _errorHandler?.emit(
            TypeParameterAlreadyDefinedError(parameter.identifier),
          );
        } else if (definedType == null) {
          final element = TypeParameterElement(name: parameter.identifier.lexeme);
          final type = TypeParameterType(name: parameter.identifier.lexeme);

          type.element = element;
          element.definedType = type;

          _environment.defineSymbol(
            parameter.identifier.lexeme,
            element,
          );

          definition.parameters.add(element);
        }
      }
    }

    for (final statementVariant in node.variants) {
      final variant = await statementVariant.accept(this) as TypeVariantElement;
      variant.enclosingElement = definition;
      definition.variants.add(variant);
    }

    _environment = _environment.enclosing!;

    return definition;
  }

  @override
  Future<Element> visitTypeVariantNode(TypeVariantNode node) async {
    final typeVariantElement = TypeVariantElement(name: node.name.lexeme);

    for (final parameter in node.parameters) {
      final parameterElement = await parameter.accept(this) as ParameterElement;
      parameterElement.enclosingElement = typeVariantElement;
      typeVariantElement.parameters.add(parameterElement);
    }

    return typeVariantElement;
  }

  @override
  Future<Element> visitTypeVariantParameterNode(TypeVariantParameterNode node) async {
    try {
      final type = _resolveTypeIdentifier(node.typeIdentifier);
      return ParameterElement(name: node.name.lexeme)..type = type;
    } on _SymbolNotResolved {
      final parameter = ParameterElement(name: node.name.lexeme);
      _unresolvedParameters[parameter] = node;
      return parameter;
    }
  }

  @override
  Future<Element> visitUnitLiteral(UnitLiteral node) async {
    return LiteralElement(
      constant: true,
      constantValue: null,
    );
  }

  Type _resolveTypeIdentifier(TypeIdentifier typeIdentifier) {
    switch (typeIdentifier) {
      case TopTypeIdentifier():
        return const TopType();
      case BottomTypeIdentifier():
        return const BottomType();
      case ListTypeIdentifier():
        return PolymorphicType(
          name: 'List',
          source: DartSdkPackage(name: 'core'),
          arguments: [_resolveTypeIdentifier(typeIdentifier.identifier)],
        );
      case SetTypeIdentifier():
        return PolymorphicType(
          name: 'Set',
          source: DartSdkPackage(name: 'core'),
          arguments: [_resolveTypeIdentifier(typeIdentifier.identifier)],
        );
      case MapTypeIdentifier():
        return PolymorphicType(
          name: 'Map',
          source: DartSdkPackage(name: 'core'),
          arguments: [
            _resolveTypeIdentifier(typeIdentifier.key),
            _resolveTypeIdentifier(typeIdentifier.value),
          ],
        );
      case IdentifiedTypeIdentifier():
        final definition = _environment.getDefinition(typeIdentifier.identifier.lexeme);
        final Type baseType;

        if (definition == null) {
          throw _SymbolNotResolved();
        } else if (definition case TypeDefiningElement(:final definedType)) {
          baseType = definedType;
        } else if (definition case ImportedSymbolSyntheticElement(syntheticElement: final TypeDefiningElement el)) {
          baseType = el.definedType;
        } else {
          // TODO(mateusfccp): Make a proper ResolveError and throw it
          throw StateError('${typeIdentifier.identifier.lexeme} has type ${definition.runtimeType}.');
        }

        if (baseType is PolymorphicType) {
          final passedArguments = [
            if (typeIdentifier.arguments case final arguments?)
              for (final argument in arguments) _resolveTypeIdentifier(argument),
          ];

          if (passedArguments.length != baseType.arguments.length) {
            throw WrongNumberOfArgumentsError(
              syntacticEntity: typeIdentifier.identifier,
              argumentsCount: passedArguments.length,
              expectedArgumentsCount: baseType.arguments.length,
            );
          }

          return PolymorphicType(
            name: typeIdentifier.identifier.lexeme,
            source: baseType.source,
            arguments: passedArguments,
          );
        } else if (baseType is TypeParameterType || baseType is StringType) {
          return baseType;
        } else {
          throw StateError("Symbol $baseType is non-polymorphic, which shouldn't happen.");
        }

      case OptionTypeIdentifier():
        final innerType = _resolveTypeIdentifier(typeIdentifier.identifier);

        return PolymorphicType(
          name: 'Option',
          source: ExternalPackage(name: 'stdlib'),
          arguments: [innerType],
        );
    }
  }

  Future<List<ImportedSymbolSyntheticElement>> _resolvePackage(Package package) async {
    final symbols = await symbolsResolver.getSymbolsForPackage(package: package);

    for (final symbol in symbols) {
      _environment.defineSymbol(
        symbol.name,
        symbol,
      );
    }

    return symbols;
  }
}

final class _SymbolNotResolved implements Exception {}
