// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpectedError {
  SyntacticEntity get syntacticEntity => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;

  /// Create a copy of ExpectedError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectedErrorCopyWith<ExpectedError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectedErrorCopyWith<$Res> {
  factory $ExpectedErrorCopyWith(
          ExpectedError value, $Res Function(ExpectedError) then) =
      _$ExpectedErrorCopyWithImpl<$Res, ExpectedError>;
  @useResult
  $Res call({SyntacticEntity syntacticEntity, ExpectationType expectation});

  $ExpectationTypeCopyWith<$Res> get expectation;
}

/// @nodoc
class _$ExpectedErrorCopyWithImpl<$Res, $Val extends ExpectedError>
    implements $ExpectedErrorCopyWith<$Res> {
  _$ExpectedErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectedError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syntacticEntity = null,
    Object? expectation = null,
  }) {
    return _then(_value.copyWith(
      syntacticEntity: null == syntacticEntity
          ? _value.syntacticEntity
          : syntacticEntity // ignore: cast_nullable_to_non_nullable
              as SyntacticEntity,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ) as $Val);
  }

  /// Create a copy of ExpectedError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExpectErrorImplCopyWith<$Res>
    implements $ExpectedErrorCopyWith<$Res> {
  factory _$$ExpectErrorImplCopyWith(
          _$ExpectErrorImpl value, $Res Function(_$ExpectErrorImpl) then) =
      __$$ExpectErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SyntacticEntity syntacticEntity, ExpectationType expectation});

  @override
  $ExpectationTypeCopyWith<$Res> get expectation;
}

/// @nodoc
class __$$ExpectErrorImplCopyWithImpl<$Res>
    extends _$ExpectedErrorCopyWithImpl<$Res, _$ExpectErrorImpl>
    implements _$$ExpectErrorImplCopyWith<$Res> {
  __$$ExpectErrorImplCopyWithImpl(
      _$ExpectErrorImpl _value, $Res Function(_$ExpectErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectedError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syntacticEntity = null,
    Object? expectation = null,
  }) {
    return _then(_$ExpectErrorImpl(
      syntacticEntity: null == syntacticEntity
          ? _value.syntacticEntity
          : syntacticEntity // ignore: cast_nullable_to_non_nullable
              as SyntacticEntity,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ));
  }
}

/// @nodoc

class _$ExpectErrorImpl extends _ExpectError {
  const _$ExpectErrorImpl(
      {required this.syntacticEntity, required this.expectation})
      : super._();

  @override
  final SyntacticEntity syntacticEntity;
  @override
  final ExpectationType expectation;

  @override
  String toString() {
    return 'ExpectedError(syntacticEntity: $syntacticEntity, expectation: $expectation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectErrorImpl &&
            (identical(other.syntacticEntity, syntacticEntity) ||
                other.syntacticEntity == syntacticEntity) &&
            (identical(other.expectation, expectation) ||
                other.expectation == expectation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, syntacticEntity, expectation);

  /// Create a copy of ExpectedError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectErrorImplCopyWith<_$ExpectErrorImpl> get copyWith =>
      __$$ExpectErrorImplCopyWithImpl<_$ExpectErrorImpl>(this, _$identity);
}

abstract class _ExpectError extends ExpectedError {
  const factory _ExpectError(
      {required final SyntacticEntity syntacticEntity,
      required final ExpectationType expectation}) = _$ExpectErrorImpl;
  const _ExpectError._() : super._();

  @override
  SyntacticEntity get syntacticEntity;
  @override
  ExpectationType get expectation;

