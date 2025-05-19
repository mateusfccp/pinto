import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/util/sdk.dart';
import 'package:args/args.dart';
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
import 'package:pinto/syntactic_entity.dart';

import 'src/server.dart';

const _padSize = 5;

final _resourceProvider = PhysicalResourceProvider.INSTANCE;

final _argParser = ArgParser()
  ..addFlag('help', help: 'Shows this help.', negatable: false)
  ..addFlag(
    'server',
    help: 'Makes program run in LSP server mode.',
    negatable: false,
  )
  ..addFlag(
    'version',
    help: 'Shows the installed pint° version.',
    negatable: false,
  );

Future<void> main(List<String> args) async {
  final result = _argParser.parse(args);

  if (result.flag('version')) {
    stdout.writeln('pinto CLI, version 0.0.4+1');
    return;
  } else if (result.flag('help')) {
    stdout.writeln(_argParser.usage);
    return;
  }

  if (result.flag('server')) {
    runServer();
  } else {
    if (args.length == 1) {
      await runFile(args.single);
    } else {
      stderr.writeln('Usage: pinto [script]');
      exit(usage);
    }
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

  final lexer = Lexer(source: source, errorHandler: errorHandler);

  final errorFormatter = ErrorFormatter(
    lexer: lexer,
    source: source,
    sink: stderr,
  );

  errorHandler.addListener(errorFormatter.handleError);

  final tokens = lexer.scanTokens();

  final parser = Parser(tokens: tokens, errorHandler: errorHandler);

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
  final visitor = Compiler(programElement);
  visitor.write(buffer);

  final formatted = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
  ).format(buffer.toString());

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

    lines.addAll(lineSplitter.convert(source));

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
      ParseError(syntacticEntity: final token) ||
      ResolveError(syntacticEntity: final token) => token.offset,
    };

    final (line, column) = lexer.positionForOffset(offset);

    final errorHeader = switch (error) {
      ParseError(syntacticEntity: Token(type: TokenType.endOfFile)) =>
        '[$line:$column] Error at end:',
      ParseError() => "[$line:$column]:",
      ResolveError(:final syntacticEntity) =>
        "[$line:$column] Error at ${_syntacticEntityDescription(syntacticEntity)}:",
      LexingError() => '[$line:$column]:',
    };

    final errorMessage = messageFromError(error, source);

    sink.writeln(chalk.yellowBright('$errorHeader $errorMessage'));

    final length = switch (error) {
      LexingError() => 1,
      ParseError(:final syntacticEntity) ||
      ResolveError(:final syntacticEntity) => syntacticEntity.length,
    };

    writeLineWithErrorPointer(line, column, length);
  }

  void writeLineWithErrorPointer(int line, int column, int length) {
    if (line - 1 >= 1) {
      addLine(line - 1);
    }

    addLine(line);

    sink.write(
      ' ' * (_padSize + 2),
    ); // Padding equivalent to the line indicators

    for (int i = 0; i < column - 1; i++) {
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
    sink.writeln(
      '${chalk.gray('${line.toString().padLeft(_padSize)}: ')}${lines[line - 1]}',
    );
  }
}

String _syntacticEntityDescription(SyntacticEntity entity) {
  return switch (entity) {
    Token() => "'${entity.lexeme}'",
    ImportDeclaration() => 'import',
    IdentifierExpression() => 'identifier',
    SyntacticEntity() => 'syntactic entity',
  };
}
