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
mixin _$ScanLocation {
  int get offset => throw _privateConstructorUsedError;
  int get line => throw _privateConstructorUsedError;
  int get column => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScanLocationCopyWith<ScanLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanLocationCopyWith<$Res> {
  factory $ScanLocationCopyWith(
          ScanLocation value, $Res Function(ScanLocation) then) =
      _$ScanLocationCopyWithImpl<$Res, ScanLocation>;
  @useResult
  $Res call({int offset, int line, int column});
}

/// @nodoc
class _$ScanLocationCopyWithImpl<$Res, $Val extends ScanLocation>
    implements $ScanLocationCopyWith<$Res> {
  _$ScanLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? line = null,
    Object? column = null,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      line: null == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int,
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanLocationImplCopyWith<$Res>
    implements $ScanLocationCopyWith<$Res> {
  factory _$$ScanLocationImplCopyWith(
          _$ScanLocationImpl value, $Res Function(_$ScanLocationImpl) then) =
      __$$ScanLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int offset, int line, int column});
}

/// @nodoc
class __$$ScanLocationImplCopyWithImpl<$Res>
    extends _$ScanLocationCopyWithImpl<$Res, _$ScanLocationImpl>
    implements _$$ScanLocationImplCopyWith<$Res> {
  __$$ScanLocationImplCopyWithImpl(
      _$ScanLocationImpl _value, $Res Function(_$ScanLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? line = null,
    Object? column = null,
  }) {
    return _then(_$ScanLocationImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      line: null == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int,
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ScanLocationImpl implements _ScanLocation {
  const _$ScanLocationImpl(
      {required this.offset, required this.line, required this.column});

  @override
  final int offset;
  @override
  final int line;
  @override
  final int column;

  @override
  String toString() {
    return 'ScanLocation(offset: $offset, line: $line, column: $column)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanLocationImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.column, column) || other.column == column));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offset, line, column);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanLocationImplCopyWith<_$ScanLocationImpl> get copyWith =>
      __$$ScanLocationImplCopyWithImpl<_$ScanLocationImpl>(this, _$identity);
}

abstract class _ScanLocation implements ScanLocation {
  const factory _ScanLocation(
      {required final int offset,
      required final int line,
      required final int column}) = _$ScanLocationImpl;

  @override
  int get offset;
  @override
  int get line;
  @override
  int get column;
  @override
  @JsonKey(ignore: true)
  _$$ScanLocationImplCopyWith<_$ScanLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectError {
  Token get token => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpectErrorCopyWith<ExpectError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectErrorCopyWith<$Res> {
  factory $ExpectErrorCopyWith(
          ExpectError value, $Res Function(ExpectError) then) =
      _$ExpectErrorCopyWithImpl<$Res, ExpectError>;
  @useResult
  $Res call({Token token, ExpectationType expectation});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expectation = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ) as $Val);
  }

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
  $Res call({Token token, ExpectationType expectation});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expectation = null,
  }) {
    return _then(_$ExpectErrorImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token,
      expectation: null == expectation
          ? _value.expectation
          : expectation // ignore: cast_nullable_to_non_nullable
              as ExpectationType,
    ));
  }
}

/// @nodoc

class _$ExpectErrorImpl implements _ExpectError {
  const _$ExpectErrorImpl({required this.token, required this.expectation});

  @override
  final Token token;
  @override
  final ExpectationType expectation;

  @override
  String toString() {
    return 'ExpectError(token: $token, expectation: $expectation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectErrorImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expectation, expectation) ||
                other.expectation == expectation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, expectation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectErrorImplCopyWith<_$ExpectErrorImpl> get copyWith =>
      __$$ExpectErrorImplCopyWithImpl<_$ExpectErrorImpl>(this, _$identity);
}

abstract class _ExpectError implements ExpectError {
  const factory _ExpectError(
      {required final Token token,
      required final ExpectationType expectation}) = _$ExpectErrorImpl;

