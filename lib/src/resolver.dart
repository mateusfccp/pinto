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
    annotations[typeLiteral] = _resolveType(typeLiteral);
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

    _environment = _environment.fork();

    if (statement.typeParameters case final typeParameters?) {
      for (final typeParameter in typeParameters) {
        final type = Type(
          name: typeParameter.identifier.lexeme,
          package: 'LOCAL',
          parameters: [], // TODO(mateusfccp): Refactor local type resolution
        );

        _environment.defineType(type);
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
    final Type? resolvedType;

    switch (literal) {
      case TopTypeLiteral():
        resolvedType = Type(
          name: 'Object?',
          package: 'dart:core',
          parameters: [],
        ); // TODO(mateusfccp): will nullable work?
      case BottomTypeLiteral():
        resolvedType = Type(
          name: 'Never',
          package: 'dart:core',
          parameters: [],
        );
      case ListTypeLiteral():
        resolvedType = Type(
          name: 'List',
          package: 'dart:core',
          parameters: [_resolveType(literal.literal)],
        );
      case SetTypeLiteral():
        resolvedType = Type(
          name: 'Set',
          package: 'dart:core',
          parameters: [_resolveType(literal.literal)],
        );
      case MapTypeLiteral():
        resolvedType = Type(
          name: 'Map',
          package: 'dart:core',
          parameters: [
            _resolveType(literal.keyLiteral),
            _resolveType(literal.valueLiteral),
          ],
        );
      case ParameterizedTypeLiteral literal:
        final baseLiteral = _resolveType(literal.literal);

        resolvedType = Type(
          name: baseLiteral.name,
          package: baseLiteral.package,
          parameters: [
            for (final parameter in literal.parameters) _resolveType(parameter),
          ],
        );
      case NamedTypeLiteral literal:
        resolvedType = _environment.getType(literal.identifier.lexeme);
      case OptionTypeLiteral literal:
        final innerType = _resolveType(literal.literal);
        resolvedType = Type(
          name: '${innerType.name}?',
          package: innerType.package,
          parameters: [],
        );
    }

    if (resolvedType == null) {
      throw 'Resolve error with type';
      // final error = NoSymbolInScopeError(literal); // TODO(mateusfccp): use proper error
      // _errorHandler?.emit(error);

      // throw error; // TODO(mateusfccp): Should we have a synchronization here too?
    } else {
      return resolvedType;
    }
  }
}
