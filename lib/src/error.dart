import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'ast/ast.dart';
import 'lexer/token.dart';
import 'syntactic_entity.dart';
import 'semantic/type.dart';

part 'error.freezed.dart';

/// A Pinto error.
sealed class PintoError {}

/// An error that happened while the program was being lexed.
sealed class LexingError implements PintoError {
  int get offset;
}

final class UnexpectedCharacterError implements LexingError {
  const UnexpectedCharacterError({
    required this.offset,
  });

  @override
  final int offset;
}

final class UnterminatedStringError implements LexingError {
  const UnterminatedStringError({required this.offset});

  @override
  final int offset;
}

final class NumberEndingWithSeparatorError implements LexingError {
  const NumberEndingWithSeparatorError({required this.offset});

  @override
  final int offset;
}

final class DecimalPartNotStartingWithANumberError implements LexingError {
  const DecimalPartNotStartingWithANumberError({required this.offset});

  @override
  final int offset;
}

final class NumberLiteralTwoSeparatorsError implements LexingError {
  const NumberLiteralTwoSeparatorsError({required this.offset});

  @override
  final int offset;
}

/// An error that happened while the program was being parsed.
sealed class ParseError implements PintoError {
  SyntacticEntity get syntacticEntity;
}

@freezed
sealed class ExpectError with _$ExpectError implements ParseError {
  const factory ExpectError({
    required SyntacticEntity syntacticEntity,
    required ExpectationType expectation,
  }) = _ExpectError;
}

@freezed
sealed class ExpectAfterError with _$ExpectAfterError implements ParseError {
  const factory ExpectAfterError({
    required SyntacticEntity syntacticEntity,
    required ExpectationType expectation,
    required ExpectationType after,
  }) = _ExpectAfterError;
}

@freezed
sealed class ExpectBeforeError with _$ExpectBeforeError implements ParseError {
  const factory ExpectBeforeError({
    required SyntacticEntity syntacticEntity,
    required ExpectationType expectation,
    required ExpectationType before,
  }) = _ExpectBeforeError;
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

/// An error that happened while the program was being resolved.
sealed class ResolveError implements PintoError {
  SyntacticEntity get syntacticEntity;
}

final class IdentifierAlreadyDefinedError implements ResolveError {
  const IdentifierAlreadyDefinedError(this.syntacticEntity);

  @override
  final Token syntacticEntity;
}

final class ImportedPackageNotAvailableError implements ResolveError {
  const ImportedPackageNotAvailableError(this.syntacticEntity);

  @override
  final SyntacticEntity syntacticEntity;
}

final class NotAFunctionError implements ResolveError {
  const NotAFunctionError({
    required this.syntacticEntity,
    required this.calledType,
  });

  @override
  final SyntacticEntity syntacticEntity;

  final Type calledType;
}

final class SymbolNotInScopeError implements ResolveError {
  const SymbolNotInScopeError(this.syntacticEntity);

  @override
  final Token syntacticEntity;
}

final class TypeParameterAlreadyDefinedError implements ResolveError {
  const TypeParameterAlreadyDefinedError(this.syntacticEntity);

  @override
  final Token syntacticEntity;
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