  /// Create a copy of ExpectedError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectErrorImplCopyWith<_$ExpectErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectedAfterError {
  SyntacticEntity get syntacticEntity => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;
  ExpectationType get after => throw _privateConstructorUsedError;

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectedAfterErrorCopyWith<ExpectedAfterError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectedAfterErrorCopyWith<$Res> {
  factory $ExpectedAfterErrorCopyWith(
          ExpectedAfterError value, $Res Function(ExpectedAfterError) then) =
      _$ExpectedAfterErrorCopyWithImpl<$Res, ExpectedAfterError>;
  @useResult
  $Res call(
      {SyntacticEntity syntacticEntity,
      ExpectationType expectation,
      ExpectationType after});

  $ExpectationTypeCopyWith<$Res> get expectation;
  $ExpectationTypeCopyWith<$Res> get after;
}

/// @nodoc
class _$ExpectedAfterErrorCopyWithImpl<$Res, $Val extends ExpectedAfterError>
    implements $ExpectedAfterErrorCopyWith<$Res> {
  _$ExpectedAfterErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syntacticEntity = null,
    Object? expectation = null,
    Object? after = null,
  }) {
    return _then(_value.copyWith(
      syntacticEntity: null == syntacticEntity
          ? _value.syntacticEntity
          : syntacticEntity // ignore: cast_nullable_to_non_nullable
              as SyntacticEntity,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
      after: null == after
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ) as $Val);
  }

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get after {
    return $ExpectationTypeCopyWith<$Res>(_value.after, (value) {
      return _then(_value.copyWith(after: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExpectAfterErrorImplCopyWith<$Res>
    implements $ExpectedAfterErrorCopyWith<$Res> {
  factory _$$ExpectAfterErrorImplCopyWith(_$ExpectAfterErrorImpl value,
          $Res Function(_$ExpectAfterErrorImpl) then) =
      __$$ExpectAfterErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SyntacticEntity syntacticEntity,
      ExpectationType expectation,
      ExpectationType after});

  @override
  $ExpectationTypeCopyWith<$Res> get expectation;
  @override
  $ExpectationTypeCopyWith<$Res> get after;
}

/// @nodoc
class __$$ExpectAfterErrorImplCopyWithImpl<$Res>
    extends _$ExpectedAfterErrorCopyWithImpl<$Res, _$ExpectAfterErrorImpl>
    implements _$$ExpectAfterErrorImplCopyWith<$Res> {
  __$$ExpectAfterErrorImplCopyWithImpl(_$ExpectAfterErrorImpl _value,
      $Res Function(_$ExpectAfterErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syntacticEntity = null,
    Object? expectation = null,
    Object? after = null,
  }) {
    return _then(_$ExpectAfterErrorImpl(
      syntacticEntity: null == syntacticEntity
          ? _value.syntacticEntity
          : syntacticEntity // ignore: cast_nullable_to_non_nullable
              as SyntacticEntity,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
      after: null == after
          ? _value.after
          : after // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ));
  }
}

/// @nodoc

class _$ExpectAfterErrorImpl extends _ExpectAfterError {
  const _$ExpectAfterErrorImpl(
      {required this.syntacticEntity,
      required this.expectation,
      required this.after})
      : super._();

  @override
  final SyntacticEntity syntacticEntity;
  @override
  final ExpectationType expectation;
  @override
  final ExpectationType after;

  @override
  String toString() {
    return 'ExpectedAfterError(syntacticEntity: $syntacticEntity, expectation: $expectation, after: $after)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectAfterErrorImpl &&
            (identical(other.syntacticEntity, syntacticEntity) ||
                other.syntacticEntity == syntacticEntity) &&
            (identical(other.expectation, expectation) ||
                other.expectation == expectation) &&
            (identical(other.after, after) || other.after == after));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, syntacticEntity, expectation, after);

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectAfterErrorImplCopyWith<_$ExpectAfterErrorImpl> get copyWith =>
      __$$ExpectAfterErrorImplCopyWithImpl<_$ExpectAfterErrorImpl>(
          this, _$identity);
}

abstract class _ExpectAfterError extends ExpectedAfterError {
  const factory _ExpectAfterError(
      {required final SyntacticEntity syntacticEntity,
      required final ExpectationType expectation,
      required final ExpectationType after}) = _$ExpectAfterErrorImpl;
  const _ExpectAfterError._() : super._();

  @override
  SyntacticEntity get syntacticEntity;
  @override
  ExpectationType get expectation;
  @override
  ExpectationType get after;

  /// Create a copy of ExpectedAfterError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectAfterErrorImplCopyWith<_$ExpectAfterErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectedBeforeError {
  SyntacticEntity get syntacticEntity => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;
  ExpectationType get before => throw _privateConstructorUsedError;

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectedBeforeErrorCopyWith<ExpectedBeforeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectedBeforeErrorCopyWith<$Res> {
  factory $ExpectedBeforeErrorCopyWith(
          ExpectedBeforeError value, $Res Function(ExpectedBeforeError) then) =
      _$ExpectedBeforeErrorCopyWithImpl<$Res, ExpectedBeforeError>;
  @useResult
  $Res call(
      {SyntacticEntity syntacticEntity,
      ExpectationType expectation,
      ExpectationType before});

  $ExpectationTypeCopyWith<$Res> get expectation;
  $ExpectationTypeCopyWith<$Res> get before;
}

/// @nodoc
class _$ExpectedBeforeErrorCopyWithImpl<$Res, $Val extends ExpectedBeforeError>
    implements $ExpectedBeforeErrorCopyWith<$Res> {
  _$ExpectedBeforeErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syntacticEntity = null,
    Object? expectation = null,
    Object? before = null,
  }) {
    return _then(_value.copyWith(
      syntacticEntity: null == syntacticEntity
          ? _value.syntacticEntity
          : syntacticEntity // ignore: cast_nullable_to_non_nullable
              as SyntacticEntity,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
      before: null == before
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ) as $Val);
  }

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get before {
    return $ExpectationTypeCopyWith<$Res>(_value.before, (value) {
      return _then(_value.copyWith(before: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExpectBeforeErrorImplCopyWith<$Res>
    implements $ExpectedBeforeErrorCopyWith<$Res> {
  factory _$$ExpectBeforeErrorImplCopyWith(_$ExpectBeforeErrorImpl value,
          $Res Function(_$ExpectBeforeErrorImpl) then) =
      __$$ExpectBeforeErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SyntacticEntity syntacticEntity,
      ExpectationType expectation,
      ExpectationType before});

  @override
  $ExpectationTypeCopyWith<$Res> get expectation;
  @override
  $ExpectationTypeCopyWith<$Res> get before;
}

/// @nodoc
class __$$ExpectBeforeErrorImplCopyWithImpl<$Res>
    extends _$ExpectedBeforeErrorCopyWithImpl<$Res, _$ExpectBeforeErrorImpl>
    implements _$$ExpectBeforeErrorImplCopyWith<$Res> {
  __$$ExpectBeforeErrorImplCopyWithImpl(_$ExpectBeforeErrorImpl _value,
      $Res Function(_$ExpectBeforeErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syntacticEntity = null,
    Object? expectation = null,
    Object? before = null,
  }) {
    return _then(_$ExpectBeforeErrorImpl(
      syntacticEntity: null == syntacticEntity
          ? _value.syntacticEntity
          : syntacticEntity // ignore: cast_nullable_to_non_nullable
              as SyntacticEntity,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
      before: null == before
          ? _value.before
          : before // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ));
  }
}

/// @nodoc

class _$ExpectBeforeErrorImpl extends _ExpectBeforeError {
  const _$ExpectBeforeErrorImpl(
      {required this.syntacticEntity,
      required this.expectation,
      required this.before})
      : super._();

  @override
  final SyntacticEntity syntacticEntity;
  @override
  final ExpectationType expectation;
  @override
  final ExpectationType before;

  @override
  String toString() {
    return 'ExpectedBeforeError(syntacticEntity: $syntacticEntity, expectation: $expectation, before: $before)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectBeforeErrorImpl &&
            (identical(other.syntacticEntity, syntacticEntity) ||
                other.syntacticEntity == syntacticEntity) &&
            (identical(other.expectation, expectation) ||
                other.expectation == expectation) &&
            (identical(other.before, before) || other.before == before));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, syntacticEntity, expectation, before);

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectBeforeErrorImplCopyWith<_$ExpectBeforeErrorImpl> get copyWith =>
      __$$ExpectBeforeErrorImplCopyWithImpl<_$ExpectBeforeErrorImpl>(
          this, _$identity);
}

abstract class _ExpectBeforeError extends ExpectedBeforeError {
  const factory _ExpectBeforeError(
      {required final SyntacticEntity syntacticEntity,
      required final ExpectationType expectation,
      required final ExpectationType before}) = _$ExpectBeforeErrorImpl;
  const _ExpectBeforeError._() : super._();

  @override
  SyntacticEntity get syntacticEntity;
  @override
  ExpectationType get expectation;
  @override
  ExpectationType get before;

  /// Create a copy of ExpectedBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectBeforeErrorImplCopyWith<_$ExpectBeforeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectationType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Declaration? declaration) declaration,
    required TResult Function(Expression? expression) expression,
    required TResult Function(List<ExpectationType> expectations) oneOf,
    required TResult Function(TokenType token, String? description) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Declaration? declaration)? declaration,
    TResult? Function(Expression? expression)? expression,
    TResult? Function(List<ExpectationType> expectations)? oneOf,
    TResult? Function(TokenType token, String? description)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Declaration? declaration)? declaration,
    TResult Function(Expression? expression)? expression,
    TResult Function(List<ExpectationType> expectations)? oneOf,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeclarationExpectation value) declaration,
    required TResult Function(ExpressionExpectation value) expression,
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(TokenExpectation value) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeclarationExpectation value)? declaration,
    TResult? Function(ExpressionExpectation value)? expression,
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(TokenExpectation value)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeclarationExpectation value)? declaration,
    TResult Function(ExpressionExpectation value)? expression,
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectationTypeCopyWith<$Res> {
  factory $ExpectationTypeCopyWith(
          ExpectationType value, $Res Function(ExpectationType) then) =
      _$ExpectationTypeCopyWithImpl<$Res, ExpectationType>;
}

/// @nodoc
class _$ExpectationTypeCopyWithImpl<$Res, $Val extends ExpectationType>
    implements $ExpectationTypeCopyWith<$Res> {
  _$ExpectationTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DeclarationExpectationImplCopyWith<$Res> {
  factory _$$DeclarationExpectationImplCopyWith(
          _$DeclarationExpectationImpl value,
          $Res Function(_$DeclarationExpectationImpl) then) =
      __$$DeclarationExpectationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Declaration? declaration});
}

/// @nodoc
class __$$DeclarationExpectationImplCopyWithImpl<$Res>
    extends _$ExpectationTypeCopyWithImpl<$Res, _$DeclarationExpectationImpl>
    implements _$$DeclarationExpectationImplCopyWith<$Res> {
  __$$DeclarationExpectationImplCopyWithImpl(
      _$DeclarationExpectationImpl _value,
      $Res Function(_$DeclarationExpectationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? declaration = freezed,
  }) {
    return _then(_$DeclarationExpectationImpl(
      declaration: freezed == declaration
          ? _value.declaration
          : declaration // ignore: cast_nullable_to_non_nullable
              as Declaration?,
    ));
  }
}

/// @nodoc

class _$DeclarationExpectationImpl extends DeclarationExpectation {
  const _$DeclarationExpectationImpl({this.declaration}) : super._();

  @override
  final Declaration? declaration;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeclarationExpectationImpl &&
            (identical(other.declaration, declaration) ||
                other.declaration == declaration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, declaration);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeclarationExpectationImplCopyWith<_$DeclarationExpectationImpl>
      get copyWith => __$$DeclarationExpectationImplCopyWithImpl<
          _$DeclarationExpectationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Declaration? declaration) declaration,
    required TResult Function(Expression? expression) expression,
    required TResult Function(List<ExpectationType> expectations) oneOf,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return declaration(this.declaration);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Declaration? declaration)? declaration,
    TResult? Function(Expression? expression)? expression,
    TResult? Function(List<ExpectationType> expectations)? oneOf,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return declaration?.call(this.declaration);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Declaration? declaration)? declaration,
    TResult Function(Expression? expression)? expression,
    TResult Function(List<ExpectationType> expectations)? oneOf,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (declaration != null) {
      return declaration(this.declaration);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeclarationExpectation value) declaration,
    required TResult Function(ExpressionExpectation value) expression,
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(TokenExpectation value) token,
  }) {
    return declaration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeclarationExpectation value)? declaration,
    TResult? Function(ExpressionExpectation value)? expression,
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return declaration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeclarationExpectation value)? declaration,
    TResult Function(ExpressionExpectation value)? expression,
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) {
    if (declaration != null) {
      return declaration(this);
    }
    return orElse();
  }
}

