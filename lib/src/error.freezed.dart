// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpectedError {

 SyntacticEntity get syntacticEntity; ExpectationType get expectation;
/// Create a copy of ExpectedError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpectedErrorCopyWith<ExpectedError> get copyWith => _$ExpectedErrorCopyWithImpl<ExpectedError>(this as ExpectedError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpectedError&&(identical(other.syntacticEntity, syntacticEntity) || other.syntacticEntity == syntacticEntity)&&(identical(other.expectation, expectation) || other.expectation == expectation));
}


@override
int get hashCode => Object.hash(runtimeType,syntacticEntity,expectation);

@override
String toString() {
  return 'ExpectedError(syntacticEntity: $syntacticEntity, expectation: $expectation)';
}


}

/// @nodoc
abstract mixin class $ExpectedErrorCopyWith<$Res>  {
  factory $ExpectedErrorCopyWith(ExpectedError value, $Res Function(ExpectedError) _then) = _$ExpectedErrorCopyWithImpl;
@useResult
$Res call({
 SyntacticEntity syntacticEntity, ExpectationType expectation
});


$ExpectationTypeCopyWith<$Res> get expectation;

}
/// @nodoc
class _$ExpectedErrorCopyWithImpl<$Res>
    implements $ExpectedErrorCopyWith<$Res> {
  _$ExpectedErrorCopyWithImpl(this._self, this._then);

  final ExpectedError _self;
  final $Res Function(ExpectedError) _then;

/// Create a copy of ExpectedError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? syntacticEntity = null,Object? expectation = null,}) {
  return _then(_self.copyWith(
syntacticEntity: null == syntacticEntity ? _self.syntacticEntity : syntacticEntity // ignore: cast_nullable_to_non_nullable
as SyntacticEntity,expectation: null == expectation ? _self.expectation : expectation // ignore: cast_nullable_to_non_nullable
as ExpectationType,
  ));
}
/// Create a copy of ExpectedError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get expectation {
  
  return $ExpectationTypeCopyWith<$Res>(_self.expectation, (value) {
    return _then(_self.copyWith(expectation: value));
  });
}
}


/// @nodoc


class _ExpectError extends ExpectedError {
  const _ExpectError({required this.syntacticEntity, required this.expectation}): super._();
  

@override final  SyntacticEntity syntacticEntity;
@override final  ExpectationType expectation;

/// Create a copy of ExpectedError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpectErrorCopyWith<_ExpectError> get copyWith => __$ExpectErrorCopyWithImpl<_ExpectError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpectError&&(identical(other.syntacticEntity, syntacticEntity) || other.syntacticEntity == syntacticEntity)&&(identical(other.expectation, expectation) || other.expectation == expectation));
}


@override
int get hashCode => Object.hash(runtimeType,syntacticEntity,expectation);

@override
String toString() {
  return 'ExpectedError(syntacticEntity: $syntacticEntity, expectation: $expectation)';
}


}

/// @nodoc
abstract mixin class _$ExpectErrorCopyWith<$Res> implements $ExpectedErrorCopyWith<$Res> {
  factory _$ExpectErrorCopyWith(_ExpectError value, $Res Function(_ExpectError) _then) = __$ExpectErrorCopyWithImpl;
@override @useResult
$Res call({
 SyntacticEntity syntacticEntity, ExpectationType expectation
});


@override $ExpectationTypeCopyWith<$Res> get expectation;

}
/// @nodoc
class __$ExpectErrorCopyWithImpl<$Res>
    implements _$ExpectErrorCopyWith<$Res> {
  __$ExpectErrorCopyWithImpl(this._self, this._then);

  final _ExpectError _self;
  final $Res Function(_ExpectError) _then;

/// Create a copy of ExpectedError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? syntacticEntity = null,Object? expectation = null,}) {
  return _then(_ExpectError(
syntacticEntity: null == syntacticEntity ? _self.syntacticEntity : syntacticEntity // ignore: cast_nullable_to_non_nullable
as SyntacticEntity,expectation: null == expectation ? _self.expectation : expectation // ignore: cast_nullable_to_non_nullable
as ExpectationType,
  ));
}

