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

final class Resolver implements AstVisitor<Future<Element>> {
  Resolver({
    required this.program,
    required this.symbolsResolver,
    ErrorHandler? errorHandler,
  }) : _errorHandler = errorHandler;

  final ProgramAst program;
  final SymbolsResolver symbolsResolver;
  final ErrorHandler? _errorHandler;

  Environment _environment = Environment();

  final _unresolvedParameters = <ParameterElement, TypeVariantParameterNode>{};

  Future<ProgramElement> resolve() async => await program.accept(this) as ProgramElement;

  @override
  Future<Element> visitFunctionStatement(FunctionStatement statement) {
    throw UnimplementedError();
  }

  @override
  Future<Element> visitImportStatement(ImportStatement statement) async {
    final package = switch (statement.type) {
      ImportType.dart => DartSdkPackage(name: statement.identifier.lexeme.substring(1)),
      ImportType.package => ExternalPackage(name: statement.identifier.lexeme),
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
  Future<Element> visitProgram(ProgramAst ast) async {
    const core = DartSdkPackage(name: 'core');

    final program = ProgramElement();

    await Future.wait([
      _resolvePackage(core),
      // todo(mateusfccp): Check if order matters
      for (final importStatement in ast.imports)
        () async {
          final import = await importStatement.accept(this) as ImportElement;
          import.enclosingElement = program;
          program.imports.add(import);
        }(),
    ]);

    for (final statement in ast.body) {
      try {
        final typeDefinition = await statement.accept(this) as TypeDefinitionElement;
        typeDefinition.enclosingElement = program;
        program.typeDefinitions.add(typeDefinition);
      } on ResolveError catch (error) {
        _errorHandler?.emit(error);
      }
    }

    for (final MapEntry(key: parameterElement, value: node) in _unresolvedParameters.entries) {
      try {
        parameterElement.type = _resolveType(node.type);
      } on _SymbolNotResolved {
        // TODO(mateusfccp): do better
        final type = node.type as IdentifiedTypeLiteral;
        _errorHandler?.emit(
          SymbolNotInScopeError(type.identifier),
        );
      }
    }

    return program;
  }

  @override
  Future<Element> visitTypeDefinitionStatement(TypeDefinitionStatement statement) async {
    const source = CurrentPackage();

    final definition = TypeDefinitionElement(name: statement.name.lexeme);

    final definitionType = PolymorphicType(
      name: statement.name.lexeme,
      source: source,
      arguments: [
        if (statement.parameters case final parameters?)
          for (final parameter in parameters) TypeParameterType(name: parameter.identifier.lexeme),
      ],
    )..element = definition;

    final environment = _environment;
    _environment.defineType(definitionType);
    _environment = _environment.fork();

    if (statement.parameters case final parameters?) {
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

    for (final statementVariant in statement.variants) {
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

  PintoType _resolveType(TypeLiteral literal) {
    switch (literal) {
      case TopTypeLiteral():
        return const TopType();
      case BottomTypeLiteral():
        return const BottomType();
      case ListTypeLiteral():
        return PolymorphicType(
          name: 'List',
          source: DartSdkPackage(name: 'core'),
          arguments: [_resolveType(literal.literal)],
        );
      case SetTypeLiteral():
        return PolymorphicType(
          name: 'Set',
          source: DartSdkPackage(name: 'core'),
          arguments: [_resolveType(literal.literal)],
        );
      case MapTypeLiteral():
        return PolymorphicType(
          name: 'Map',
          source: DartSdkPackage(name: 'core'),
          arguments: [
            _resolveType(literal.keyLiteral),
            _resolveType(literal.valueLiteral),
          ],
        );
      case IdentifiedTypeLiteral literal:
        final baseType = _environment.getType(literal.identifier.lexeme);

        if (baseType == null) {
          throw _SymbolNotResolved();
        } else if (baseType is PolymorphicType) {
          final passedArguments = [
            if (literal.arguments case final arguments?)
              for (final argument in arguments) _resolveType(argument),
          ];

          if (passedArguments.length != baseType.arguments.length) {
            throw WrongNumberOfArgumentsError(
              token: literal.identifier,
              argumentsCount: passedArguments.length,
              expectedArgumentsCount: baseType.arguments.length,
            );
          }

          return PolymorphicType(
            name: literal.identifier.lexeme,
            source: baseType.source,
            arguments: passedArguments,
          );
        } else if (baseType is TypeParameterType) {
          return baseType;
        } else {
          // State error
          throw "Symbol $baseType is non-polymorphic, which shouldn't happen.";
        }

      case OptionTypeLiteral literal:
        final innerType = _resolveType(literal.literal);

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
