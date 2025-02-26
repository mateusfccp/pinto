import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'ast/ast.dart';
import 'lexer/token.dart';
import 'syntactic_entity.dart';
import 'semantic/type.dart';

part 'error.freezed.dart';

/// A Pinto error.
sealed class PintoError {
  String get code;
}

/// An error that happened while the program was being lexed.
sealed class LexingError implements PintoError {
  int get offset;
}

final class InvalidIdentifierStart implements LexingError {
  const InvalidIdentifierStart({required this.offset});

  @override
  final int offset;

  @override
  String get code => 'invalid_identifier_start';
}

final class NumberEndingWithSeparatorError implements LexingError {
  const NumberEndingWithSeparatorError({required this.offset});

  @override
  final int offset;

  @override
  String get code => 'number_ending_with_separator';
}

final class UnexpectedCharacterError implements LexingError {
  const UnexpectedCharacterError({
    required this.offset,
  });

  @override
  final int offset;

  @override
  String get code => 'unexpected_character';
}

final class UnterminatedStringError implements LexingError {
  const UnterminatedStringError({required this.offset});

  @override
  final int offset;

  @override
  String get code => 'unterminated_string';
}

/// An error that happened while the program was being parsed.
sealed class ParseError implements PintoError {
  SyntacticEntity get syntacticEntity;
}

@freezed
sealed class ExpectedError with _$ExpectedError implements ParseError {
  const factory ExpectedError({
    required SyntacticEntity syntacticEntity,
    required ExpectationType expectation,
  }) = _ExpectError;

  const ExpectedError._();

  @override
  String get code => 'expected_${expectation.code}';
}

@freezed
sealed class ExpectedAfterError with _$ExpectedAfterError implements ParseError {
  const factory ExpectedAfterError({
    required SyntacticEntity syntacticEntity,
    required ExpectationType expectation,
    required ExpectationType after,
  }) = _ExpectAfterError;

  const ExpectedAfterError._();

  @override
  String get code => 'expected_${expectation.code}_after_${after.code}';
}

@freezed
sealed class ExpectedBeforeError with _$ExpectedBeforeError implements ParseError {
  const factory ExpectedBeforeError({
    required SyntacticEntity syntacticEntity,
    required ExpectationType expectation,
    required ExpectationType before,
  }) = _ExpectBeforeError;

  const ExpectedBeforeError._();

  @override
  String get code => 'expected_${expectation.code}_before_${before.code}';
}

@freezed
sealed class ExpectationType with _$ExpectationType {
  const ExpectationType._();

  const factory ExpectationType.declaration({Declaration? declaration}) = DeclarationExpectation;

  const factory ExpectationType.expression({Expression? expression}) = ExpressionExpectation;

  const factory ExpectationType.oneOf({required List<ExpectationType> expectations}) = OneOfExpectation;

  const factory ExpectationType.token({
    required TokenType token,
    String? description,
  }) = TokenExpectation;

  String get code {
    return switch (this) {
      DeclarationExpectation(declaration: ImportDeclaration()) => 'import',
      DeclarationExpectation(declaration: LetDeclaration()) => 'let_declaration',
      DeclarationExpectation(declaration: TypeDefinition()) => 'type_definition',
      DeclarationExpectation() => 'declaration',
      ExpressionExpectation() => 'expression',
      OneOfExpectation(:final expectations) => expectations.map((expectation) => expectation.code).join('_or_'),
      TokenExpectation(:final token) => token.code,
    };
  }

  @override
  String toString() {
    return switch (this) {
      DeclarationExpectation(declaration: ImportDeclaration()) => 'an import',
      DeclarationExpectation(declaration: LetDeclaration()) => 'a let declaration',
      DeclarationExpectation(declaration: TypeDefinition()) => 'a type definition',
      DeclarationExpectation() => 'a declaration',
      ExpressionExpectation() => 'an expression',
      OneOfExpectation(:final expectations) => "${expectations.length > 1 ? 'one of ' : ''}${expectations.join(', ')}",
      TokenExpectation(:final description, :final token) => description ?? "'$token'",
    };
  }
}

