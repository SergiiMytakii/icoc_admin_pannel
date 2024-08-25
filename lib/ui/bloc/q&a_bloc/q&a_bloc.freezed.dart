// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'q&a_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QandAEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, Languages lang) requested,
    required TResult Function() getLangs,
    required TResult Function(IcocUser? user, QandAModel article) edit,
    required TResult Function(IcocUser? user, String docReference) delete,
    required TResult Function(IcocUser? user, Languages lang) translate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, Languages lang)? requested,
    TResult? Function()? getLangs,
    TResult? Function(IcocUser? user, QandAModel article)? edit,
    TResult? Function(IcocUser? user, String docReference)? delete,
    TResult? Function(IcocUser? user, Languages lang)? translate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, Languages lang)? requested,
    TResult Function()? getLangs,
    TResult Function(IcocUser? user, QandAModel article)? edit,
    TResult Function(IcocUser? user, String docReference)? delete,
    TResult Function(IcocUser? user, Languages lang)? translate,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandARequested value) requested,
    required TResult Function(QandAGetLangs value) getLangs,
    required TResult Function(QandAEdit value) edit,
    required TResult Function(QandADelete value) delete,
    required TResult Function(QandATranslate value) translate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandARequested value)? requested,
    TResult? Function(QandAGetLangs value)? getLangs,
    TResult? Function(QandAEdit value)? edit,
    TResult? Function(QandADelete value)? delete,
    TResult? Function(QandATranslate value)? translate,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandARequested value)? requested,
    TResult Function(QandAGetLangs value)? getLangs,
    TResult Function(QandAEdit value)? edit,
    TResult Function(QandADelete value)? delete,
    TResult Function(QandATranslate value)? translate,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QandAEventCopyWith<$Res> {
  factory $QandAEventCopyWith(
          QandAEvent value, $Res Function(QandAEvent) then) =
      _$QandAEventCopyWithImpl<$Res, QandAEvent>;
}

/// @nodoc
class _$QandAEventCopyWithImpl<$Res, $Val extends QandAEvent>
    implements $QandAEventCopyWith<$Res> {
  _$QandAEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$QandARequestedImplCopyWith<$Res> {
  factory _$$QandARequestedImplCopyWith(_$QandARequestedImpl value,
          $Res Function(_$QandARequestedImpl) then) =
      __$$QandARequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? query, Languages lang});
}

/// @nodoc
class __$$QandARequestedImplCopyWithImpl<$Res>
    extends _$QandAEventCopyWithImpl<$Res, _$QandARequestedImpl>
    implements _$$QandARequestedImplCopyWith<$Res> {
  __$$QandARequestedImplCopyWithImpl(
      _$QandARequestedImpl _value, $Res Function(_$QandARequestedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? lang = null,
  }) {
    return _then(_$QandARequestedImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Languages,
    ));
  }
}

/// @nodoc

class _$QandARequestedImpl implements QandARequested {
  const _$QandARequestedImpl({this.query, required this.lang});

  @override
  final String? query;
  @override
  final Languages lang;

  @override
  String toString() {
    return 'QandAEvent.requested(query: $query, lang: $lang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QandARequestedImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.lang, lang) || other.lang == lang));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, lang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QandARequestedImplCopyWith<_$QandARequestedImpl> get copyWith =>
      __$$QandARequestedImplCopyWithImpl<_$QandARequestedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, Languages lang) requested,
    required TResult Function() getLangs,
    required TResult Function(IcocUser? user, QandAModel article) edit,
    required TResult Function(IcocUser? user, String docReference) delete,
    required TResult Function(IcocUser? user, Languages lang) translate,
  }) {
    return requested(query, lang);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, Languages lang)? requested,
    TResult? Function()? getLangs,
    TResult? Function(IcocUser? user, QandAModel article)? edit,
    TResult? Function(IcocUser? user, String docReference)? delete,
    TResult? Function(IcocUser? user, Languages lang)? translate,
  }) {
    return requested?.call(query, lang);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, Languages lang)? requested,
    TResult Function()? getLangs,
    TResult Function(IcocUser? user, QandAModel article)? edit,
    TResult Function(IcocUser? user, String docReference)? delete,
    TResult Function(IcocUser? user, Languages lang)? translate,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested(query, lang);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandARequested value) requested,
    required TResult Function(QandAGetLangs value) getLangs,
    required TResult Function(QandAEdit value) edit,
    required TResult Function(QandADelete value) delete,
    required TResult Function(QandATranslate value) translate,
  }) {
    return requested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandARequested value)? requested,
    TResult? Function(QandAGetLangs value)? getLangs,
    TResult? Function(QandAEdit value)? edit,
    TResult? Function(QandADelete value)? delete,
    TResult? Function(QandATranslate value)? translate,
  }) {
    return requested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandARequested value)? requested,
    TResult Function(QandAGetLangs value)? getLangs,
    TResult Function(QandAEdit value)? edit,
    TResult Function(QandADelete value)? delete,
    TResult Function(QandATranslate value)? translate,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested(this);
    }
    return orElse();
  }
}

