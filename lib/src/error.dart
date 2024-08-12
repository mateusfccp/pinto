import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

// import 'expression.dart';
import 'ast/statement.dart';
import 'ast/token.dart';

part 'error.freezed.dart';

/// A Lox error.
sealed class PintoError {}

/// An error that happened while the program was being scanend.
sealed class ScanError implements PintoError {
  ScanLocation get location;
}

final class UnexpectedCharacterError implements ScanError {
  const UnexpectedCharacterError({
    required this.location,
    required this.character,
  });

  @override
  final ScanLocation location;

  final String character;
}

final class UnterminatedStringError implements ScanError {
  const UnterminatedStringError({required this.location});

  @override
  final ScanLocation location;
}

/// A location while the program is being scanned.
@freezed
sealed class ScanLocation with _$ScanLocation {
  const factory ScanLocation({
    required int offset,
    required int line,
    required int column,
  }) = _ScanLocation;
}

/// An error that happened while the program was being parsed.
sealed class ParseError implements PintoError {
  Token get token;
}

@freezed
sealed class ExpectError with _$ExpectError implements ParseError {
  const factory ExpectError({
    required Token token,
    required ExpectationType expectation,
  }) = _ExpectError;
}

@freezed
sealed class ExpectAfterError with _$ExpectAfterError implements ParseError {
  const factory ExpectAfterError({
    required Token token,
    required ExpectationType expectation,
    required ExpectationType after,
  }) = _ExpectAfterError;
}

@freezed
sealed class ExpectBeforeError with _$ExpectBeforeError implements ParseError {
  const factory ExpectBeforeError({
    required Token token,
    required ExpectationType expectation,
    required ExpectationType before,
  }) = _ExpectBeforeError;
}

@freezed
sealed class ExpectationType with _$ExpectationType {
  const ExpectationType._();

  // const factory ExpectationType.expression({
  //   Expression? expression,
  //   String? description,
  // }) = ExpressionExpectation;

  const factory ExpectationType.statement({
    required Statement statement,
    String? description,
  }) = StatementExpectation;

  const factory ExpectationType.token({
    required TokenType token,
    String? description,
  }) = TokenExpectation;

  @override
  String toString() {
    return description ??
        switch (this) {
          // ExpressionExpectation() => 'expression',
          StatementExpectation() => 'statement',
          TokenExpectation(:final token) => '$token',
        };
  }
}

final class ParametersLimitError implements ParseError {
  const ParametersLimitError({required this.token});

  @override
  final Token token;

  @override
  bool operator ==(Object other) {
    return other is ParametersLimitError && //
        token == other.token;
  }

  @override
  int get hashCode => token.hashCode;
}

final class ArgumentsLimitError implements ParseError {
  const ArgumentsLimitError({required this.token});

  @override
  final Token token;

  @override
  bool operator ==(Object other) {
    return other is ArgumentsLimitError && //
        token == other.token;
  }

  @override
  int get hashCode => token.hashCode;
}

final class InvalidAssignmentTargetError implements ParseError {
  const InvalidAssignmentTargetError({required this.token});

  @override
  final Token token;

  @override
  bool operator ==(Object other) {
    return other is InvalidAssignmentTargetError && //
        token == other.token;
  }

  @override
  int get hashCode => token.hashCode;
}

/// An error that happened while the program was being resolved.
sealed class ResolveError implements PintoError {
  Token get token;
}

final class ClassInheritsFromItselfError implements ResolveError {
  const ClassInheritsFromItselfError(this.token);

  @override
  final Token token;
}

// final class ClassInitializerReturnsValueError implements ResolveError {
//   const ClassInitializerReturnsValueError({
//     required this.token,
//     required this.value,
//   });

//   @override
//   final Token token;

//   final Expression value;
// }

final class NoSymbolInScopeError implements ResolveError {
  const NoSymbolInScopeError(this.token);

  @override
  final Token token;
}

final class VariableAlreadyInScopeError implements ResolveError {
  const VariableAlreadyInScopeError(this.token);

  @override
  final Token token;
}

final class VariableInitializerReadsItselfError implements ResolveError {
  const VariableInitializerReadsItselfError(this.token);

  @override
  final Token token;
}

final class ReturnUsedOnTopLevelError implements ResolveError {
  const ReturnUsedOnTopLevelError(this.token);

  @override
  final Token token;
}

final class SuperUsedInAClassWithoutSuperclassError implements ResolveError {
  const SuperUsedInAClassWithoutSuperclassError(this.token);

  @override
  final Token token;
}

final class SuperUsedOutsideOfClassError implements ResolveError {
  const SuperUsedOutsideOfClassError(this.token);

  @override
  final Token token;
}

final class ThisUsedOutsideOfClassError implements ResolveError {
  const ThisUsedOutsideOfClassError(this.token);

  @override
  final Token token;
}

/// An pint° error handler.
final class ErrorHandler {
  final _errors = <PintoError>[];
  final _listeners = <void Function()>[];

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
  /// A listener will be called whenever an erro is emitted. The emmited error
  /// is passed to the listener.
  void addListener(void Function() listener) => _listeners.add(listener);

  /// Removes [listener] from the handler.
  void removeListener(void Function() listener) => _listeners.remove(listener);

  /// Emits an [error].
  ///
  /// The listeners will be notified of the error.
  void emit(PintoError error) {
    _errors.add(error);
    for (final listener in _listeners) {
      listener.call();
    }
  }
}
