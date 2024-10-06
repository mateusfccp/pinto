import 'package:intl/intl.dart';
import 'package:pinto/error.dart';

String messageFromError(PintoError error, String source) {
  final offset = switch (error) {
    LexingError() => error.offset,
    ParseError(:final syntacticEntity) || ResolveError(syntacticEntity: final syntacticEntity) => syntacticEntity.offset,
  };

  final end = switch (error) {
    LexingError() => error.offset + 1,
    ParseError(:final syntacticEntity) || ResolveError(syntacticEntity: final syntacticEntity) => syntacticEntity.end,
  };

  final fragment = source.substring(offset, end);

  return switch (error) {
    // Parse errors
    ExpectedError error => expectError('${error.expectation}', fragment),
    ExpectedAfterError error => expectAfterError('${error.expectation}', '${error.after}', fragment),
    ExpectedBeforeError error => expectBeforeError('${error.expectation}', '${error.before}', fragment),
    MisplacedImport error => misplacedImportError('${error.syntacticEntity}'),

    // Resolve errors
    ImportedPackageNotAvailableError() => importedPackageNotAvailableError(fragment),
    IdentifierAlreadyDefinedError() => identifierAlreadyDefinedError(fragment),
    NotAFunctionError() => notAFunctionError(fragment),
    SymbolNotInScopeError() => symbolNotInScopeError(fragment),
    TypeParameterAlreadyDefinedError() => typeParameterAlreadyDefinedError(fragment),
    WrongNumberOfArgumentsError error => wrongNumberOfArgumentsError(error.argumentsCount, error.expectedArgumentsCount, fragment),

    // Scan errors
    NumberEndingWithSeparatorError() => numberEndingWithSeparatorError(),
    UnexpectedCharacterError() => unexpectedCharacterError(fragment),
    UnterminatedStringError() => unterminatedStringError(),
  };
}

// Parse errors
String expectError(String expectation, String found) {
  return Intl.message(
    "Expected to find $expectation. Found '$found'.",
    name: 'expectErrorMessage',
    args: [expectation, found],
    desc: 'The error message for unqualified parsing expectation',
  );
}

String expectAfterError(String expectation, String after, String found) {
  return Intl.message(
    "Expected to find $expectation after $after. Found '$found'.",
    name: 'expectAfterErrorMessage',
    args: [expectation, after, found],
    desc: 'The error message for expected element after the current token',
  );
}

String expectBeforeError(String expectation, String before, String found) {
  return Intl.message(
    'Expected to find $expectation before $before. Found $found.',
    name: 'expectBeforeErrorMessage',
    args: [expectation, before, found],
    desc: 'The error message for expected element before the current token',
  );
}

String misplacedImportError(String import) {
  return Intl.message(
    'Imports should be the first thing of a file. $import was found after'
    'another kind of declaration.',
    name: 'misplacedBeforeErrorMessage',
    args: [import],
    desc: 'The error message for when an import is placed after a non-import declaration.',
  );
}

// Resolve errors
String identifierAlreadyDefinedError(String identifier) {
  return Intl.message(
    "The identifier '$identifier' is already defined in the context.",
    name: 'identifierAlreadyDefineErrorMessage',
    args: [identifier],
    desc: 'The error describing that the identifier that is being defined has'
        'a named that was already used by other definition.',
  );
}

String importedPackageNotAvailableError(String import) {
  return Intl.message(
    "The imported package '$import' does not exist.",
    name: 'importedPackageNotAvailableErrorMessage',
    args: [import],
    desc: 'The error describing that the package that is being imported does '
        'exist or was not fetched by `pub get`',
  );
}

String notAFunctionError(String identifier) {
  return Intl.message(
    "'$identifier' is not a function, so it can't receive an argument.",
    name: 'notAFunctionErrorMessage',
    args: [identifier],
    desc: 'The error describing that the identifier that receive as parameter'
        "is not a function, and thus it shouldn't receive a parameter.",
  );
}

String symbolNotInScopeError(String symbol) {
  return Intl.message(
    "The symbol '$symbol' was not found in the scope.",
    name: 'symbolNotInScopeErrorMessage',
    args: [symbol],
    desc: 'The error message describing a symbol that was not found in the scope.',
  );
}

String typeParameterAlreadyDefinedError(String typeParameter) {
  return Intl.message(
    "The type parameter '$typeParameter' is already defined for this type. Try removing it or changing it's name.",
    name: 'typeAlreadyDefinedErrorMessage',
    args: [typeParameter],
    desc: 'The error message describing that a symbol is already defined in the scope.',
  );
}

String wrongNumberOfArgumentsError(int argumentsCount, int expectedArgumentsCount, String type) {
  return Intl.message(
    Intl.plural(
      argumentsCount,
      zero: Intl.plural(
        expectedArgumentsCount,
        one: "The type '$type' expects one argument, but none was provided.",
        other: "The type '$type' expects $expectedArgumentsCount arguments, but none was provided.",
      ),
      one: Intl.plural(
        expectedArgumentsCount,
        zero: "The type '$type' don't accept arguments, but an argument was provided.",
        other: "The type '$type' expects $expectedArgumentsCount arguments, but an was provided.",
      ),
      other: Intl.plural(
        expectedArgumentsCount,
        zero: "The type '$type' don't accept arguments, but $argumentsCount arguments were provided.",
        one: "The type '$type' expects one argument, but $argumentsCount arguments were provided.",
        other: "The type '$type' expects $expectedArgumentsCount, but $argumentsCount arguments were provided.",
      ),
    ),
    name: 'wrongNumberOfArgumentsErrorMessage',
    args: [argumentsCount, expectedArgumentsCount, type],
    desc: 'The error message for when the number of type arguments passed to a type is different than the expected.',
  );
}

// Lexing errors

String unexpectedCharacterError(String character) {
  return Intl.message(
    "Unexpected character '$character'.",
    name: 'unexpectedCharacterErrorMessage',
    args: [character],
    desc: "The error message from when the lexer finds a character that it's not supposed to scan.",
  );
}

String unterminatedStringError() {
  return Intl.message(
    "Unexpected string termination.",
    name: 'unterminatedStringErrorMessage',
    args: [],
    desc: "The error message from when the lexer can't find the end of a string literal.",
  );
}

String numberEndingWithSeparatorError() {
  return Intl.message(
    "Unexpected number termination. Numbers must not end with an underscore '_'.",
    name: 'numberEndingWithSeparatorErrorMessage',
    args: [],
    desc: "The error message when the lexer finds a number ending with an underscore.",
  );
}