final class MisplacedImport implements ParseError {
  const MisplacedImport({
    required ImportDeclaration importDeclaration,
  }) : syntacticEntity = importDeclaration;

  @override
  final ImportDeclaration syntacticEntity;

  @override
  String get code => 'misplaced_import';
}

/// An error that happened while the program was being resolved.
sealed class ResolveError implements PintoError {
  SyntacticEntity get syntacticEntity;
}

final class IdentifierAlreadyDefinedError implements ResolveError {
  const IdentifierAlreadyDefinedError(this.syntacticEntity);

  @override
  final Token syntacticEntity;

  @override
  String get code => 'identifier_already_defined';
}

final class ImportedPackageNotAvailableError implements ResolveError {
  const ImportedPackageNotAvailableError(this.syntacticEntity);

  @override
  final SyntacticEntity syntacticEntity;

  @override
  String get code => 'imported_package_not_available';
}

/// An error that indicates that the type of a parameter is invalid.
///
/// A parameter should be a [TypeType] or a [PolymorphicType] that resolves to
/// a [TypeType].
final class InvalidParameterType implements ResolveError {
  const InvalidParameterType({
    required this.syntacticEntity,
    required this.parameterType,
  });

  @override
  final SyntacticEntity syntacticEntity;

  /// The type of the parameter.
  final Type parameterType;

  @override
  String get code => 'invalid_parameter_type';
}

final class NotAFunctionError implements ResolveError {
  const NotAFunctionError({
    required this.syntacticEntity,
    required this.calledType,
  });

  @override
  final SyntacticEntity syntacticEntity;

  final Type calledType;

  @override
  String get code => 'not_a_function';
}

final class SymbolNotInScopeError implements ResolveError {
  const SymbolNotInScopeError(this.syntacticEntity);

  @override
  final Token syntacticEntity;

  @override
  String get code => 'symbol_not_in_scope';
}

final class TypeParameterAlreadyDefinedError implements ResolveError {
  const TypeParameterAlreadyDefinedError(this.syntacticEntity);

  @override
  final Token syntacticEntity;

  @override
  String get code => 'type_parameter_already_defined';
}

final class WrongNumberOfArgumentsError implements ResolveError {
  const WrongNumberOfArgumentsError({
    required this.syntacticEntity,
    required this.argumentsCount,
    required this.expectedArgumentsCount,
  }) : assert(argumentsCount != expectedArgumentsCount);

  @override
  final SyntacticEntity syntacticEntity;

  final int argumentsCount;

  final int expectedArgumentsCount;

  @override
  String get code => 'wrong_number_of_arguments';
}

/// An pint° error handler.
final class ErrorHandler {
  final _errors = <PintoError>[];
  final _listeners = <void Function(PintoError)>[];

  /// The errors that were emitted by the handler.
  UnmodifiableListView<PintoError> get errors => UnmodifiableListView(_errors);

  /// Whether at least one error was emitted.
  bool get hasError => _errors.isNotEmpty;

  /// The last emitted error.
  ///
  /// If no error was emitted, `null` is returned.
  PintoError? get lastError => hasError ? _errors[_errors.length - 1] : null;

  /// Adds a [listener] to the handler.
  ///
  /// A listener will be called whenever an error is emitted. The emmited error
  /// is passed to the listener.
  void addListener(void Function(PintoError) listener) => _listeners.add(listener);

  /// Removes [listener] from the handler.
  void removeListener(void Function() listener) => _listeners.remove(listener);

  /// Emits an [error].
  ///
  /// The listeners will be notified of the error.
  void emit(PintoError error) {
    _errors.add(error);
    for (final listener in _listeners) {
      listener.call(error);
    }
  }
}
