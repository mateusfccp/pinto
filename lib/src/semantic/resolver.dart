import 'dart:async';

import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';

import 'element.dart';
import 'environment.dart';
import 'import.dart';
import 'package.dart';
import 'program.dart';
import 'symbols_resolver.dart';
import 'type.dart';
import 'type_definition.dart';

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

    await _resolvePackage(core);

    final imports = <Future<void>>[];

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
            }(),
          );
        } else {
          await imports.wait;

          final typeDefinition = await declaration.accept(this) as TypeDefinitionElement;
          typeDefinition.enclosingElement = programElement;
          programElement.typeDefinitions.add(typeDefinition);
        }
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    for (final MapEntry(key: parameterElement, value: node) in _unresolvedParameters.entries) {
      try {
        parameterElement.type = _resolveType(node.type);
      } on _SymbolNotResolved {
        // TODO(mateusfccp): do better
        final type = node.type as IdentifiedTypeIdentifier;
        _errorHandler?.emit(
          SymbolNotInScopeError(type.identifier),
        );
      }
    }

    return programElement;
  }

  @override
  Future<Element> visitFunctionDeclaration(FunctionDeclaration node) {
    throw UnimplementedError();
  }

  @override
  Future<Element> visitImportDeclaration(ImportDeclaration node) async {
    final package = switch (node.type) {
      ImportType.dart => DartSdkPackage(name: node.identifier.lexeme.substring(1)),
      ImportType.package => ExternalPackage(name: node.identifier.lexeme),
    };

    try {
      final symbols = await symbolsResolver.getSymbolForPackage(package: package);

      for (final symbol in symbols) {
        _environment.defineType(symbol);
      }
    } on ResolveError catch (error) {
      _errorHandler?.emit(error);
    }

    return ImportElement(package: package);
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
    )..element = definition;

    final environment = _environment;
    _environment.defineType(definitionType);
    _environment = _environment.fork();

    if (node.parameters case final parameters?) {
      for (final parameter in parameters) {
        final definedType = _environment.getType(parameter.identifier.lexeme);

        if (definedType is TypeParameterType) {
          _errorHandler?.emit(
            TypeParameterAlreadyDefinedError(parameter.identifier),
          );
        } else if (definedType == null) {
          final type = TypeParameterType(name: parameter.identifier.lexeme);
          _environment.defineType(type);
          definition.parameters.add(type);
        }
      }
    }

    for (final statementVariant in node.variants) {
      final variant = await statementVariant.accept(this) as TypeVariantElement;
      variant.enclosingElement = definition;
      definition.variants.add(variant);
    }

    _environment = environment;

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
      final type = _resolveType(node.type);
      return ParameterElement(
        type: type,
        name: node.name.lexeme,
      );
    } on _SymbolNotResolved {
      final parameter = ParameterElement(
        type: null,
        name: node.name.lexeme,
      );
      _unresolvedParameters[parameter] = node;
      return parameter;
    }
  }

  PintoType _resolveType(TypeIdentifier typeIdentifier) {
    switch (typeIdentifier) {
      case TopTypeIdentifier():
        return const TopType();
      case BottomTypeIdentifier():
        return const BottomType();
      case ListTypeIdentifier():
        return PolymorphicType(
          name: 'List',
          source: DartSdkPackage(name: 'core'),
          arguments: [_resolveType(typeIdentifier.identifier)],
        );
      case SetTypeIdentifier():
        return PolymorphicType(
          name: 'Set',
          source: DartSdkPackage(name: 'core'),
          arguments: [_resolveType(typeIdentifier.identifier)],
        );
      case MapTypeIdentifier():
        return PolymorphicType(
          name: 'Map',
          source: DartSdkPackage(name: 'core'),
          arguments: [
            _resolveType(typeIdentifier.key),
            _resolveType(typeIdentifier.value),
          ],
        );
      case IdentifiedTypeIdentifier():
        final baseType = _environment.getType(typeIdentifier.identifier.lexeme);

        if (baseType == null) {
          throw _SymbolNotResolved();
        } else if (baseType is PolymorphicType) {
          final passedArguments = [
            if (typeIdentifier.arguments case final arguments?)
              for (final argument in arguments) _resolveType(argument),
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
          // State error
          throw "Symbol $baseType is non-polymorphic, which shouldn't happen.";
        }

      case OptionTypeIdentifier():
        final innerType = _resolveType(typeIdentifier.identifier);

        return PolymorphicType(
          name: 'Option',
          source: ExternalPackage(name: 'stdlib'),
          arguments: [innerType],
        );
    }
  }

  Future<void> _resolvePackage(Package package) async {
    final symbols = await symbolsResolver.getSymbolForPackage(package: package);

    for (final symbol in symbols) {
      _environment.defineType(symbol);
    }
  }
}

final class _SymbolNotResolved implements Exception {}