abstract class QandARequested implements QandAEvent {
  const factory QandARequested(
      {final String? query,
      required final Languages lang}) = _$QandARequestedImpl;

  String? get query;
  Languages get lang;
  @JsonKey(ignore: true)
  _$$QandARequestedImplCopyWith<_$QandARequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QandAGetLangsImplCopyWith<$Res> {
  factory _$$QandAGetLangsImplCopyWith(
          _$QandAGetLangsImpl value, $Res Function(_$QandAGetLangsImpl) then) =
      __$$QandAGetLangsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QandAGetLangsImplCopyWithImpl<$Res>
    extends _$QandAEventCopyWithImpl<$Res, _$QandAGetLangsImpl>
    implements _$$QandAGetLangsImplCopyWith<$Res> {
  __$$QandAGetLangsImplCopyWithImpl(
      _$QandAGetLangsImpl _value, $Res Function(_$QandAGetLangsImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$QandAGetLangsImpl implements QandAGetLangs {
  const _$QandAGetLangsImpl();

  @override
  String toString() {
    return 'QandAEvent.getLangs()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QandAGetLangsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, Languages lang) requested,
    required TResult Function() getLangs,
    required TResult Function(IcocUser? user, QandAModel article) edit,
    required TResult Function(IcocUser? user, String docReference) delete,
    required TResult Function(IcocUser? user, Languages lang) translate,
  }) {
    return getLangs();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, Languages lang)? requested,
    TResult? Function()? getLangs,
    TResult? Function(IcocUser? user, QandAModel article)? edit,
    TResult? Function(IcocUser? user, String docReference)? delete,
    TResult? Function(IcocUser? user, Languages lang)? translate,
  }) {
    return getLangs?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, Languages lang)? requested,
    TResult Function()? getLangs,
    TResult Function(IcocUser? user, QandAModel article)? edit,
    TResult Function(IcocUser? user, String docReference)? delete,
    TResult Function(IcocUser? user, Languages lang)? translate,
    required TResult orElse(),
  }) {
    if (getLangs != null) {
      return getLangs();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandARequested value) requested,
    required TResult Function(QandAGetLangs value) getLangs,
    required TResult Function(QandAEdit value) edit,
    required TResult Function(QandADelete value) delete,
    required TResult Function(QandATranslate value) translate,
  }) {
    return getLangs(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandARequested value)? requested,
    TResult? Function(QandAGetLangs value)? getLangs,
    TResult? Function(QandAEdit value)? edit,
    TResult? Function(QandADelete value)? delete,
    TResult? Function(QandATranslate value)? translate,
  }) {
    return getLangs?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandARequested value)? requested,
    TResult Function(QandAGetLangs value)? getLangs,
    TResult Function(QandAEdit value)? edit,
    TResult Function(QandADelete value)? delete,
    TResult Function(QandATranslate value)? translate,
    required TResult orElse(),
  }) {
    if (getLangs != null) {
      return getLangs(this);
    }
    return orElse();
  }
}

abstract class QandAGetLangs implements QandAEvent {
  const factory QandAGetLangs() = _$QandAGetLangsImpl;
}

/// @nodoc
abstract class _$$QandAEditImplCopyWith<$Res> {
  factory _$$QandAEditImplCopyWith(
          _$QandAEditImpl value, $Res Function(_$QandAEditImpl) then) =
      __$$QandAEditImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, QandAModel article});

  $QandAModelCopyWith<$Res> get article;
}

