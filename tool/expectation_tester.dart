import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/semantic.dart';

const _marker = '^';

// TODO(mateusfccp): Maybe optimizing it by merging it with [ErrorAnalyzer], so we don't have to read the same file twice
final class ExpectationsParser {
  ExpectationsParser(String path) {
    final file = File(path);
    final stream = file.openRead();
    final stringStream = _utf8Decoder.bind(stream);
    _linesStream = _lineSplitter.bind(stringStream);
  }

  final _utf8Decoder = Utf8Decoder();
  final _lineSplitter = LineSplitter();
  late final Stream<String> _linesStream;

  Stream<ErrorEmission> getExpectations() async* {
    var currentLineOffset = 0;
    var lastAnalyzedLineOffset = currentLineOffset;

    await for (final line in _linesStream) {
      final expectation = _processLine(lastAnalyzedLineOffset, line);
      if (expectation == null) {
        lastAnalyzedLineOffset = currentLineOffset;
      } else {
        yield expectation;
      }

      currentLineOffset = currentLineOffset + line.length + 1; // + 1 for line break
    }
  }

  ErrorEmission? _processLine(int lineStartOffset, String line) {
    final match = _lineRegex.firstMatch(line);
    if (match != null) {
      final expectedError = match[1];
      final begin = lineStartOffset + line.indexOf(_marker);
      final end = lineStartOffset + line.lastIndexOf(_marker) + 1;
      return expectedError == null //
          ? Any(begin: begin, end: end)
          : Specific(code: expectedError, begin: begin, end: end);
    } else {
      return null;
    }
  }
}

final class ErrorAnalyzer {
  ErrorAnalyzer(String path) {
    _file = File(path);

    _errorHandler.addListener(_processError);
  }

  final _resourceProvider = PhysicalResourceProvider.INSTANCE;
  final _errorHandler = ErrorHandler();
  final _controller = StreamController<ErrorEmission>();
  late final File _file;

  Stream<ErrorEmission> get errors => _controller.stream;

  Future<void> analyze() async {
    final content = await _file.readAsString();

    final lexer = Lexer(
      source: content,
      errorHandler: _errorHandler,
    );

    final tokens = lexer.scanTokens();

    final parser = Parser(
      tokens: tokens,
      errorHandler: _errorHandler,
    );

    final ast = parser.parse();

    final analysisContextCollection = AnalysisContextCollection(
      includedPaths: [_file.absolute.path],
      resourceProvider: _resourceProvider,
    );

    final sdk = FolderBasedDartSdk(
      _resourceProvider,
      _resourceProvider.getFolder(getSdkPath()),
    );

    final symbolsResolver = SymbolsResolver(
      resourceProvider: _resourceProvider,
      analysisContextCollection: analysisContextCollection,
      sdk: sdk,
    );

    final resolver = Resolver(
      program: ast,
      symbolsResolver: symbolsResolver,
      errorHandler: _errorHandler,
    );

    await resolver.resolve();
    _controller.close();
  }

  void _processError(PintoError error) {
    final (begin, end) = switch (error) {
      LexingError() => (error.offset, error.offset + 1),
      ParseError(syntacticEntity: final entity) || ResolveError(syntacticEntity: final entity) => (entity.offset, entity.end),
    };

    final expectation = Specific(
      code: error.code,
      begin: begin,
      end: end,
    );

    _controller.add(expectation);
  }
}

final _lineRegex = RegExp('\\s*//\\s*\\$_marker+(?:\\s+(([A-Za-z_\$][A-Za-z_\$0-9]*)+))?');

sealed class ErrorEmission {}

final class Any implements ErrorEmission {
  const Any({
    required this.begin,
    required this.end,
  });

  final int begin;
  final int end;

  @override
  String toString() => 'Any($begin, $end)';

  @override
  bool operator ==(Object other) {
    if (other is Any) {
      return other.begin == begin && other.end == end;
    } else if (other is Specific) {
      return other.begin == begin && other.end == end;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(begin, end);
}

final class Specific implements ErrorEmission {
  const Specific({
    required this.code,
    required this.begin,
    required this.end,
  });

  final String code;
  final int begin;
  final int end;

  @override
  String toString() => '$code($begin, $end)';

  @override
  bool operator ==(Object other) {
    if (other is Any) {
      return other.begin == begin && other.end == end;
    } else if (other is Specific) {
      return other.code == code && other.begin == begin && other.end == end;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(code, begin, end);
}
