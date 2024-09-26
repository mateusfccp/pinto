import 'dart:async';

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

    final imports = <Future<ImportElement>>[];

    // At this point, imports should be guaranteed to come before anything else.
    // This is guaranteed in the parser (maybe not the best place?).

    for (final declaration in program) {
      try {
        if (declaration is ImportDeclaration) {
          imports.add(
            () async {
              final import = await declaration.accept(this) as ImportElement;
              import.enclosingElement = programElement;
              programElement.imports.add(import);
              return import;
            }(),
          );
        } else if (declaration is LetDeclaration) {
          await imports.wait;

          final letVariableDeclaration = await declaration.accept(this) as DeclarationElement;
          letVariableDeclaration.enclosingElement = programElement;
          programElement.declarations.add(letVariableDeclaration);
        } else {
          await imports.wait;

          final typeDefinition = await declaration.accept(this) as TypeDefinitionElement;
          typeDefinition.enclosingElement = programElement;
          programElement.declarations.add(typeDefinition);
        }
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    for (final import in await imports.wait) {
      try {
        syntheticTypeDefinitions.addAll(await _resolvePackage(import.package));
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    for (final definition in syntheticTypeDefinitions) {
      programElement.declarations.add(definition);
      definition.enclosingElement = programElement;
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
    );
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

    final type = _resolveStaticTypeForExpression(node.body);
    final expressionElement = await node.body.accept(this);
    final TypedElement declaration;

    if (node.parameter case final parameter?) {
      final functionType = FunctionType(returnType: type);

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
        type: type,
        body: expressionElement,
      );
    }

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
        } else if (definition case TypeDefiningDeclaration(:final definedType)) {
          baseType = definedType;
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
        } else if (baseType is TypeParameterType) {
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

    final elements = <ImportedSymbolSyntheticElement>[];

    for (final symbol in symbols) {
      if (symbol is PolymorphicType) {
        final element = ImportedSymbolSyntheticElement(
          name: symbol.name,
          type: TypeType(), // TODO(mateusfccp): Change this when we import other symbols
        );

        element.definedType = symbol;
        symbol.element = element;

        _environment.defineSymbol(
          symbol.name,
          element,
        );

        elements.add(element);
      }
    }

    return elements;
  }

  Type _resolveStaticTypeForExpression(Expression expression) {
    return switch (expression) {
      BooleanLiteral() => BooleanType(),
      IdentifierExpression(:final identifier) => _environment.getDefinition(identifier.lexeme)?.type ?? (throw "Identifier of type is unresolved. This shouldn't ever happen."),
      LetExpression() => throw UnimplementedError(), // TODO(mateusfccp): We will probably need the semantic element for dealing with let environments
      StringLiteral() => StringType(),
      UnitLiteral() => UnitType(),
    };
  }
}

final class _SymbolNotResolved implements Exception {}