/// @nodoc
class __$$QandAEditImplCopyWithImpl<$Res>
    extends _$QandAEventCopyWithImpl<$Res, _$QandAEditImpl>
    implements _$$QandAEditImplCopyWith<$Res> {
  __$$QandAEditImplCopyWithImpl(
      _$QandAEditImpl _value, $Res Function(_$QandAEditImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? article = null,
  }) {
    return _then(_$QandAEditImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      article: null == article
          ? _value.article
          : article // ignore: cast_nullable_to_non_nullable
              as QandAModel,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $QandAModelCopyWith<$Res> get article {
    return $QandAModelCopyWith<$Res>(_value.article, (value) {
      return _then(_value.copyWith(article: value));
    });
  }
}

/// @nodoc

class _$QandAEditImpl implements QandAEdit {
  const _$QandAEditImpl({required this.user, required this.article});

  @override
  final IcocUser? user;
  @override
  final QandAModel article;

  @override
  String toString() {
    return 'QandAEvent.edit(user: $user, article: $article)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QandAEditImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.article, article) || other.article == article));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, article);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QandAEditImplCopyWith<_$QandAEditImpl> get copyWith =>
      __$$QandAEditImplCopyWithImpl<_$QandAEditImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, Languages lang) requested,
    required TResult Function() getLangs,
    required TResult Function(IcocUser? user, QandAModel article) edit,
    required TResult Function(IcocUser? user, String docReference) delete,
    required TResult Function(IcocUser? user, Languages lang) translate,
  }) {
    return edit(user, article);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, Languages lang)? requested,
    TResult? Function()? getLangs,
    TResult? Function(IcocUser? user, QandAModel article)? edit,
    TResult? Function(IcocUser? user, String docReference)? delete,
    TResult? Function(IcocUser? user, Languages lang)? translate,
  }) {
    return edit?.call(user, article);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, Languages lang)? requested,
    TResult Function()? getLangs,
    TResult Function(IcocUser? user, QandAModel article)? edit,
    TResult Function(IcocUser? user, String docReference)? delete,
    TResult Function(IcocUser? user, Languages lang)? translate,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(user, article);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandARequested value) requested,
    required TResult Function(QandAGetLangs value) getLangs,
    required TResult Function(QandAEdit value) edit,
    required TResult Function(QandADelete value) delete,
    required TResult Function(QandATranslate value) translate,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandARequested value)? requested,
    TResult? Function(QandAGetLangs value)? getLangs,
    TResult? Function(QandAEdit value)? edit,
    TResult? Function(QandADelete value)? delete,
    TResult? Function(QandATranslate value)? translate,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandARequested value)? requested,
    TResult Function(QandAGetLangs value)? getLangs,
    TResult Function(QandAEdit value)? edit,
    TResult Function(QandADelete value)? delete,
    TResult Function(QandATranslate value)? translate,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class QandAEdit implements QandAEvent {
  const factory QandAEdit(
      {required final IcocUser? user,
      required final QandAModel article}) = _$QandAEditImpl;

  IcocUser? get user;
  QandAModel get article;
  @JsonKey(ignore: true)
  _$$QandAEditImplCopyWith<_$QandAEditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QandADeleteImplCopyWith<$Res> {
  factory _$$QandADeleteImplCopyWith(
          _$QandADeleteImpl value, $Res Function(_$QandADeleteImpl) then) =
      __$$QandADeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, String docReference});
}

