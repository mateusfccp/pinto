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
mixin _$ExpectError {
  SyntacticEntity get syntacticEntity => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;

  /// Create a copy of ExpectError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectErrorCopyWith<ExpectError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectErrorCopyWith<$Res> {
  factory $ExpectErrorCopyWith(
          ExpectError value, $Res Function(ExpectError) then) =
      _$ExpectErrorCopyWithImpl<$Res, ExpectError>;
  @useResult
  $Res call({SyntacticEntity syntacticEntity, ExpectationType expectation});

  $ExpectationTypeCopyWith<$Res> get expectation;
}

/// @nodoc
class _$ExpectErrorCopyWithImpl<$Res, $Val extends ExpectError>
    implements $ExpectErrorCopyWith<$Res> {
  _$ExpectErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectError
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

  /// Create a copy of ExpectError
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
    implements $ExpectErrorCopyWith<$Res> {
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
    extends _$ExpectErrorCopyWithImpl<$Res, _$ExpectErrorImpl>
    implements _$$ExpectErrorImplCopyWith<$Res> {
  __$$ExpectErrorImplCopyWithImpl(
      _$ExpectErrorImpl _value, $Res Function(_$ExpectErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectError
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

class _$ExpectErrorImpl implements _ExpectError {
  const _$ExpectErrorImpl(
      {required this.syntacticEntity, required this.expectation});

  @override
  final SyntacticEntity syntacticEntity;
  @override
  final ExpectationType expectation;

  @override
  String toString() {
    return 'ExpectError(syntacticEntity: $syntacticEntity, expectation: $expectation)';
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

  /// Create a copy of ExpectError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectErrorImplCopyWith<_$ExpectErrorImpl> get copyWith =>
      __$$ExpectErrorImplCopyWithImpl<_$ExpectErrorImpl>(this, _$identity);
}

abstract class _ExpectError implements ExpectError {
  const factory _ExpectError(
      {required final SyntacticEntity syntacticEntity,
      required final ExpectationType expectation}) = _$ExpectErrorImpl;

  @override
  SyntacticEntity get syntacticEntity;
  @override
  ExpectationType get expectation;

  /// Create a copy of ExpectError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectErrorImplCopyWith<_$ExpectErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectAfterError {
  SyntacticEntity get syntacticEntity => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;
  ExpectationType get after => throw _privateConstructorUsedError;

  /// Create a copy of ExpectAfterError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectAfterErrorCopyWith<ExpectAfterError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectAfterErrorCopyWith<$Res> {
  factory $ExpectAfterErrorCopyWith(
          ExpectAfterError value, $Res Function(ExpectAfterError) then) =
      _$ExpectAfterErrorCopyWithImpl<$Res, ExpectAfterError>;
  @useResult
  $Res call(
      {SyntacticEntity syntacticEntity,
      ExpectationType expectation,
      ExpectationType after});

  $ExpectationTypeCopyWith<$Res> get expectation;
  $ExpectationTypeCopyWith<$Res> get after;
}

/// @nodoc
class _$ExpectAfterErrorCopyWithImpl<$Res, $Val extends ExpectAfterError>
    implements $ExpectAfterErrorCopyWith<$Res> {
  _$ExpectAfterErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectAfterError
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

  /// Create a copy of ExpectAfterError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }

  /// Create a copy of ExpectAfterError
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
    implements $ExpectAfterErrorCopyWith<$Res> {
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
    extends _$ExpectAfterErrorCopyWithImpl<$Res, _$ExpectAfterErrorImpl>
    implements _$$ExpectAfterErrorImplCopyWith<$Res> {
  __$$ExpectAfterErrorImplCopyWithImpl(_$ExpectAfterErrorImpl _value,
      $Res Function(_$ExpectAfterErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectAfterError
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

class _$ExpectAfterErrorImpl implements _ExpectAfterError {
  const _$ExpectAfterErrorImpl(
      {required this.syntacticEntity,
      required this.expectation,
      required this.after});

  @override
  final SyntacticEntity syntacticEntity;
  @override
  final ExpectationType expectation;
  @override
  final ExpectationType after;

  @override
  String toString() {
    return 'ExpectAfterError(syntacticEntity: $syntacticEntity, expectation: $expectation, after: $after)';
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

  /// Create a copy of ExpectAfterError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectAfterErrorImplCopyWith<_$ExpectAfterErrorImpl> get copyWith =>
      __$$ExpectAfterErrorImplCopyWithImpl<_$ExpectAfterErrorImpl>(
          this, _$identity);
}

abstract class _ExpectAfterError implements ExpectAfterError {
  const factory _ExpectAfterError(
      {required final SyntacticEntity syntacticEntity,
      required final ExpectationType expectation,
      required final ExpectationType after}) = _$ExpectAfterErrorImpl;

  @override
  SyntacticEntity get syntacticEntity;
  @override
  ExpectationType get expectation;
  @override
  ExpectationType get after;

  /// Create a copy of ExpectAfterError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectAfterErrorImplCopyWith<_$ExpectAfterErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectBeforeError {
  SyntacticEntity get syntacticEntity => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;
  ExpectationType get before => throw _privateConstructorUsedError;

  /// Create a copy of ExpectBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectBeforeErrorCopyWith<ExpectBeforeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectBeforeErrorCopyWith<$Res> {
  factory $ExpectBeforeErrorCopyWith(
          ExpectBeforeError value, $Res Function(ExpectBeforeError) then) =
      _$ExpectBeforeErrorCopyWithImpl<$Res, ExpectBeforeError>;
  @useResult
  $Res call(
      {SyntacticEntity syntacticEntity,
      ExpectationType expectation,
      ExpectationType before});

  $ExpectationTypeCopyWith<$Res> get expectation;
  $ExpectationTypeCopyWith<$Res> get before;
}

/// @nodoc
class _$ExpectBeforeErrorCopyWithImpl<$Res, $Val extends ExpectBeforeError>
    implements $ExpectBeforeErrorCopyWith<$Res> {
  _$ExpectBeforeErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectBeforeError
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

  /// Create a copy of ExpectBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }

  /// Create a copy of ExpectBeforeError
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
    implements $ExpectBeforeErrorCopyWith<$Res> {
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
    extends _$ExpectBeforeErrorCopyWithImpl<$Res, _$ExpectBeforeErrorImpl>
    implements _$$ExpectBeforeErrorImplCopyWith<$Res> {
  __$$ExpectBeforeErrorImplCopyWithImpl(_$ExpectBeforeErrorImpl _value,
      $Res Function(_$ExpectBeforeErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectBeforeError
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

class _$ExpectBeforeErrorImpl implements _ExpectBeforeError {
  const _$ExpectBeforeErrorImpl(
      {required this.syntacticEntity,
      required this.expectation,
      required this.before});

  @override
  final SyntacticEntity syntacticEntity;
  @override
  final ExpectationType expectation;
  @override
  final ExpectationType before;

  @override
  String toString() {
    return 'ExpectBeforeError(syntacticEntity: $syntacticEntity, expectation: $expectation, before: $before)';
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

  /// Create a copy of ExpectBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectBeforeErrorImplCopyWith<_$ExpectBeforeErrorImpl> get copyWith =>
      __$$ExpectBeforeErrorImplCopyWithImpl<_$ExpectBeforeErrorImpl>(
          this, _$identity);
}

abstract class _ExpectBeforeError implements ExpectBeforeError {
  const factory _ExpectBeforeError(
      {required final SyntacticEntity syntacticEntity,
      required final ExpectationType expectation,
      required final ExpectationType before}) = _$ExpectBeforeErrorImpl;

  @override
  SyntacticEntity get syntacticEntity;
  @override
  ExpectationType get expectation;
  @override
  ExpectationType get before;

  /// Create a copy of ExpectBeforeError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectBeforeErrorImplCopyWith<_$ExpectBeforeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectationType {
  String? get description => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<ExpectationType> expectations, String? description)
        oneOf,
    required TResult Function(Declaration declaration, String? description)
        declaration,
    required TResult Function(TokenType token, String? description) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Declaration declaration, String? description)?
        declaration,
    TResult? Function(TokenType token, String? description)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Declaration declaration, String? description)? declaration,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(StatementExpectation value) declaration,
    required TResult Function(TokenExpectation value) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? declaration,
    TResult? Function(TokenExpectation value)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? declaration,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectationTypeCopyWith<ExpectationType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectationTypeCopyWith<$Res> {
  factory $ExpectationTypeCopyWith(
          ExpectationType value, $Res Function(ExpectationType) then) =
      _$ExpectationTypeCopyWithImpl<$Res, ExpectationType>;
  @useResult
  $Res call({String? description});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OneOfExpectationImplCopyWith<$Res>
    implements $ExpectationTypeCopyWith<$Res> {
  factory _$$OneOfExpectationImplCopyWith(_$OneOfExpectationImpl value,
          $Res Function(_$OneOfExpectationImpl) then) =
      __$$OneOfExpectationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ExpectationType> expectations, String? description});
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
    Object? description = freezed,
  }) {
    return _then(_$OneOfExpectationImpl(
      expectations: null == expectations
          ? _value._expectations
          : expectations // ignore: cast_nullable_to_non_nullable
              as List<ExpectationType>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OneOfExpectationImpl extends OneOfExpectation {
  const _$OneOfExpectationImpl(
      {required final List<ExpectationType> expectations, this.description})
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
  final String? description;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OneOfExpectationImpl &&
            const DeepCollectionEquality()
                .equals(other._expectations, _expectations) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_expectations), description);

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
    required TResult Function(
            List<ExpectationType> expectations, String? description)
        oneOf,
    required TResult Function(Declaration declaration, String? description)
        declaration,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return oneOf(expectations, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Declaration declaration, String? description)?
        declaration,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return oneOf?.call(expectations, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Declaration declaration, String? description)? declaration,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (oneOf != null) {
      return oneOf(expectations, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(StatementExpectation value) declaration,
    required TResult Function(TokenExpectation value) token,
  }) {
    return oneOf(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? declaration,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return oneOf?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? declaration,
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
      {required final List<ExpectationType> expectations,
      final String? description}) = _$OneOfExpectationImpl;
  const OneOfExpectation._() : super._();

  List<ExpectationType> get expectations;
  @override
  String? get description;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OneOfExpectationImplCopyWith<_$OneOfExpectationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StatementExpectationImplCopyWith<$Res>
    implements $ExpectationTypeCopyWith<$Res> {
  factory _$$StatementExpectationImplCopyWith(_$StatementExpectationImpl value,
          $Res Function(_$StatementExpectationImpl) then) =
      __$$StatementExpectationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Declaration declaration, String? description});
}

/// @nodoc
class __$$StatementExpectationImplCopyWithImpl<$Res>
    extends _$ExpectationTypeCopyWithImpl<$Res, _$StatementExpectationImpl>
    implements _$$StatementExpectationImplCopyWith<$Res> {
  __$$StatementExpectationImplCopyWithImpl(_$StatementExpectationImpl _value,
      $Res Function(_$StatementExpectationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? declaration = null,
    Object? description = freezed,
  }) {
    return _then(_$StatementExpectationImpl(
      declaration: null == declaration
          ? _value.declaration
          : declaration // ignore: cast_nullable_to_non_nullable
              as Declaration,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StatementExpectationImpl extends StatementExpectation {
  const _$StatementExpectationImpl(
      {required this.declaration, this.description})
      : super._();

  @override
  final Declaration declaration;
  @override
  final String? description;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatementExpectationImpl &&
            (identical(other.declaration, declaration) ||
                other.declaration == declaration) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, declaration, description);

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatementExpectationImplCopyWith<_$StatementExpectationImpl>
      get copyWith =>
          __$$StatementExpectationImplCopyWithImpl<_$StatementExpectationImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<ExpectationType> expectations, String? description)
        oneOf,
    required TResult Function(Declaration declaration, String? description)
        declaration,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return declaration(this.declaration, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Declaration declaration, String? description)?
        declaration,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return declaration?.call(this.declaration, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Declaration declaration, String? description)? declaration,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (declaration != null) {
      return declaration(this.declaration, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(StatementExpectation value) declaration,
    required TResult Function(TokenExpectation value) token,
  }) {
    return declaration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? declaration,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return declaration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? declaration,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) {
    if (declaration != null) {
      return declaration(this);
    }
    return orElse();
  }
}

abstract class StatementExpectation extends ExpectationType {
  const factory StatementExpectation(
      {required final Declaration declaration,
      final String? description}) = _$StatementExpectationImpl;
  const StatementExpectation._() : super._();

  Declaration get declaration;
  @override
  String? get description;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatementExpectationImplCopyWith<_$StatementExpectationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TokenExpectationImplCopyWith<$Res>
    implements $ExpectationTypeCopyWith<$Res> {
  factory _$$TokenExpectationImplCopyWith(_$TokenExpectationImpl value,
          $Res Function(_$TokenExpectationImpl) then) =
      __$$TokenExpectationImplCopyWithImpl<$Res>;
  @override
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
    required TResult Function(
            List<ExpectationType> expectations, String? description)
        oneOf,
    required TResult Function(Declaration declaration, String? description)
        declaration,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return token(this.token, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Declaration declaration, String? description)?
        declaration,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return token?.call(this.token, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Declaration declaration, String? description)? declaration,
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
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(StatementExpectation value) declaration,
    required TResult Function(TokenExpectation value) token,
  }) {
    return token(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? declaration,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return token?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? declaration,
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
  @override
  String? get description;

  /// Create a copy of ExpectationType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenExpectationImplCopyWith<_$TokenExpectationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