abstract class DeclarationExpectation extends ExpectationType {
  const factory DeclarationExpectation({final Declaration? declaration}) =
      _$DeclarationExpectationImpl;
  const DeclarationExpectation._() : super._();

  Declaration? get declaration;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeclarationExpectationImplCopyWith<_$DeclarationExpectationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExpressionExpectationImplCopyWith<$Res> {
  factory _$$ExpressionExpectationImplCopyWith(
          _$ExpressionExpectationImpl value,
          $Res Function(_$ExpressionExpectationImpl) then) =
      __$$ExpressionExpectationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Expression? expression});
}

/// @nodoc
class __$$ExpressionExpectationImplCopyWithImpl<$Res>
    extends _$ExpectationTypeCopyWithImpl<$Res, _$ExpressionExpectationImpl>
    implements _$$ExpressionExpectationImplCopyWith<$Res> {
  __$$ExpressionExpectationImplCopyWithImpl(_$ExpressionExpectationImpl _value,
      $Res Function(_$ExpressionExpectationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expression = freezed,
  }) {
    return _then(_$ExpressionExpectationImpl(
      expression: freezed == expression
          ? _value.expression
          : expression // ignore: cast_nullable_to_non_nullable
              as Expression?,
    ));
  }
}

/// @nodoc

