import 'package:intl/intl.dart';
import 'package:pinto/error.dart';

String messageFromError(PintoError error) {
  return switch (error) {
    // Parse errors
    ExpectError error => expectError('${error.expectation}', error.token.lexeme),
    ExpectAfterError error => expectAfterError('${error.expectation}', '${error.after}', error.token.lexeme),
    ExpectBeforeError error => expectBeforeError('${error.expectation}', '${error.before}', error.token.lexeme),

    // Resolve errors
    ImportedPackageNotAvailableError error => importedPackageNotAvailableError(error.token.lexeme),
    SymbolNotInScopeError error => symbolNotInScopeError(error.token.lexeme),
    TypeParameterAlreadyDefinedError error => typeParameterAlreadyDefinedError(error.token.lexeme),
    WrongNumberOfArgumentsError error => wrongNumberOfArgumentsError(error.argumentsCount, error.expectedArgumentsCount, error.token.lexeme),

    // Scan errors
    UnexpectedCharacterError error => unexpectedCharacterError(error.character),
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

// Resolve errors

String importedPackageNotAvailableError(String import) {
  return Intl.message(
    "The imported package '$import' does not exist.",
    name: 'importedPackageNotAvailableErrorMessage',
    args: [import],
    desc: 'The error describing that the package that is being imported does '
    'exist or was not fetched by `pub get`',
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

// Scan error

String unexpectedCharacterError(String character) {
  return Intl.message(
    "Unexpected character '$character'.",
    name: 'unexpectedCharacterErrorMessage',
    args: [character],
    desc: "The error message from when the scanner finds a character that it's not supposed to scan.",
  );
}