/// Create a copy of ExpectedError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get expectation {
  
  return $ExpectationTypeCopyWith<$Res>(_self.expectation, (value) {
    return _then(_self.copyWith(expectation: value));
  });
}
}

/// @nodoc
mixin _$ExpectedAfterError {

 SyntacticEntity get syntacticEntity; ExpectationType get expectation; ExpectationType get after;
/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpectedAfterErrorCopyWith<ExpectedAfterError> get copyWith => _$ExpectedAfterErrorCopyWithImpl<ExpectedAfterError>(this as ExpectedAfterError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpectedAfterError&&(identical(other.syntacticEntity, syntacticEntity) || other.syntacticEntity == syntacticEntity)&&(identical(other.expectation, expectation) || other.expectation == expectation)&&(identical(other.after, after) || other.after == after));
}


@override
int get hashCode => Object.hash(runtimeType,syntacticEntity,expectation,after);

@override
String toString() {
  return 'ExpectedAfterError(syntacticEntity: $syntacticEntity, expectation: $expectation, after: $after)';
}


}

/// @nodoc
abstract mixin class $ExpectedAfterErrorCopyWith<$Res>  {
  factory $ExpectedAfterErrorCopyWith(ExpectedAfterError value, $Res Function(ExpectedAfterError) _then) = _$ExpectedAfterErrorCopyWithImpl;
@useResult
$Res call({
 SyntacticEntity syntacticEntity, ExpectationType expectation, ExpectationType after
});


$ExpectationTypeCopyWith<$Res> get expectation;$ExpectationTypeCopyWith<$Res> get after;

}
/// @nodoc
class _$ExpectedAfterErrorCopyWithImpl<$Res>
    implements $ExpectedAfterErrorCopyWith<$Res> {
  _$ExpectedAfterErrorCopyWithImpl(this._self, this._then);

  final ExpectedAfterError _self;
  final $Res Function(ExpectedAfterError) _then;

/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? syntacticEntity = null,Object? expectation = null,Object? after = null,}) {
  return _then(_self.copyWith(
syntacticEntity: null == syntacticEntity ? _self.syntacticEntity : syntacticEntity // ignore: cast_nullable_to_non_nullable
as SyntacticEntity,expectation: null == expectation ? _self.expectation : expectation // ignore: cast_nullable_to_non_nullable
as ExpectationType,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as ExpectationType,
  ));
}
/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get expectation {
  
  return $ExpectationTypeCopyWith<$Res>(_self.expectation, (value) {
    return _then(_self.copyWith(expectation: value));
  });
}/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get after {
  
  return $ExpectationTypeCopyWith<$Res>(_self.after, (value) {
    return _then(_self.copyWith(after: value));
  });
}
}


/// @nodoc


class _ExpectAfterError extends ExpectedAfterError {
  const _ExpectAfterError({required this.syntacticEntity, required this.expectation, required this.after}): super._();
  

@override final  SyntacticEntity syntacticEntity;
@override final  ExpectationType expectation;
@override final  ExpectationType after;

/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpectAfterErrorCopyWith<_ExpectAfterError> get copyWith => __$ExpectAfterErrorCopyWithImpl<_ExpectAfterError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpectAfterError&&(identical(other.syntacticEntity, syntacticEntity) || other.syntacticEntity == syntacticEntity)&&(identical(other.expectation, expectation) || other.expectation == expectation)&&(identical(other.after, after) || other.after == after));
}


@override
int get hashCode => Object.hash(runtimeType,syntacticEntity,expectation,after);

@override
String toString() {
  return 'ExpectedAfterError(syntacticEntity: $syntacticEntity, expectation: $expectation, after: $after)';
}


}