class _$ExpressionExpectationImpl extends ExpressionExpectation {
  const _$ExpressionExpectationImpl({this.expression}) : super._();

  @override
  final Expression? expression;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpressionExpectationImpl &&
            (identical(other.expression, expression) ||
                other.expression == expression));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expression);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpressionExpectationImplCopyWith<_$ExpressionExpectationImpl>
      get copyWith => __$$ExpressionExpectationImplCopyWithImpl<
          _$ExpressionExpectationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Declaration? declaration) declaration,
    required TResult Function(Expression? expression) expression,
    required TResult Function(List<ExpectationType> expectations) oneOf,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return expression(this.expression);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Declaration? declaration)? declaration,
    TResult? Function(Expression? expression)? expression,
    TResult? Function(List<ExpectationType> expectations)? oneOf,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return expression?.call(this.expression);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Declaration? declaration)? declaration,
    TResult Function(Expression? expression)? expression,
    TResult Function(List<ExpectationType> expectations)? oneOf,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (expression != null) {
      return expression(this.expression);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeclarationExpectation value) declaration,
    required TResult Function(ExpressionExpectation value) expression,
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(TokenExpectation value) token,
  }) {
    return expression(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeclarationExpectation value)? declaration,
    TResult? Function(ExpressionExpectation value)? expression,
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return expression?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeclarationExpectation value)? declaration,
    TResult Function(ExpressionExpectation value)? expression,
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) {
    if (expression != null) {
      return expression(this);
    }
    return orElse();
  }
}

