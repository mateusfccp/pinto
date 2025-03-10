import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:matcher/src/interfaces.dart';
import 'package:matcher/src/pretty_print.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/error.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/semantic.dart';
import 'package:quiver/collection.dart';
import 'package:test/test.dart';

const _marker = '^';

/// A static tester for pint° files.
///
/// [StaticTester] reads a file and provides a stream of [expectations] and
/// [errors].
final class StaticTester {
  /// Creates a static tester for the file at [path].
  StaticTester(String path) {
    _file = File(path);
    _fileContent = _file.readAsStringSync();
    _errorHandler.addListener(_processError);

    _buildExpectations();
    _analyze();
  }

  late final File _file;
  late final String _fileContent;

  final _resourceProvider = PhysicalResourceProvider.INSTANCE;
  final _errorHandler = ErrorHandler();
  final _expectationsController = StreamController<ErrorEmission>();
  final _errorsController = StreamController<ErrorEmission>();

  /// The expectations of the file.
  Stream<ErrorEmission> get expectations => _expectationsController.stream;

  /// The errors of the file.
  Stream<ErrorEmission> get errors => _errorsController.stream;

  void _buildExpectations() {
    final lines = LineSplitter.split(_fileContent);
    var currentLineOffset = 0;
    var lastAnalyzedLineOffset = currentLineOffset;

    for (final line in lines) {
      final expectation = _processLine(lastAnalyzedLineOffset, line);
      if (expectation == null) {
        lastAnalyzedLineOffset = currentLineOffset;
      } else {
        _expectationsController.add(expectation);
      }

      currentLineOffset = currentLineOffset + line.length + 1; // + 1 for line break
    }

    _expectationsController.close();
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

  Future<void> _analyze() async {
    final lexer = Lexer(
      source: _fileContent,
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
    _errorsController.close();
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

    _errorsController.add(expectation);
  }
}

final _lineRegex = RegExp('\\s*//\\s*\\$_marker+(?:\\s+(([A-Za-z_\$][A-Za-z_\$0-9]*)+))?');

/// An error emitted by the parser or resolver.
sealed class ErrorEmission implements Comparable<ErrorEmission> {
  const ErrorEmission();

  /// The offset where the error begins.
  int get begin;

  /// The offset where the error ends.
  int get end;

  @override
  int compareTo(ErrorEmission other) {
    final beginComparison = begin.compareTo(other.begin);

    if (beginComparison != 0) {
      return beginComparison;
    } else {
      return end.compareTo(other.end);
    }
  }
}

/// An error that matches any emitted error.
final class Any extends ErrorEmission {
  /// Creates an error that matches any emitted error.
  const Any({
    required this.begin,
    required this.end,
  });

  @override
  final int begin;

  @override
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

/// An error that matches an emitted error with the given [code].
final class Specific extends ErrorEmission {
  /// Creates a specific error with the given [code].
  const Specific({
    required this.code,
    required this.begin,
    required this.end,
  });

  final String code;

  @override
  final int begin;

  @override
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

  @override
  int compareTo(ErrorEmission other) {
    final offsetComparison = super.compareTo(other);

    if (offsetComparison != 0) {
      return offsetComparison;
    } else {
      return switch (other) {
        Any() => code.compareTo('any'),
        Specific() => code.compareTo(other.code),
      };
    }
  }
}

/// A matcher that matches if two sets are equal.
///
/// It gives detailed information about the differences between the sets.
Matcher emittedJustLikeTheExpected(Set<ErrorEmission> expected) => _SetMatcherWithDifferenceDescription(expected);

final class _SetMatcherWithDifferenceDescription extends Matcher {
  const _SetMatcherWithDifferenceDescription(this.expected);

  final Set<ErrorEmission> expected;

  @override
  Description describe(Description description) {
    return description..add(prettyPrint(expected));
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is Set<ErrorEmission>) {
      final missingExpectations = expected.difference(item);
      final unexpectedErrors = item.difference(expected);

      // final buffer = StringBuffer('The static tester did not match the expectations and errors.\n\n');
      mismatchDescription.add('The static tester did not match the expectations and errors.\n');

      if (missingExpectations.isNotEmpty) {
        mismatchDescription.add('\nThe following expectations were not emitted:');

        for (final expectation in missingExpectations) {
          mismatchDescription.add('\n• $expectation');
        }

        mismatchDescription.add('\n');
      }

      if (unexpectedErrors.isNotEmpty) {
        mismatchDescription.add('\nThe following errors were emitted but should not have been:');

        for (final error in unexpectedErrors) {
          mismatchDescription.add('\n• $error');
        }
      }
    } else {
      mismatchDescription.add('The matched item "$item" is not a Set<ErrorEmission>.');
    }
    return mismatchDescription;
  }

  @override
  bool matches(Object? item, Map matchState) {
    if (item is Set<ErrorEmission>) {
      return setsEqual(item, expected);
    } else {
      return false;
    }
  }
}
