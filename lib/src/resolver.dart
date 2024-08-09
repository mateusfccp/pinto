import 'environment.dart';
import 'error.dart';
import 'node.dart';
import 'statement.dart';

final class Resolver implements NodeVisitor<void>, StatementVisitor<void> {
  Resolver({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  final ErrorHandler? _errorHandler;
  Environment _environment = Environment.root();

  @override
  void visitImportStatement(ImportStatement statement) {
    // TODO: implement visitImportStatement
  }

  @override
  void visitTypeDefinitionStatement(TypeDefinitionStatement statement) {
    final environment = _environment;

    _environment = _environment.fork();

    if (statement.typeParameters case final typeParameters?) {
      for (final typeParameter in typeParameters) {
        _environment.defineSymbol(typeParameter.lexeme);
      }
    }

    for (final variant in statement.variants) {
        variant.accept(this);
    }

    _environment = environment;
  }

  @override
  void visitTypeVariationNode(TypeVariationNode node) {
    for (final parameter in node.parameters) {
      parameter.accept(this);
    }
  }

  @override
  void visitTypeVariationParameterNode(TypeVariationParameterNode node) {
    if (!_environment.hasSymbol(node.type.lexeme)) {
      _errorHandler?.emit(
        NoSymbolInScopeError(node.type), // TODO(mateusfccp): use proper error
      );
    }
  }
}