abstract class ExpressionExpectation extends ExpectationType {
  const factory ExpressionExpectation({final Expression? expression}) =
      _$ExpressionExpectationImpl;
  const ExpressionExpectation._() : super._();

  Expression? get expression;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpressionExpectationImplCopyWith<_$ExpressionExpectationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OneOfExpectationImplCopyWith<$Res> {
  factory _$$OneOfExpectationImplCopyWith(_$OneOfExpectationImpl value,
          $Res Function(_$OneOfExpectationImpl) then) =
      __$$OneOfExpectationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ExpectationType> expectations});
}

/// @nodoc
class __$$OneOfExpectationImplCopyWithImpl<$Res>
    extends _$ExpectationTypeCopyWithImpl<$Res, _$OneOfExpectationImpl>
    implements _$$OneOfExpectationImplCopyWith<$Res> {
  __$$OneOfExpectationImplCopyWithImpl(_$OneOfExpectationImpl _value,
      $Res Function(_$OneOfExpectationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expectations = null,
  }) {
    return _then(_$OneOfExpectationImpl(
      expectations: null == expectations
          ? _value._expectations
          : expectations // ignore: cast_nullable_to_non_nullable
              as List<ExpectationType>,
    ));
  }
}

/// @nodoc

class _$OneOfExpectationImpl extends OneOfExpectation {
  const _$OneOfExpectationImpl(
      {required final List<ExpectationType> expectations})
      : _expectations = expectations,
        super._();