/// @nodoc
abstract mixin class _$ExpectAfterErrorCopyWith<$Res> implements $ExpectedAfterErrorCopyWith<$Res> {
  factory _$ExpectAfterErrorCopyWith(_ExpectAfterError value, $Res Function(_ExpectAfterError) _then) = __$ExpectAfterErrorCopyWithImpl;
@override @useResult
$Res call({
 SyntacticEntity syntacticEntity, ExpectationType expectation, ExpectationType after
});


@override $ExpectationTypeCopyWith<$Res> get expectation;@override $ExpectationTypeCopyWith<$Res> get after;

}
/// @nodoc
class __$ExpectAfterErrorCopyWithImpl<$Res>
    implements _$ExpectAfterErrorCopyWith<$Res> {
  __$ExpectAfterErrorCopyWithImpl(this._self, this._then);

  final _ExpectAfterError _self;
  final $Res Function(_ExpectAfterError) _then;

/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? syntacticEntity = null,Object? expectation = null,Object? after = null,}) {
  return _then(_ExpectAfterError(
syntacticEntity: null == syntacticEntity ? _self.syntacticEntity : syntacticEntity // ignore: cast_nullable_to_non_nullable
as SyntacticEntity,expectation: null == expectation ? _self.expectation : expectation // ignore: cast_nullable_to_non_nullable
as ExpectationType,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as ExpectationType,
  ));
}

/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get expectation {
  
  return $ExpectationTypeCopyWith<$Res>(_self.expectation, (value) {
    return _then(_self.copyWith(expectation: value));
  });
}/// Create a copy of ExpectedAfterError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get after {
  
  return $ExpectationTypeCopyWith<$Res>(_self.after, (value) {
    return _then(_self.copyWith(after: value));
  });
}
}

/// @nodoc
mixin _$ExpectedBeforeError {

 SyntacticEntity get syntacticEntity; ExpectationType get expectation; ExpectationType get before;
/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpectedBeforeErrorCopyWith<ExpectedBeforeError> get copyWith => _$ExpectedBeforeErrorCopyWithImpl<ExpectedBeforeError>(this as ExpectedBeforeError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpectedBeforeError&&(identical(other.syntacticEntity, syntacticEntity) || other.syntacticEntity == syntacticEntity)&&(identical(other.expectation, expectation) || other.expectation == expectation)&&(identical(other.before, before) || other.before == before));
}


@override
int get hashCode => Object.hash(runtimeType,syntacticEntity,expectation,before);

@override
String toString() {
  return 'ExpectedBeforeError(syntacticEntity: $syntacticEntity, expectation: $expectation, before: $before)';
}


}

/// @nodoc
abstract mixin class $ExpectedBeforeErrorCopyWith<$Res>  {
  factory $ExpectedBeforeErrorCopyWith(ExpectedBeforeError value, $Res Function(ExpectedBeforeError) _then) = _$ExpectedBeforeErrorCopyWithImpl;
@useResult
$Res call({
 SyntacticEntity syntacticEntity, ExpectationType expectation, ExpectationType before
});


$ExpectationTypeCopyWith<$Res> get expectation;$ExpectationTypeCopyWith<$Res> get before;

}
/// @nodoc
class _$ExpectedBeforeErrorCopyWithImpl<$Res>
    implements $ExpectedBeforeErrorCopyWith<$Res> {
  _$ExpectedBeforeErrorCopyWithImpl(this._self, this._then);

  final ExpectedBeforeError _self;
  final $Res Function(ExpectedBeforeError) _then;

/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? syntacticEntity = null,Object? expectation = null,Object? before = null,}) {
  return _then(_self.copyWith(
syntacticEntity: null == syntacticEntity ? _self.syntacticEntity : syntacticEntity // ignore: cast_nullable_to_non_nullable
as SyntacticEntity,expectation: null == expectation ? _self.expectation : expectation // ignore: cast_nullable_to_non_nullable
as ExpectationType,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as ExpectationType,
  ));
}
/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get expectation {
  
  return $ExpectationTypeCopyWith<$Res>(_self.expectation, (value) {
    return _then(_self.copyWith(expectation: value));
  });
}/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get before {
  
  return $ExpectationTypeCopyWith<$Res>(_self.before, (value) {
    return _then(_self.copyWith(before: value));
  });
}
}


/// @nodoc


