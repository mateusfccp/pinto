import 'package:pint/src/ast/default_type_literal_visitor.dart';

import 'ast/ast.dart';

import 'ast/node.dart';
import 'ast/program.dart';
import 'ast/statement.dart';
import 'ast/type_literal.dart';
import 'environment.dart';
import 'error.dart';
import 'import.dart';
import 'symbols_resolver.dart';
import 'type.dart';

final class Resolver with DefaultTypeLiteralVisitor<Future<void>> implements AstVisitor<Future<void>> {
  Resolver({
    required this.program,
    required this.symbolsResolver,
    ErrorHandler? errorHandler,
  }) : _errorHandler = errorHandler;

  final Program program;
  final SymbolsResolver symbolsResolver;
  final ErrorHandler? _errorHandler;

  Environment _environment = Environment();
  final annotations = <TypeLiteral, Type>{};

  Future<void> resolve() async {
    await program.accept(this);
  }

  @override
  Future<void> visitTypeLiteral(TypeLiteral typeLiteral) async {
    try {
      annotations[typeLiteral] = _resolveType(typeLiteral);
    } on ResolveError catch (error) {
      _errorHandler?.emit(error);
    }
  }

  @override
  Future<void> visitImportStatement(ImportStatement statement) async {
    final symbols = await symbolsResolver.getSymbolsFor(statement: statement);

    for (final symbol in symbols) {
      _environment.defineType(symbol);
    }
  }

  @override
  Future<void> visitProgram(Program program) async {
    // TODO(mateusfccp): maybe find a better place for this
    final core = ImportStatement(ImportType.dart, 'core');
    await core.accept(this);

    await Future.wait([
      for (final import in program.imports) import.accept(this),
    ]);

    for (final statement in program.body) {
      await statement.accept(this);
    }
  }

  @override
  Future<void> visitTypeDefinitionStatement(TypeDefinitionStatement statement) async {
    final environment = _environment;

    final source = Package(name: 'LOCAL');

    final definitionType = switch (statement.typeParameters) {
      null || [] => MonomorphicType(
          name: statement.name.lexeme,
          source: source,
        ),
      final elements => PolymorphicType(
          name: statement.name.lexeme,
          source: source,
          arguments: [
            for (final element in elements) TypeParameterType(name: element.identifier.lexeme),
          ],
        ),
    };

    _environment.defineType(definitionType);

    _environment = _environment.fork();

    if (statement.typeParameters case final typeParameters?) {
      for (final typeParameter in typeParameters) {
        final definedType = _environment.getType(typeParameter.identifier.lexeme);

        if (definedType is TypeParameterType) {
          _errorHandler?.emit(
            TypeAlreadyDefinedError(typeParameter.identifier),
          );
        } else {
          final type = TypeParameterType(name: typeParameter.identifier.lexeme);

          _environment.defineType(type);
        }

        typeParameter.accept(this);
      }
    }

    for (final variant in statement.variants) {
      await variant.accept(this);
    }

    _environment = environment;
  }

  @override
  Future<void> visitTypeVariantNode(TypeVariantNode node) async {
    for (final parameter in node.parameters) {
      await parameter.accept(this);
    }
  }

  @override
  Future<void> visitTypeVariantParameterNode(TypeVariantParameterNode node) async {
    await node.type.accept(this);
  }

  Type _resolveType(TypeLiteral literal) {
    switch (literal) {
      case TopTypeLiteral():
        return const TopType();
      case BottomTypeLiteral():
        return const BottomType();
      case ListTypeLiteral():
        return PolymorphicType(
          name: 'List',
          source: DartCore(name: 'core'),
          arguments: [_resolveType(literal.literal)],
        );
      case SetTypeLiteral():
        return PolymorphicType(
          name: 'Set',
          source: DartCore(name: 'core'),
          arguments: [_resolveType(literal.literal)],
        );
      case MapTypeLiteral():
        return PolymorphicType(
          name: 'Map',
          source: DartCore(name: 'core'),
          arguments: [
            _resolveType(literal.keyLiteral),
            _resolveType(literal.valueLiteral),
          ],
        );
      case ParameterizedTypeLiteral literal:
        final baseType = _environment.getType(literal.literal.identifier.lexeme);

        if (baseType == null) {
          throw NoSymbolInScopeError(literal.literal.identifier);
        } else if (baseType is PolymorphicType) {
          final arguments = [
            for (final parameter in literal.parameters) _resolveType(parameter),
          ];

          if (arguments.length != baseType.arguments.length) {
            throw WrongNumberOfArgumentsError(
              token: literal.literal.identifier,
              argumentsCount: arguments.length,
              expectedArgumentsCount: baseType.arguments.length,
            );
          }

          return PolymorphicType(
            name: baseType.name,
            source: baseType.source,
            arguments: arguments,
          );
        } else {
          throw WrongNumberOfArgumentsError(
            token: literal.literal.identifier,
            argumentsCount: literal.parameters.length,
            expectedArgumentsCount: 0,
          );
        }
      case NamedTypeLiteral literal:
        final type = _environment.getType(literal.identifier.lexeme);

        if (type == null) {
          throw NoSymbolInScopeError(literal.identifier);
        } else if (type is PolymorphicType) {
          throw WrongNumberOfArgumentsError(
            token: literal.identifier,
            argumentsCount: 0,
            expectedArgumentsCount: type.arguments.length,
          );
        } else {
          return type;
        }
      case OptionTypeLiteral literal:
        final innerType = _resolveType(literal.literal);

        return PolymorphicType(
          // TODO(mateusfccp): fix this
          name: '?',
          source: DartCore(name: 'core'),
          arguments: [innerType],
        );
    }
  }
}