  final List<ExpectationType> _expectations;
  @override
  List<ExpectationType> get expectations {
    if (_expectations is EqualUnmodifiableListView) return _expectations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expectations);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OneOfExpectationImpl &&
            const DeepCollectionEquality()
                .equals(other._expectations, _expectations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_expectations));

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OneOfExpectationImplCopyWith<_$OneOfExpectationImpl> get copyWith =>
      __$$OneOfExpectationImplCopyWithImpl<_$OneOfExpectationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Declaration? declaration) declaration,
    required TResult Function(Expression? expression) expression,
    required TResult Function(List<ExpectationType> expectations) oneOf,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return oneOf(expectations);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Declaration? declaration)? declaration,
    TResult? Function(Expression? expression)? expression,
    TResult? Function(List<ExpectationType> expectations)? oneOf,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return oneOf?.call(expectations);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Declaration? declaration)? declaration,
    TResult Function(Expression? expression)? expression,
    TResult Function(List<ExpectationType> expectations)? oneOf,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (oneOf != null) {
      return oneOf(expectations);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeclarationExpectation value) declaration,
    required TResult Function(ExpressionExpectation value) expression,
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(TokenExpectation value) token,
  }) {
    return oneOf(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeclarationExpectation value)? declaration,
    TResult? Function(ExpressionExpectation value)? expression,
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return oneOf?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeclarationExpectation value)? declaration,
    TResult Function(ExpressionExpectation value)? expression,
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) {
    if (oneOf != null) {
      return oneOf(this);
    }
    return orElse();
  }
}

abstract class OneOfExpectation extends ExpectationType {
  const factory OneOfExpectation(
          {required final List<ExpectationType> expectations}) =
      _$OneOfExpectationImpl;
  const OneOfExpectation._() : super._();

  List<ExpectationType> get expectations;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OneOfExpectationImplCopyWith<_$OneOfExpectationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TokenExpectationImplCopyWith<$Res> {
  factory _$$TokenExpectationImplCopyWith(_$TokenExpectationImpl value,
          $Res Function(_$TokenExpectationImpl) then) =
      __$$TokenExpectationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TokenType token, String? description});
}

/// @nodoc
class __$$TokenExpectationImplCopyWithImpl<$Res>
    extends _$ExpectationTypeCopyWithImpl<$Res, _$TokenExpectationImpl>
    implements _$$TokenExpectationImplCopyWith<$Res> {
  __$$TokenExpectationImplCopyWithImpl(_$TokenExpectationImpl _value,
      $Res Function(_$TokenExpectationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? description = freezed,
  }) {
    return _then(_$TokenExpectationImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as TokenType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TokenExpectationImpl extends TokenExpectation {
  const _$TokenExpectationImpl({required this.token, this.description})
      : super._();

  @override
  final TokenType token;
  @override
  final String? description;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenExpectationImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, description);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenExpectationImplCopyWith<_$TokenExpectationImpl> get copyWith =>
      __$$TokenExpectationImplCopyWithImpl<_$TokenExpectationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Declaration? declaration) declaration,
    required TResult Function(Expression? expression) expression,
    required TResult Function(List<ExpectationType> expectations) oneOf,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return token(this.token, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Declaration? declaration)? declaration,
    TResult? Function(Expression? expression)? expression,
    TResult? Function(List<ExpectationType> expectations)? oneOf,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return token?.call(this.token, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Declaration? declaration)? declaration,
    TResult Function(Expression? expression)? expression,
    TResult Function(List<ExpectationType> expectations)? oneOf,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (token != null) {
      return token(this.token, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeclarationExpectation value) declaration,
    required TResult Function(ExpressionExpectation value) expression,
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(TokenExpectation value) token,
  }) {
    return token(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DeclarationExpectation value)? declaration,
    TResult? Function(ExpressionExpectation value)? expression,
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return token?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeclarationExpectation value)? declaration,
    TResult Function(ExpressionExpectation value)? expression,
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) {
    if (token != null) {
      return token(this);
    }
    return orElse();
  }
}

abstract class TokenExpectation extends ExpectationType {
  const factory TokenExpectation(
      {required final TokenType token,
      final String? description}) = _$TokenExpectationImpl;
  const TokenExpectation._() : super._();

  TokenType get token;
  String? get description;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenExpectationImplCopyWith<_$TokenExpectationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
