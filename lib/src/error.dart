import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

// import 'expression.dart';
import 'statement.dart';
import 'token.dart';

part 'error.freezed.dart';

/// A Lox error.
sealed class LoxError {}

/// An error that happened while the program was being scanend.
sealed class ScanError implements LoxError {
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
sealed class ParseError implements LoxError {
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
sealed class ResolveError implements LoxError {
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

/// An error that happened while the program was being run.
sealed class RuntimeError implements LoxError {
  const RuntimeError(this.token);

  final Token token;
}

final class ArityError implements RuntimeError {
  const ArityError({
    required this.token,
    required this.arity,
    required this.argumentsCount,
  });

  @override
  final Token token;

  /// The expected arity for the function/method call.
  final int arity;

  /// The number of arguments passed to the function/method call.
  final int argumentsCount;
}

final class ClassInheritsFromANonClassError implements RuntimeError {
  const ClassInheritsFromANonClassError(this.token);

  @override
  final Token token;
}

final class InvalidOperandsForNumericBinaryOperatorsError implements RuntimeError {
  const InvalidOperandsForNumericBinaryOperatorsError({
    required this.token,
    required this.left,
    required this.right,
  });

  @override
  final Token token;

  final Object? left;
  final Object? right;
}

final class InvalidOperandForUnaryMinusOperatorError implements RuntimeError {
  const InvalidOperandForUnaryMinusOperatorError({
    required this.token,
    required this.right,
  });

  @override
  final Token token;

  final Object? right;
}

final class InvalidOperandsForPlusOperatorError implements RuntimeError {
  const InvalidOperandsForPlusOperatorError({
    required this.token,
    required this.left,
    required this.right,
  });

  @override
  final Token token;

  final Object? left;
  final Object? right;
}

final class NonRoutineCalledError implements RuntimeError {
  const NonRoutineCalledError({
    required this.token,
    required this.callee,
  });

  @override
  final Token token;

  final Object? callee;
}

final class NonInstanceTriedToGetFieldError implements RuntimeError {
  const NonInstanceTriedToGetFieldError({
    required this.token,
    required this.caller,
  });

  @override
  final Token token;

  final Object? caller;
}

final class NonInstanceTriedToSetFieldError implements RuntimeError {
  const NonInstanceTriedToSetFieldError({
    required this.token,
    required this.caller,
  });

  @override
  final Token token;

  final Object? caller;
}

final class UndefinedPropertyError implements RuntimeError {
  const UndefinedPropertyError(this.token);

  @override
  final Token token;
}

final class UndefinedVariableError implements RuntimeError {
  const UndefinedVariableError(this.token);

  @override
  final Token token;
}

/// An Lox error handler.
final class ErrorHandler {
  final _errors = <LoxError>[];
  final _listeners = <void Function()>[];

  /// The errors that were emitted by the handler.
  UnmodifiableListView<LoxError> get errors => UnmodifiableListView(_errors);

  /// Whether at least one error was emitted.
  bool get hasError => _errors.isNotEmpty;

  /// The last emitted error.
  ///
  /// If no error was emitted, `null` is returned.
  LoxError? get lastError => hasError ? _errors[_errors.length - 1] : null;

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
  void emit(LoxError error) {
    _errors.add(error);
    for (final listener in _listeners) {
      listener.call();
    }
  }
}
