import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:chalkdart/chalkstrings.dart';
import 'package:dart_style/dart_style.dart';
import 'package:exitcode/exitcode.dart';
import 'package:path/path.dart';
import 'package:pinto/lexer.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/compiler.dart';
import 'package:pinto/error.dart';
import 'package:pinto/localization.dart';
import 'package:pinto/semantic.dart';

final _resourceProvider = PhysicalResourceProvider.INSTANCE;

Future<void> main(List<String> args) async {
  if (args.length == 1) {
    await runFile(args.single);
  } else {
    stderr.writeln('Usage: pinto [script]');
    exit(usage);
  }
}

Future<void> runFile(String path) async {
  final file = File(path);

  if (await file.exists()) {
    final fileString = file.readAsStringSync();

    final path = normalize(file.absolute.path);

    final analysisContextCollection = AnalysisContextCollection(
      includedPaths: [path],
      resourceProvider: _resourceProvider,
    );

    final sdk = FolderBasedDartSdk(
      _resourceProvider,
      _resourceProvider.getFolder(getSdkPath()),
    );

    final error = await run(
      source: fileString,
      analysisContextCollection: analysisContextCollection,
      sdk: sdk,
    );

    switch (error) {
      case PintoError():
        exit(dataerr);
      case null:
        break;
    }
  } else {
    stderr.writeln('The informed file $path does not exist.');
    exit(noinput);
  }
}

Future<PintoError?> run({
  required String source,
  required AnalysisContextCollection analysisContextCollection,
  required AbstractDartSdk sdk,
}) async {
  final errorHandler = ErrorHandler();

  final lexer = Lexer(
    source: source,
    errorHandler: errorHandler,
  );

  final errorFormatter = ErrorFormatter(
    lexer: lexer,
    source: source,
    sink: stderr,
  );

  errorHandler.addListener(errorFormatter.handleError);

  final tokens = lexer.scanTokens();

  final parser = Parser(
    tokens: tokens,
    errorHandler: errorHandler,
  );

  final program = parser.parse();

  final symbolsResolver = SymbolsResolver(
    resourceProvider: _resourceProvider,
    analysisContextCollection: analysisContextCollection,
    sdk: sdk,
  );

  final resolver = Resolver(
    program: program,
    symbolsResolver: symbolsResolver,
    errorHandler: errorHandler,
  );

  final programElement = await resolver.resolve();

  if (errorHandler.hasError) {
    return errorHandler.lastError;
  }

  final buffer = StringBuffer();
  final visitor = Compiler(
    symbolsResolver: symbolsResolver,
  );

  visitor.visitProgramElement(programElement);
  visitor.writeToSink(buffer);

  final formatted = DartFormatter().format(buffer.toString());

  stdout.write(formatted);

  return errorHandler.lastError;
}

final class ErrorFormatter {
  ErrorFormatter({
    required this.lexer,
    required this.source,
    required this.sink,
  }) {
    final lineSplitter = LineSplitter();

    lines.addAll(
      lineSplitter.convert(source),
    );

    if (source.endsWith('\n')) {
      lines.add('');
    }
  }

  final Lexer lexer;
  final StringSink sink;
  final lines = <String>[];
  final String source;

  void handleError(PintoError error) {
    final offset = switch (error) {
      LexingError() => error.offset,
      ParseError(syntacticEntity: final token) || ResolveError(syntacticEntity: final token) => token.offset,
    };

    final (line, column) = lexer.positionForOffset(offset);

    final errorHeader = switch (error) {
      ParseError(syntacticEntity: Token(type: TokenType.endOfFile)) => '[$line:$column] Error at end:',
      ParseError() => "[$line:$column]:",
      ResolveError(syntacticEntity: final Token token) => "[$line:$column] Error at '${token.lexeme}':",
      ResolveError() => "[$line:$column] Error at UNHANDLED:",
      LexingError() => '[$line:$column]:',
    };

    final errorMessage = messageFromError(error, source);

    sink.writeln(chalk.yellowBright('$errorHeader $errorMessage'));

    final length = switch (error) {
      LexingError() => 1,
      ParseError(:final syntacticEntity) || ResolveError(:final syntacticEntity) => syntacticEntity.length,
    };

    writeLineWithErrorPointer(line, column, length);
  }

  void writeLineWithErrorPointer(int line, int column, int length) {
    if (line - 1 >= 1) {
      addLine(line - 1);
    }

    addLine(line);

    sink.write('   '); // Padding equivalent to the line indicators

    for (int i = 0; i < column - (length - 1); i++) {
      sink.write(' ');
    }

    final character = length == 1 ? '↑' : '^';

    for (int i = 0; i < length; i++) {
      sink.write(chalk.redBright(character));
    }

    sink.writeln();

    if (lines.length > line) {
      addLine(line + 1);
    }
  }

  void addLine(int line) {
    sink.writeln('${chalk.gray('$line: ')}${lines[line - 1]}');
  }
}