/// @nodoc
class __$$QandADeleteImplCopyWithImpl<$Res>
    extends _$QandAEventCopyWithImpl<$Res, _$QandADeleteImpl>
    implements _$$QandADeleteImplCopyWith<$Res> {
  __$$QandADeleteImplCopyWithImpl(
      _$QandADeleteImpl _value, $Res Function(_$QandADeleteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? docReference = null,
  }) {
    return _then(_$QandADeleteImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      docReference: null == docReference
          ? _value.docReference
          : docReference // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$QandADeleteImpl implements QandADelete {
  const _$QandADeleteImpl({required this.user, required this.docReference});

  @override
  final IcocUser? user;
  @override
  final String docReference;

  @override
  String toString() {
    return 'QandAEvent.delete(user: $user, docReference: $docReference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QandADeleteImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.docReference, docReference) ||
                other.docReference == docReference));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, docReference);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QandADeleteImplCopyWith<_$QandADeleteImpl> get copyWith =>
      __$$QandADeleteImplCopyWithImpl<_$QandADeleteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, Languages lang) requested,
    required TResult Function() getLangs,
    required TResult Function(IcocUser? user, QandAModel article) edit,
    required TResult Function(IcocUser? user, String docReference) delete,
    required TResult Function(IcocUser? user, Languages lang) translate,
  }) {
    return delete(user, docReference);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, Languages lang)? requested,
    TResult? Function()? getLangs,
    TResult? Function(IcocUser? user, QandAModel article)? edit,
    TResult? Function(IcocUser? user, String docReference)? delete,
    TResult? Function(IcocUser? user, Languages lang)? translate,
  }) {
    return delete?.call(user, docReference);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, Languages lang)? requested,
    TResult Function()? getLangs,
    TResult Function(IcocUser? user, QandAModel article)? edit,
    TResult Function(IcocUser? user, String docReference)? delete,
    TResult Function(IcocUser? user, Languages lang)? translate,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(user, docReference);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandARequested value) requested,
    required TResult Function(QandAGetLangs value) getLangs,
    required TResult Function(QandAEdit value) edit,
    required TResult Function(QandADelete value) delete,
    required TResult Function(QandATranslate value) translate,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandARequested value)? requested,
    TResult? Function(QandAGetLangs value)? getLangs,
    TResult? Function(QandAEdit value)? edit,
    TResult? Function(QandADelete value)? delete,
    TResult? Function(QandATranslate value)? translate,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandARequested value)? requested,
    TResult Function(QandAGetLangs value)? getLangs,
    TResult Function(QandAEdit value)? edit,
    TResult Function(QandADelete value)? delete,
    TResult Function(QandATranslate value)? translate,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class QandADelete implements QandAEvent {
  const factory QandADelete(
      {required final IcocUser? user,
      required final String docReference}) = _$QandADeleteImpl;

  IcocUser? get user;
  String get docReference;
  @JsonKey(ignore: true)
  _$$QandADeleteImplCopyWith<_$QandADeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QandATranslateImplCopyWith<$Res> {
  factory _$$QandATranslateImplCopyWith(_$QandATranslateImpl value,
          $Res Function(_$QandATranslateImpl) then) =
      __$$QandATranslateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, Languages lang});
}

/// @nodoc
class __$$QandATranslateImplCopyWithImpl<$Res>
    extends _$QandAEventCopyWithImpl<$Res, _$QandATranslateImpl>
    implements _$$QandATranslateImplCopyWith<$Res> {
  __$$QandATranslateImplCopyWithImpl(
      _$QandATranslateImpl _value, $Res Function(_$QandATranslateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? lang = null,
  }) {
    return _then(_$QandATranslateImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Languages,
    ));
  }
}

/// @nodoc

class _$QandATranslateImpl implements QandATranslate {
  const _$QandATranslateImpl({required this.user, required this.lang});

  @override
  final IcocUser? user;
  @override
  final Languages lang;

  @override
  String toString() {
    return 'QandAEvent.translate(user: $user, lang: $lang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QandATranslateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.lang, lang) || other.lang == lang));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, lang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QandATranslateImplCopyWith<_$QandATranslateImpl> get copyWith =>
      __$$QandATranslateImplCopyWithImpl<_$QandATranslateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, Languages lang) requested,
    required TResult Function() getLangs,
    required TResult Function(IcocUser? user, QandAModel article) edit,
    required TResult Function(IcocUser? user, String docReference) delete,
    required TResult Function(IcocUser? user, Languages lang) translate,
  }) {
    return translate(user, lang);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, Languages lang)? requested,
    TResult? Function()? getLangs,
    TResult? Function(IcocUser? user, QandAModel article)? edit,
    TResult? Function(IcocUser? user, String docReference)? delete,
    TResult? Function(IcocUser? user, Languages lang)? translate,
  }) {
    return translate?.call(user, lang);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, Languages lang)? requested,
    TResult Function()? getLangs,
    TResult Function(IcocUser? user, QandAModel article)? edit,
    TResult Function(IcocUser? user, String docReference)? delete,
    TResult Function(IcocUser? user, Languages lang)? translate,
    required TResult orElse(),
  }) {
    if (translate != null) {
      return translate(user, lang);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandARequested value) requested,
    required TResult Function(QandAGetLangs value) getLangs,
    required TResult Function(QandAEdit value) edit,
    required TResult Function(QandADelete value) delete,
    required TResult Function(QandATranslate value) translate,
  }) {
    return translate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandARequested value)? requested,
    TResult? Function(QandAGetLangs value)? getLangs,
    TResult? Function(QandAEdit value)? edit,
    TResult? Function(QandADelete value)? delete,
    TResult? Function(QandATranslate value)? translate,
  }) {
    return translate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandARequested value)? requested,
    TResult Function(QandAGetLangs value)? getLangs,
    TResult Function(QandAEdit value)? edit,
    TResult Function(QandADelete value)? delete,
    TResult Function(QandATranslate value)? translate,
    required TResult orElse(),
  }) {
    if (translate != null) {
      return translate(this);
    }
    return orElse();
  }
}