  @override
  Token get token;
  @override
  ExpectationType get expectation;
  @override
  @JsonKey(ignore: true)
  _$$ExpectErrorImplCopyWith<_$ExpectErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectAfterError {
  Token get token => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;
  ExpectationType get after => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpectAfterErrorCopyWith<ExpectAfterError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectAfterErrorCopyWith<$Res> {
  factory $ExpectAfterErrorCopyWith(
          ExpectAfterError value, $Res Function(ExpectAfterError) then) =
      _$ExpectAfterErrorCopyWithImpl<$Res, ExpectAfterError>;
  @useResult
  $Res call({Token token, ExpectationType expectation, ExpectationType after});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expectation = null,
    Object? after = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token,
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

  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }

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
  $Res call({Token token, ExpectationType expectation, ExpectationType after});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expectation = null,
    Object? after = null,
  }) {
    return _then(_$ExpectAfterErrorImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token,
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
      {required this.token, required this.expectation, required this.after});

  @override
  final Token token;
  @override
  final ExpectationType expectation;
  @override
  final ExpectationType after;

  @override
  String toString() {
    return 'ExpectAfterError(token: $token, expectation: $expectation, after: $after)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectAfterErrorImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expectation, expectation) ||
                other.expectation == expectation) &&
            (identical(other.after, after) || other.after == after));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, expectation, after);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectAfterErrorImplCopyWith<_$ExpectAfterErrorImpl> get copyWith =>
      __$$ExpectAfterErrorImplCopyWithImpl<_$ExpectAfterErrorImpl>(
          this, _$identity);
}

abstract class _ExpectAfterError implements ExpectAfterError {
  const factory _ExpectAfterError(
      {required final Token token,
      required final ExpectationType expectation,
      required final ExpectationType after}) = _$ExpectAfterErrorImpl;

  @override
  Token get token;
  @override
  ExpectationType get expectation;
  @override
  ExpectationType get after;
  @override
  @JsonKey(ignore: true)
  _$$ExpectAfterErrorImplCopyWith<_$ExpectAfterErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExpectBeforeError {
  Token get token => throw _privateConstructorUsedError;
  ExpectationType get expectation => throw _privateConstructorUsedError;
  ExpectationType get before => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpectBeforeErrorCopyWith<ExpectBeforeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectBeforeErrorCopyWith<$Res> {
  factory $ExpectBeforeErrorCopyWith(
          ExpectBeforeError value, $Res Function(ExpectBeforeError) then) =
      _$ExpectBeforeErrorCopyWithImpl<$Res, ExpectBeforeError>;
  @useResult
  $Res call({Token token, ExpectationType expectation, ExpectationType before});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expectation = null,
    Object? before = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token,
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

  @override
  @pragma('vm:prefer-inline')
  $ExpectationTypeCopyWith<$Res> get expectation {
    return $ExpectationTypeCopyWith<$Res>(_value.expectation, (value) {
      return _then(_value.copyWith(expectation: value) as $Val);
    });
  }

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
  $Res call({Token token, ExpectationType expectation, ExpectationType before});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expectation = null,
    Object? before = null,
  }) {
    return _then(_$ExpectBeforeErrorImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token,
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
      {required this.token, required this.expectation, required this.before});

  @override
  final Token token;
  @override
  final ExpectationType expectation;
  @override
  final ExpectationType before;

  @override
  String toString() {
    return 'ExpectBeforeError(token: $token, expectation: $expectation, before: $before)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectBeforeErrorImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expectation, expectation) ||
                other.expectation == expectation) &&
            (identical(other.before, before) || other.before == before));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, expectation, before);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectBeforeErrorImplCopyWith<_$ExpectBeforeErrorImpl> get copyWith =>
      __$$ExpectBeforeErrorImplCopyWithImpl<_$ExpectBeforeErrorImpl>(
          this, _$identity);
}

abstract class _ExpectBeforeError implements ExpectBeforeError {
  const factory _ExpectBeforeError(
      {required final Token token,
      required final ExpectationType expectation,
      required final ExpectationType before}) = _$ExpectBeforeErrorImpl;

