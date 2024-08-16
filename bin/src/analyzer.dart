import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:lsp_server/lsp_server.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';
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

  Future<List<Diagnostic>> analyze(String path, String text) async {
    final errorHandler = ErrorHandler();

    final scanner = Scanner(
      source: text,
      errorHandler: errorHandler,
    );

    final tokens = scanner.scanTokens();

    final parser = Parser(
      tokens: tokens,
      errorHandler: errorHandler,
    );

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
      for (final error in errorHandler.errors) _diagnosticFromError(error),
    ];

    _analysisCache[path] = diagnostics;

    return diagnostics;
  }
}

Diagnostic _diagnosticFromError(PintoError error) {
  final start = switch (error) {
    ScanError(:final location) => Position(
        character: location.column - 1,
        line: location.line - 1,
      ),
    ParseError(:final token) || ResolveError(:final token) => Position(
        character: token.column - token.lexeme.length,
        line: token.line - 1,
      ),
  };

  final end = switch (error) {
    ScanError(:final location) => Position(
        character: location.column,
        line: location.line - 1,
      ),
    ParseError(:final token) || ResolveError(:final token) => Position(
        character: token.column,
        line: token.line - 1,
      ),
  };

  final range = Range(start: start, end: end);

  final message = messageFromError(error);

  return Diagnostic(
    message: message,
    range: range,
  );
}