abstract class QandATranslate implements QandAEvent {
  const factory QandATranslate(
      {required final IcocUser? user,
      required final Languages lang}) = _$QandATranslateImpl;

  IcocUser? get user;
  Languages get lang;
  @JsonKey(ignore: true)
  _$$QandATranslateImplCopyWith<_$QandATranslateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QandAState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<QandAModel> articles) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<QandAModel> articles)? success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<QandAModel> articles)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandAInitial value) initial,
    required TResult Function(QandALoadingState value) loading,
    required TResult Function(GetQandASuccessState value) success,
    required TResult Function(QandAErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandAInitial value)? initial,
    TResult? Function(QandALoadingState value)? loading,
    TResult? Function(GetQandASuccessState value)? success,
    TResult? Function(QandAErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandAInitial value)? initial,
    TResult Function(QandALoadingState value)? loading,
    TResult Function(GetQandASuccessState value)? success,
    TResult Function(QandAErrorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QandAStateCopyWith<$Res> {
  factory $QandAStateCopyWith(
          QandAState value, $Res Function(QandAState) then) =
      _$QandAStateCopyWithImpl<$Res, QandAState>;
}

/// @nodoc
class _$QandAStateCopyWithImpl<$Res, $Val extends QandAState>
    implements $QandAStateCopyWith<$Res> {
  _$QandAStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$QandAInitialImplCopyWith<$Res> {
  factory _$$QandAInitialImplCopyWith(
          _$QandAInitialImpl value, $Res Function(_$QandAInitialImpl) then) =
      __$$QandAInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QandAInitialImplCopyWithImpl<$Res>
    extends _$QandAStateCopyWithImpl<$Res, _$QandAInitialImpl>
    implements _$$QandAInitialImplCopyWith<$Res> {
  __$$QandAInitialImplCopyWithImpl(
      _$QandAInitialImpl _value, $Res Function(_$QandAInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$QandAInitialImpl implements QandAInitial {
  const _$QandAInitialImpl();

  @override
  String toString() {
    return 'QandAState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QandAInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<QandAModel> articles) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<QandAModel> articles)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<QandAModel> articles)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandAInitial value) initial,
    required TResult Function(QandALoadingState value) loading,
    required TResult Function(GetQandASuccessState value) success,
    required TResult Function(QandAErrorState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandAInitial value)? initial,
    TResult? Function(QandALoadingState value)? loading,
    TResult? Function(GetQandASuccessState value)? success,
    TResult? Function(QandAErrorState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandAInitial value)? initial,
    TResult Function(QandALoadingState value)? loading,
    TResult Function(GetQandASuccessState value)? success,
    TResult Function(QandAErrorState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class QandAInitial implements QandAState {
  const factory QandAInitial() = _$QandAInitialImpl;
}

/// @nodoc
abstract class _$$QandALoadingStateImplCopyWith<$Res> {
  factory _$$QandALoadingStateImplCopyWith(_$QandALoadingStateImpl value,
          $Res Function(_$QandALoadingStateImpl) then) =
      __$$QandALoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QandALoadingStateImplCopyWithImpl<$Res>
    extends _$QandAStateCopyWithImpl<$Res, _$QandALoadingStateImpl>
    implements _$$QandALoadingStateImplCopyWith<$Res> {
  __$$QandALoadingStateImplCopyWithImpl(_$QandALoadingStateImpl _value,
      $Res Function(_$QandALoadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$QandALoadingStateImpl implements QandALoadingState {
  const _$QandALoadingStateImpl();

  @override
  String toString() {
    return 'QandAState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QandALoadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<QandAModel> articles) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<QandAModel> articles)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<QandAModel> articles)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandAInitial value) initial,
    required TResult Function(QandALoadingState value) loading,
    required TResult Function(GetQandASuccessState value) success,
    required TResult Function(QandAErrorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandAInitial value)? initial,
    TResult? Function(QandALoadingState value)? loading,
    TResult? Function(GetQandASuccessState value)? success,
    TResult? Function(QandAErrorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandAInitial value)? initial,
    TResult Function(QandALoadingState value)? loading,
    TResult Function(GetQandASuccessState value)? success,
    TResult Function(QandAErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class QandALoadingState implements QandAState {
  const factory QandALoadingState() = _$QandALoadingStateImpl;
}

/// @nodoc
abstract class _$$GetQandASuccessStateImplCopyWith<$Res> {
  factory _$$GetQandASuccessStateImplCopyWith(_$GetQandASuccessStateImpl value,
          $Res Function(_$GetQandASuccessStateImpl) then) =
      __$$GetQandASuccessStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<QandAModel> articles});
}

/// @nodoc
class __$$GetQandASuccessStateImplCopyWithImpl<$Res>
    extends _$QandAStateCopyWithImpl<$Res, _$GetQandASuccessStateImpl>
    implements _$$GetQandASuccessStateImplCopyWith<$Res> {
  __$$GetQandASuccessStateImplCopyWithImpl(_$GetQandASuccessStateImpl _value,
      $Res Function(_$GetQandASuccessStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articles = null,
  }) {
    return _then(_$GetQandASuccessStateImpl(
      null == articles
          ? _value._articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<QandAModel>,
    ));
  }
}

/// @nodoc

class _$GetQandASuccessStateImpl implements GetQandASuccessState {
  const _$GetQandASuccessStateImpl(final List<QandAModel> articles)
      : _articles = articles;

  final List<QandAModel> _articles;
  @override
  List<QandAModel> get articles {
    if (_articles is EqualUnmodifiableListView) return _articles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_articles);
  }

  @override
  String toString() {
    return 'QandAState.success(articles: $articles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetQandASuccessStateImpl &&
            const DeepCollectionEquality().equals(other._articles, _articles));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_articles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetQandASuccessStateImplCopyWith<_$GetQandASuccessStateImpl>
      get copyWith =>
          __$$GetQandASuccessStateImplCopyWithImpl<_$GetQandASuccessStateImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<QandAModel> articles) success,
    required TResult Function(String message) error,
  }) {
    return success(articles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<QandAModel> articles)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(articles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<QandAModel> articles)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(articles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandAInitial value) initial,
    required TResult Function(QandALoadingState value) loading,
    required TResult Function(GetQandASuccessState value) success,
    required TResult Function(QandAErrorState value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandAInitial value)? initial,
    TResult? Function(QandALoadingState value)? loading,
    TResult? Function(GetQandASuccessState value)? success,
    TResult? Function(QandAErrorState value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandAInitial value)? initial,
    TResult Function(QandALoadingState value)? loading,
    TResult Function(GetQandASuccessState value)? success,
    TResult Function(QandAErrorState value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class GetQandASuccessState implements QandAState {
  const factory GetQandASuccessState(final List<QandAModel> articles) =
      _$GetQandASuccessStateImpl;

  List<QandAModel> get articles;
  @JsonKey(ignore: true)
  _$$GetQandASuccessStateImplCopyWith<_$GetQandASuccessStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QandAErrorStateImplCopyWith<$Res> {
  factory _$$QandAErrorStateImplCopyWith(_$QandAErrorStateImpl value,
          $Res Function(_$QandAErrorStateImpl) then) =
      __$$QandAErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$QandAErrorStateImplCopyWithImpl<$Res>
    extends _$QandAStateCopyWithImpl<$Res, _$QandAErrorStateImpl>
    implements _$$QandAErrorStateImplCopyWith<$Res> {
  __$$QandAErrorStateImplCopyWithImpl(
      _$QandAErrorStateImpl _value, $Res Function(_$QandAErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$QandAErrorStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$QandAErrorStateImpl implements QandAErrorState {
  const _$QandAErrorStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'QandAState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QandAErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QandAErrorStateImplCopyWith<_$QandAErrorStateImpl> get copyWith =>
      __$$QandAErrorStateImplCopyWithImpl<_$QandAErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<QandAModel> articles) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<QandAModel> articles)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<QandAModel> articles)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QandAInitial value) initial,
    required TResult Function(QandALoadingState value) loading,
    required TResult Function(GetQandASuccessState value) success,
    required TResult Function(QandAErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(QandAInitial value)? initial,
    TResult? Function(QandALoadingState value)? loading,
    TResult? Function(GetQandASuccessState value)? success,
    TResult? Function(QandAErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QandAInitial value)? initial,
    TResult Function(QandALoadingState value)? loading,
    TResult Function(GetQandASuccessState value)? success,
    TResult Function(QandAErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class QandAErrorState implements QandAState {
  const factory QandAErrorState(final String message) = _$QandAErrorStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$QandAErrorStateImplCopyWith<_$QandAErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