  @override
  Token get token;
  @override
  ExpectationType get expectation;
  @override
  ExpectationType get before;
  @override
  @JsonKey(ignore: true)
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
    required TResult Function(Statement statement, String? description)
        statement,
    required TResult Function(TokenType token, String? description) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Statement statement, String? description)? statement,
    TResult? Function(TokenType token, String? description)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Statement statement, String? description)? statement,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(StatementExpectation value) statement,
    required TResult Function(TokenExpectation value) token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? statement,
    TResult? Function(TokenExpectation value)? token,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? statement,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
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
    required TResult Function(Statement statement, String? description)
        statement,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return oneOf(expectations, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Statement statement, String? description)? statement,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return oneOf?.call(expectations, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Statement statement, String? description)? statement,
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
    required TResult Function(StatementExpectation value) statement,
    required TResult Function(TokenExpectation value) token,
  }) {
    return oneOf(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? statement,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return oneOf?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? statement,
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
  @override
  @JsonKey(ignore: true)
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
  $Res call({Statement statement, String? description});
}

/// @nodoc
class __$$StatementExpectationImplCopyWithImpl<$Res>
    extends _$ExpectationTypeCopyWithImpl<$Res, _$StatementExpectationImpl>
    implements _$$StatementExpectationImplCopyWith<$Res> {
  __$$StatementExpectationImplCopyWithImpl(_$StatementExpectationImpl _value,
      $Res Function(_$StatementExpectationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statement = null,
    Object? description = freezed,
  }) {
    return _then(_$StatementExpectationImpl(
      statement: null == statement
          ? _value.statement
          : statement // ignore: cast_nullable_to_non_nullable
              as Statement,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StatementExpectationImpl extends StatementExpectation {
  const _$StatementExpectationImpl({required this.statement, this.description})
      : super._();

  @override
  final Statement statement;
  @override
  final String? description;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatementExpectationImpl &&
            (identical(other.statement, statement) ||
                other.statement == statement) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statement, description);

  @JsonKey(ignore: true)
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
    required TResult Function(Statement statement, String? description)
        statement,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return statement(this.statement, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Statement statement, String? description)? statement,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return statement?.call(this.statement, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Statement statement, String? description)? statement,
    TResult Function(TokenType token, String? description)? token,
    required TResult orElse(),
  }) {
    if (statement != null) {
      return statement(this.statement, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OneOfExpectation value) oneOf,
    required TResult Function(StatementExpectation value) statement,
    required TResult Function(TokenExpectation value) token,
  }) {
    return statement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? statement,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return statement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? statement,
    TResult Function(TokenExpectation value)? token,
    required TResult orElse(),
  }) {
    if (statement != null) {
      return statement(this);
    }
    return orElse();
  }
}

abstract class StatementExpectation extends ExpectationType {
  const factory StatementExpectation(
      {required final Statement statement,
      final String? description}) = _$StatementExpectationImpl;
  const StatementExpectation._() : super._();

  Statement get statement;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
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
    required TResult Function(Statement statement, String? description)
        statement,
    required TResult Function(TokenType token, String? description) token,
  }) {
    return token(this.token, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult? Function(Statement statement, String? description)? statement,
    TResult? Function(TokenType token, String? description)? token,
  }) {
    return token?.call(this.token, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExpectationType> expectations, String? description)?
        oneOf,
    TResult Function(Statement statement, String? description)? statement,
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
    required TResult Function(StatementExpectation value) statement,
    required TResult Function(TokenExpectation value) token,
  }) {
    return token(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OneOfExpectation value)? oneOf,
    TResult? Function(StatementExpectation value)? statement,
    TResult? Function(TokenExpectation value)? token,
  }) {
    return token?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OneOfExpectation value)? oneOf,
    TResult Function(StatementExpectation value)? statement,
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
  @override
  @JsonKey(ignore: true)
  _$$TokenExpectationImplCopyWith<_$TokenExpectationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
