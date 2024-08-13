import 'dart:convert';
import 'dart:io';

import 'package:chalkdart/chalkstrings.dart';
import 'package:dart_style/dart_style.dart';
import 'package:exitcode/exitcode.dart';
import 'package:pinto/ast.dart';
import 'package:pinto/compiler.dart';
import 'package:pinto/error.dart';
import 'package:pinto/semantic.dart';

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
    final error = await run(fileString);

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

Future<PintoError?> run(String source) async {
  final errorHandler = ErrorHandler();

  final lineSplitter = LineSplitter(); // TODO(mateusfccp): Convert the handler into an interface and put this logic inside
  final lines = lineSplitter.convert(source);
  if (source.endsWith('\n')) {
    lines.add('');
  }

  String getLineWithErrorPointer(int line, int column, int length) {
    final buffer = StringBuffer();

    void addLine(int line) {
      buffer.writeln('${chalk.gray('$line: ')}${lines[line - 1]}');
    }

    if (line - 1 >= 1) {
      addLine(line - 1);
    }

    addLine(line);

    buffer.write('   '); // Padding equivalent to the line indicators

    for (int i = 0; i < column - length; i++) {
      buffer.write(' ');
    }

    final character = length == 1 ? '↑' : '^';

    for (int i = 0; i < length; i++) {
      buffer.write(chalk.redBright(character));
    }

    buffer.writeln();

    if (lines.length > line) {
      addLine(line + 1);
    }

    return buffer.toString();
  }

  void handleError() {
    final error = errorHandler.lastError;
    if (error == null) return;

    final errorHeader = switch (error) {
      ParseError() when error.token.type == TokenType.endOfFile => '[${error.token.line}:${error.token.column}] Error at end:',
      ParseError() => "[${error.token.line}:${error.token.column}]:",
      ResolveError() => "[${error.token.line}:${error.token.column}] Error at '${error.token.lexeme}':",
      ScanError() => '[${error.location.line}:${error.location.column}]:',
    };

    final errorMessage = switch (error) {
      // Parse errors
      ExpectError(:final expectation) => "Expected to find $expectation.",
      ExpectAfterError(:final token, :final expectation, :final after) => "Expected to find $expectation after $after. Found '${token.lexeme}'.",
      ExpectBeforeError(:final expectation, :final before) => "Expected to find $expectation before $before.",

      // Resolve errors
      NoSymbolInScopeError(:final token) => "The symbol ${token.lexeme} was not found in the scope.",
      TypeAlreadyDefinedError(:final token) => "The type parameter '${token.lexeme}' is already defined for this type. Try removing it or changing it's name.",
      WrongNumberOfArgumentsError(:final token, argumentsCount: 1, expectedArgumentsCount: 0) => "The type '${token.lexeme}' don't accept arguments, but 1 argument was provided.",
      WrongNumberOfArgumentsError(:final token, :final argumentsCount, expectedArgumentsCount: 0) => "The type '${token.lexeme}' don't accept arguments, but $argumentsCount arguments were provided.",
      WrongNumberOfArgumentsError(:final token, argumentsCount: 0, :final expectedArgumentsCount) => "The type '${token.lexeme}' expects $expectedArgumentsCount arguments, but none was provided.",
      WrongNumberOfArgumentsError(:final token, argumentsCount: 1, :final expectedArgumentsCount) => "The type '${token.lexeme}' expects $expectedArgumentsCount arguments, but 1 was provided.",
      WrongNumberOfArgumentsError(:final token, :final argumentsCount, :final expectedArgumentsCount) =>
        "The type '${token.lexeme}' expects $expectedArgumentsCount arguments, but $argumentsCount were provided.",

      // Scan errors
      UnexpectedCharacterError() => "Unexpected character '${error.character}'.",
    };

    final lineHint = switch (error) {
      ScanError() => getLineWithErrorPointer(error.location.line, error.location.column, 1),
      ParseError(:final token) || ResolveError(:final token) => getLineWithErrorPointer(token.line, token.column, token.lexeme.length),
    };

    stderr.writeln(chalk.yellowBright('$errorHeader $errorMessage'));
    stderr.writeln(lineHint);
  }

  errorHandler.addListener(handleError);

  final scanner = Scanner(
    source: source,
    errorHandler: errorHandler,
  );

  final tokens = scanner.scanTokens();

  final parser = Parser(
    tokens: tokens,
    errorHandler: errorHandler,
  );

  final program = parser.parse();

  final resolver = Resolver(
    program: program,
    symbolsResolver: SymbolsResolver(
      projectRoot: Directory.current.path,
    ),
    errorHandler: errorHandler,
  );

  await resolver.resolve();

  if (errorHandler.hasError) {
    return errorHandler.lastError;
  }

  final buffer = StringBuffer();
  final visitor = Compiler(resolver: resolver);

  visitor.visitProgram(program);

  visitor.writeToSink(buffer);

  final formatted = DartFormatter().format(buffer.toString());

  stdout.write(formatted);

  return errorHandler.lastError;
}