class _ExpectBeforeError extends ExpectedBeforeError {
  const _ExpectBeforeError({required this.syntacticEntity, required this.expectation, required this.before}): super._();
  

@override final  SyntacticEntity syntacticEntity;
@override final  ExpectationType expectation;
@override final  ExpectationType before;

/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpectBeforeErrorCopyWith<_ExpectBeforeError> get copyWith => __$ExpectBeforeErrorCopyWithImpl<_ExpectBeforeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpectBeforeError&&(identical(other.syntacticEntity, syntacticEntity) || other.syntacticEntity == syntacticEntity)&&(identical(other.expectation, expectation) || other.expectation == expectation)&&(identical(other.before, before) || other.before == before));
}


@override
int get hashCode => Object.hash(runtimeType,syntacticEntity,expectation,before);

@override
String toString() {
  return 'ExpectedBeforeError(syntacticEntity: $syntacticEntity, expectation: $expectation, before: $before)';
}


}

/// @nodoc
abstract mixin class _$ExpectBeforeErrorCopyWith<$Res> implements $ExpectedBeforeErrorCopyWith<$Res> {
  factory _$ExpectBeforeErrorCopyWith(_ExpectBeforeError value, $Res Function(_ExpectBeforeError) _then) = __$ExpectBeforeErrorCopyWithImpl;
@override @useResult
$Res call({
 SyntacticEntity syntacticEntity, ExpectationType expectation, ExpectationType before
});


@override $ExpectationTypeCopyWith<$Res> get expectation;@override $ExpectationTypeCopyWith<$Res> get before;

}
/// @nodoc
class __$ExpectBeforeErrorCopyWithImpl<$Res>
    implements _$ExpectBeforeErrorCopyWith<$Res> {
  __$ExpectBeforeErrorCopyWithImpl(this._self, this._then);

  final _ExpectBeforeError _self;
  final $Res Function(_ExpectBeforeError) _then;

/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? syntacticEntity = null,Object? expectation = null,Object? before = null,}) {
  return _then(_ExpectBeforeError(
syntacticEntity: null == syntacticEntity ? _self.syntacticEntity : syntacticEntity // ignore: cast_nullable_to_non_nullable
as SyntacticEntity,expectation: null == expectation ? _self.expectation : expectation // ignore: cast_nullable_to_non_nullable
as ExpectationType,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as ExpectationType,
  ));
}

/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get expectation {
  
  return $ExpectationTypeCopyWith<$Res>(_self.expectation, (value) {
    return _then(_self.copyWith(expectation: value));
  });
}/// Create a copy of ExpectedBeforeError
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpectationTypeCopyWith<$Res> get before {
  
  return $ExpectationTypeCopyWith<$Res>(_self.before, (value) {
    return _then(_self.copyWith(before: value));
  });
}
}

/// @nodoc
mixin _$ExpectationType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpectationType);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $ExpectationTypeCopyWith<$Res>  {
$ExpectationTypeCopyWith(ExpectationType _, $Res Function(ExpectationType) __);
}


/// @nodoc


class DeclarationExpectation extends ExpectationType {
  const DeclarationExpectation({this.declaration}): super._();
  

 final  Declaration? declaration;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeclarationExpectationCopyWith<DeclarationExpectation> get copyWith => _$DeclarationExpectationCopyWithImpl<DeclarationExpectation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeclarationExpectation&&(identical(other.declaration, declaration) || other.declaration == declaration));
}


@override
int get hashCode => Object.hash(runtimeType,declaration);



}

/// @nodoc
abstract mixin class $DeclarationExpectationCopyWith<$Res> implements $ExpectationTypeCopyWith<$Res> {
  factory $DeclarationExpectationCopyWith(DeclarationExpectation value, $Res Function(DeclarationExpectation) _then) = _$DeclarationExpectationCopyWithImpl;
@useResult
$Res call({
 Declaration? declaration
});




}
/// @nodoc
class _$DeclarationExpectationCopyWithImpl<$Res>
    implements $DeclarationExpectationCopyWith<$Res> {
  _$DeclarationExpectationCopyWithImpl(this._self, this._then);

  final DeclarationExpectation _self;
  final $Res Function(DeclarationExpectation) _then;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? declaration = freezed,}) {
  return _then(DeclarationExpectation(
declaration: freezed == declaration ? _self.declaration : declaration // ignore: cast_nullable_to_non_nullable
as Declaration?,
  ));
}


}

/// @nodoc


