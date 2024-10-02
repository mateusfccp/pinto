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

final class Tester {
  Tester.path(String path) {
    final file = File(path);
    final stream = file.openRead();
    final stringStream = _utf8Decoder.bind(stream);
    _linesStream = _lineSplitter.bind(stringStream);
  }

  final _utf8Decoder = Utf8Decoder();
  final _lineSplitter = LineSplitter();
  late final Stream<String> _linesStream;

  Stream<Expectation> getExpectations() async* {
    var currentLineOffset = 0;
    var lastAnalyzedLineOffset = currentLineOffset;

    await for (final line in _linesStream) {
      final expectation = _processLine(lastAnalyzedLineOffset, line);
      if (expectation == null) {
        lastAnalyzedLineOffset = currentLineOffset;
      } else {
        yield expectation;
      }
      currentLineOffset = currentLineOffset + line.length;
    }
  }

  Expectation? _processLine(int lineStartOffset, String line) {
    final match = _lineRegex.firstMatch(line);
    if (match != null) {
      final expectedError = match[1];
      final begin = lineStartOffset + line.indexOf(_marker);
      final end = lineStartOffset + line.lastIndexOf(_marker);
      return expectedError == null //
          ? Any(begin: begin, end: end)
          : Specific(name: expectedError, begin: begin, end: end);
    } else {
      return null;
    }
  }
}

final class ErrorExpectator {
  ErrorExpectator(String path) {
    _file = File(path);

    _errorHandler.addListener(_processError);
  }

  final _resourceProvider = PhysicalResourceProvider.INSTANCE;
  final _errorHandler = ErrorHandler();
  final _controller = StreamController<Expectation>();
  late final File _file;

  Stream<Expectation> get expectations => _controller.stream;

  Future<void> expect() async {
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
      LexingError() => (error.offset, error.offset),
      ParseError(syntacticEntity: final entity) || ResolveError(syntacticEntity: final entity) => (entity.offset, entity.end),
    };

    final errorName = _errorNameRegExp.firstMatch('$error')![1]!;

    final expectation = Specific(
      name: errorName,
      begin: begin,
      end: end,
    );

    _controller.add(expectation);
  }

  // TODO(mateusfccp): Do better.
  static final _errorNameRegExp = RegExp(r"Instance of '(\w+)'");
}

final _lineRegex = RegExp('\\s*//\\s*\\$_marker+(?:\\s+(\\w+))?');

sealed class Expectation {}

final class Any implements Expectation {
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

final class Specific implements Expectation {
  const Specific({
    required this.name,
    required this.begin,
    required this.end,
  });

  final String name;
  final int begin;
  final int end;

  @override
  String toString() => '$name($begin, $end)';

  @override
  bool operator ==(Object other) {
    if (other is Any) {
      return other.begin == begin && other.end == end;
    } else if (other is Specific) {
      return other.name == name && other.begin == begin && other.end == end;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(name, begin, end);
}
