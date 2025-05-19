import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:lsp_server/lsp_server.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/localization.dart';
import 'package:pinto/semantic.dart';
import 'package:quiver/collection.dart';

final _resourceProvider = PhysicalResourceProvider.INSTANCE;

final class Analyzer {
  final _analysisEntities = SplayTreeSet<String>();
  final _analysisCache = <String, List<Diagnostic>>{};

  late AnalysisContextCollection _analysisContextCollection;
  late AbstractDartSdk _sdk;

  Analyzer() {
    _analysisContextCollection = AnalysisContextCollection(
      includedPaths: [],
      resourceProvider: _resourceProvider,
    );

    _sdk = FolderBasedDartSdk(
      _resourceProvider,
      _resourceProvider.getFolder(getSdkPath()),
    );
  }

  void addFileSystemEntity(FileSystemEntity entity) {
    final path = entity.absolute.path;
    final analysisEntities = [..._analysisEntities];

    for (final folder in analysisEntities) {
      if (path.startsWith(folder)) {
        return;
      } else if (folder.startsWith(path)) {
        _analysisEntities.remove(folder);
      }
    }

    _analysisEntities.add(path);

    if (!listsEqual([..._analysisEntities], analysisEntities)) {
      _rebuildAnalysisContext();
    }
  }

  void _rebuildAnalysisContext() {
    _analysisContextCollection.dispose();

    _analysisContextCollection = AnalysisContextCollection(
      includedPaths: [..._analysisEntities],
      resourceProvider: _resourceProvider,
    );
  }

  Future<List<Diagnostic>> analyze(String path, String source) async {
    final errorHandler = ErrorHandler();

    final lexer = Lexer(source: source, errorHandler: errorHandler);

    final tokens = lexer.scanTokens();

    final parser = Parser(tokens: tokens, errorHandler: errorHandler);

    final program = parser.parse();

    final symbolsResolver = SymbolsResolver(
      resourceProvider: _resourceProvider,
      analysisContextCollection: _analysisContextCollection,
      sdk: _sdk,
    );

    final resolver = Resolver(
      program: program,
      symbolsResolver: symbolsResolver,
      errorHandler: errorHandler,
    );

    await resolver.resolve();

    final diagnostics = [
      for (final error in errorHandler.errors)
        _diagnosticFromError(lexer, error, source),
    ];

    _analysisCache[path] = diagnostics;

    return diagnostics;
  }
}

Diagnostic _diagnosticFromError(Lexer lexer, PintoError error, String source) {
  final offset = switch (error) {
    LexingError(:final offset) => offset,
    ParseError(:final syntacticEntity) ||
    ResolveError(:final syntacticEntity) => syntacticEntity.offset,
  };

  final (line, column) = lexer.positionForOffset(offset);

  final length = switch (error) {
    LexingError() => 1,
    ParseError(:final syntacticEntity) ||
    ResolveError(:final syntacticEntity) => syntacticEntity.length,
  };

  final start = Position(line: line - 1, character: column - 1);

  final end = Position(line: line - 1, character: column - 1 + length);

  final range = Range(start: start, end: end);
  final message = messageFromError(error, source);

  return Diagnostic(message: message, range: range);
}