class ExpressionExpectation extends ExpectationType {
  const ExpressionExpectation({this.expression}): super._();
  

 final  Expression? expression;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpressionExpectationCopyWith<ExpressionExpectation> get copyWith => _$ExpressionExpectationCopyWithImpl<ExpressionExpectation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpressionExpectation&&(identical(other.expression, expression) || other.expression == expression));
}


@override
int get hashCode => Object.hash(runtimeType,expression);



}

/// @nodoc
abstract mixin class $ExpressionExpectationCopyWith<$Res> implements $ExpectationTypeCopyWith<$Res> {
  factory $ExpressionExpectationCopyWith(ExpressionExpectation value, $Res Function(ExpressionExpectation) _then) = _$ExpressionExpectationCopyWithImpl;
@useResult
$Res call({
 Expression? expression
});




}
/// @nodoc
class _$ExpressionExpectationCopyWithImpl<$Res>
    implements $ExpressionExpectationCopyWith<$Res> {
  _$ExpressionExpectationCopyWithImpl(this._self, this._then);

  final ExpressionExpectation _self;
  final $Res Function(ExpressionExpectation) _then;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? expression = freezed,}) {
  return _then(ExpressionExpectation(
expression: freezed == expression ? _self.expression : expression // ignore: cast_nullable_to_non_nullable
as Expression?,
  ));
}


}

/// @nodoc


class TypeIdentifierExpectation extends ExpectationType {
  const TypeIdentifierExpectation(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypeIdentifierExpectation);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class OneOfExpectation extends ExpectationType {
  const OneOfExpectation({required final  List<ExpectationType> expectations}): _expectations = expectations,super._();
  

 final  List<ExpectationType> _expectations;
 List<ExpectationType> get expectations {
  if (_expectations is EqualUnmodifiableListView) return _expectations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expectations);
}


/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OneOfExpectationCopyWith<OneOfExpectation> get copyWith => _$OneOfExpectationCopyWithImpl<OneOfExpectation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OneOfExpectation&&const DeepCollectionEquality().equals(other._expectations, _expectations));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_expectations));



}

/// @nodoc
abstract mixin class $OneOfExpectationCopyWith<$Res> implements $ExpectationTypeCopyWith<$Res> {
  factory $OneOfExpectationCopyWith(OneOfExpectation value, $Res Function(OneOfExpectation) _then) = _$OneOfExpectationCopyWithImpl;
@useResult
$Res call({
 List<ExpectationType> expectations
});




}
/// @nodoc
class _$OneOfExpectationCopyWithImpl<$Res>
    implements $OneOfExpectationCopyWith<$Res> {
  _$OneOfExpectationCopyWithImpl(this._self, this._then);

  final OneOfExpectation _self;
  final $Res Function(OneOfExpectation) _then;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? expectations = null,}) {
  return _then(OneOfExpectation(
expectations: null == expectations ? _self._expectations : expectations // ignore: cast_nullable_to_non_nullable
as List<ExpectationType>,
  ));
}


}

/// @nodoc


class TokenExpectation extends ExpectationType {
  const TokenExpectation({required this.token, this.description}): super._();
  

 final  TokenType token;
 final  String? description;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenExpectationCopyWith<TokenExpectation> get copyWith => _$TokenExpectationCopyWithImpl<TokenExpectation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenExpectation&&(identical(other.token, token) || other.token == token)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,token,description);



}

/// @nodoc
abstract mixin class $TokenExpectationCopyWith<$Res> implements $ExpectationTypeCopyWith<$Res> {
  factory $TokenExpectationCopyWith(TokenExpectation value, $Res Function(TokenExpectation) _then) = _$TokenExpectationCopyWithImpl;
@useResult
$Res call({
 TokenType token, String? description
});




}
/// @nodoc
class _$TokenExpectationCopyWithImpl<$Res>
    implements $TokenExpectationCopyWith<$Res> {
  _$TokenExpectationCopyWithImpl(this._self, this._then);

  final TokenExpectation _self;
  final $Res Function(TokenExpectation) _then;

/// Create a copy of ExpectationType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,Object? description = freezed,}) {
  return _then(TokenExpectation(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TokenType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
