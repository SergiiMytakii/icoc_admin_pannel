// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insights_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InsightsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, String? language) get,
    required TResult Function(IcocUser? user, Post post) add,
    required TResult Function(IcocUser? user, Post post) edit,
    required TResult Function(IcocUser? user, String id) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, String? language)? get,
    TResult? Function(IcocUser? user, Post post)? add,
    TResult? Function(IcocUser? user, Post post)? edit,
    TResult? Function(IcocUser? user, String id)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, String? language)? get,
    TResult Function(IcocUser? user, Post post)? add,
    TResult Function(IcocUser? user, Post post)? edit,
    TResult Function(IcocUser? user, String id)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsGet value) get,
    required TResult Function(InsightsAdd value) add,
    required TResult Function(InsightsEdit value) edit,
    required TResult Function(InsightsDelete value) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsGet value)? get,
    TResult? Function(InsightsAdd value)? add,
    TResult? Function(InsightsEdit value)? edit,
    TResult? Function(InsightsDelete value)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsGet value)? get,
    TResult Function(InsightsAdd value)? add,
    TResult Function(InsightsEdit value)? edit,
    TResult Function(InsightsDelete value)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsEventCopyWith<$Res> {
  factory $InsightsEventCopyWith(
          InsightsEvent value, $Res Function(InsightsEvent) then) =
      _$InsightsEventCopyWithImpl<$Res, InsightsEvent>;
}

/// @nodoc
class _$InsightsEventCopyWithImpl<$Res, $Val extends InsightsEvent>
    implements $InsightsEventCopyWith<$Res> {
  _$InsightsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InsightsGetImplCopyWith<$Res> {
  factory _$$InsightsGetImplCopyWith(
          _$InsightsGetImpl value, $Res Function(_$InsightsGetImpl) then) =
      __$$InsightsGetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? query, String? language});
}

/// @nodoc
class __$$InsightsGetImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsGetImpl>
    implements _$$InsightsGetImplCopyWith<$Res> {
  __$$InsightsGetImplCopyWithImpl(
      _$InsightsGetImpl _value, $Res Function(_$InsightsGetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? language = freezed,
  }) {
    return _then(_$InsightsGetImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$InsightsGetImpl implements InsightsGet {
  const _$InsightsGetImpl({this.query, this.language});

  @override
  final String? query;
  @override
  final String? language;

  @override
  String toString() {
    return 'InsightsEvent.get(query: $query, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsGetImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, language);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsGetImplCopyWith<_$InsightsGetImpl> get copyWith =>
      __$$InsightsGetImplCopyWithImpl<_$InsightsGetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, String? language) get,
    required TResult Function(IcocUser? user, Post post) add,
    required TResult Function(IcocUser? user, Post post) edit,
    required TResult Function(IcocUser? user, String id) delete,
  }) {
    return get(query, language);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, String? language)? get,
    TResult? Function(IcocUser? user, Post post)? add,
    TResult? Function(IcocUser? user, Post post)? edit,
    TResult? Function(IcocUser? user, String id)? delete,
  }) {
    return get?.call(query, language);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, String? language)? get,
    TResult Function(IcocUser? user, Post post)? add,
    TResult Function(IcocUser? user, Post post)? edit,
    TResult Function(IcocUser? user, String id)? delete,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get(query, language);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsGet value) get,
    required TResult Function(InsightsAdd value) add,
    required TResult Function(InsightsEdit value) edit,
    required TResult Function(InsightsDelete value) delete,
  }) {
    return get(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsGet value)? get,
    TResult? Function(InsightsAdd value)? add,
    TResult? Function(InsightsEdit value)? edit,
    TResult? Function(InsightsDelete value)? delete,
  }) {
    return get?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsGet value)? get,
    TResult Function(InsightsAdd value)? add,
    TResult Function(InsightsEdit value)? edit,
    TResult Function(InsightsDelete value)? delete,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get(this);
    }
    return orElse();
  }
}

abstract class InsightsGet implements InsightsEvent {
  const factory InsightsGet({final String? query, final String? language}) =
      _$InsightsGetImpl;

  String? get query;
  String? get language;
  @JsonKey(ignore: true)
  _$$InsightsGetImplCopyWith<_$InsightsGetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsightsAddImplCopyWith<$Res> {
  factory _$$InsightsAddImplCopyWith(
          _$InsightsAddImpl value, $Res Function(_$InsightsAddImpl) then) =
      __$$InsightsAddImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, Post post});

  $PostCopyWith<$Res> get post;
}

/// @nodoc
class __$$InsightsAddImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsAddImpl>
    implements _$$InsightsAddImplCopyWith<$Res> {
  __$$InsightsAddImplCopyWithImpl(
      _$InsightsAddImpl _value, $Res Function(_$InsightsAddImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? post = null,
  }) {
    return _then(_$InsightsAddImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      post: null == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res> get post {
    return $PostCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value));
    });
  }
}

/// @nodoc

class _$InsightsAddImpl implements InsightsAdd {
  const _$InsightsAddImpl({required this.user, required this.post});

  @override
  final IcocUser? user;
  @override
  final Post post;

  @override
  String toString() {
    return 'InsightsEvent.add(user: $user, post: $post)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsAddImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.post, post) || other.post == post));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, post);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsAddImplCopyWith<_$InsightsAddImpl> get copyWith =>
      __$$InsightsAddImplCopyWithImpl<_$InsightsAddImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, String? language) get,
    required TResult Function(IcocUser? user, Post post) add,
    required TResult Function(IcocUser? user, Post post) edit,
    required TResult Function(IcocUser? user, String id) delete,
  }) {
    return add(user, post);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, String? language)? get,
    TResult? Function(IcocUser? user, Post post)? add,
    TResult? Function(IcocUser? user, Post post)? edit,
    TResult? Function(IcocUser? user, String id)? delete,
  }) {
    return add?.call(user, post);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, String? language)? get,
    TResult Function(IcocUser? user, Post post)? add,
    TResult Function(IcocUser? user, Post post)? edit,
    TResult Function(IcocUser? user, String id)? delete,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(user, post);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsGet value) get,
    required TResult Function(InsightsAdd value) add,
    required TResult Function(InsightsEdit value) edit,
    required TResult Function(InsightsDelete value) delete,
  }) {
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsGet value)? get,
    TResult? Function(InsightsAdd value)? add,
    TResult? Function(InsightsEdit value)? edit,
    TResult? Function(InsightsDelete value)? delete,
  }) {
    return add?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsGet value)? get,
    TResult Function(InsightsAdd value)? add,
    TResult Function(InsightsEdit value)? edit,
    TResult Function(InsightsDelete value)? delete,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class InsightsAdd implements InsightsEvent {
  const factory InsightsAdd(
      {required final IcocUser? user,
      required final Post post}) = _$InsightsAddImpl;

  IcocUser? get user;
  Post get post;
  @JsonKey(ignore: true)
  _$$InsightsAddImplCopyWith<_$InsightsAddImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsightsEditImplCopyWith<$Res> {
  factory _$$InsightsEditImplCopyWith(
          _$InsightsEditImpl value, $Res Function(_$InsightsEditImpl) then) =
      __$$InsightsEditImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, Post post});

  $PostCopyWith<$Res> get post;
}

/// @nodoc
class __$$InsightsEditImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsEditImpl>
    implements _$$InsightsEditImplCopyWith<$Res> {
  __$$InsightsEditImplCopyWithImpl(
      _$InsightsEditImpl _value, $Res Function(_$InsightsEditImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? post = null,
  }) {
    return _then(_$InsightsEditImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      post: null == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res> get post {
    return $PostCopyWith<$Res>(_value.post, (value) {
      return _then(_value.copyWith(post: value));
    });
  }
}

/// @nodoc

class _$InsightsEditImpl implements InsightsEdit {
  const _$InsightsEditImpl({required this.user, required this.post});

  @override
  final IcocUser? user;
  @override
  final Post post;

  @override
  String toString() {
    return 'InsightsEvent.edit(user: $user, post: $post)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsEditImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.post, post) || other.post == post));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, post);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsEditImplCopyWith<_$InsightsEditImpl> get copyWith =>
      __$$InsightsEditImplCopyWithImpl<_$InsightsEditImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, String? language) get,
    required TResult Function(IcocUser? user, Post post) add,
    required TResult Function(IcocUser? user, Post post) edit,
    required TResult Function(IcocUser? user, String id) delete,
  }) {
    return edit(user, post);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, String? language)? get,
    TResult? Function(IcocUser? user, Post post)? add,
    TResult? Function(IcocUser? user, Post post)? edit,
    TResult? Function(IcocUser? user, String id)? delete,
  }) {
    return edit?.call(user, post);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, String? language)? get,
    TResult Function(IcocUser? user, Post post)? add,
    TResult Function(IcocUser? user, Post post)? edit,
    TResult Function(IcocUser? user, String id)? delete,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(user, post);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsGet value) get,
    required TResult Function(InsightsAdd value) add,
    required TResult Function(InsightsEdit value) edit,
    required TResult Function(InsightsDelete value) delete,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsGet value)? get,
    TResult? Function(InsightsAdd value)? add,
    TResult? Function(InsightsEdit value)? edit,
    TResult? Function(InsightsDelete value)? delete,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsGet value)? get,
    TResult Function(InsightsAdd value)? add,
    TResult Function(InsightsEdit value)? edit,
    TResult Function(InsightsDelete value)? delete,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class InsightsEdit implements InsightsEvent {
  const factory InsightsEdit(
      {required final IcocUser? user,
      required final Post post}) = _$InsightsEditImpl;

  IcocUser? get user;
  Post get post;
  @JsonKey(ignore: true)
  _$$InsightsEditImplCopyWith<_$InsightsEditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsightsDeleteImplCopyWith<$Res> {
  factory _$$InsightsDeleteImplCopyWith(_$InsightsDeleteImpl value,
          $Res Function(_$InsightsDeleteImpl) then) =
      __$$InsightsDeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, String id});
}

/// @nodoc
class __$$InsightsDeleteImplCopyWithImpl<$Res>
    extends _$InsightsEventCopyWithImpl<$Res, _$InsightsDeleteImpl>
    implements _$$InsightsDeleteImplCopyWith<$Res> {
  __$$InsightsDeleteImplCopyWithImpl(
      _$InsightsDeleteImpl _value, $Res Function(_$InsightsDeleteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? id = null,
  }) {
    return _then(_$InsightsDeleteImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InsightsDeleteImpl implements InsightsDelete {
  const _$InsightsDeleteImpl({required this.user, required this.id});

  @override
  final IcocUser? user;
  @override
  final String id;

  @override
  String toString() {
    return 'InsightsEvent.delete(user: $user, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsDeleteImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsDeleteImplCopyWith<_$InsightsDeleteImpl> get copyWith =>
      __$$InsightsDeleteImplCopyWithImpl<_$InsightsDeleteImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query, String? language) get,
    required TResult Function(IcocUser? user, Post post) add,
    required TResult Function(IcocUser? user, Post post) edit,
    required TResult Function(IcocUser? user, String id) delete,
  }) {
    return delete(user, id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query, String? language)? get,
    TResult? Function(IcocUser? user, Post post)? add,
    TResult? Function(IcocUser? user, Post post)? edit,
    TResult? Function(IcocUser? user, String id)? delete,
  }) {
    return delete?.call(user, id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query, String? language)? get,
    TResult Function(IcocUser? user, Post post)? add,
    TResult Function(IcocUser? user, Post post)? edit,
    TResult Function(IcocUser? user, String id)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(user, id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsGet value) get,
    required TResult Function(InsightsAdd value) add,
    required TResult Function(InsightsEdit value) edit,
    required TResult Function(InsightsDelete value) delete,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsGet value)? get,
    TResult? Function(InsightsAdd value)? add,
    TResult? Function(InsightsEdit value)? edit,
    TResult? Function(InsightsDelete value)? delete,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsGet value)? get,
    TResult Function(InsightsAdd value)? add,
    TResult Function(InsightsEdit value)? edit,
    TResult Function(InsightsDelete value)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class InsightsDelete implements InsightsEvent {
  const factory InsightsDelete(
      {required final IcocUser? user,
      required final String id}) = _$InsightsDeleteImpl;

  IcocUser? get user;
  String get id;
  @JsonKey(ignore: true)
  _$$InsightsDeleteImplCopyWith<_$InsightsDeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InsightsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Post> posts) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> posts)? success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> posts)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsSuccess value) success,
    required TResult Function(InsightsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsSuccess value)? success,
    TResult? Function(InsightsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsSuccess value)? success,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightsStateCopyWith<$Res> {
  factory $InsightsStateCopyWith(
          InsightsState value, $Res Function(InsightsState) then) =
      _$InsightsStateCopyWithImpl<$Res, InsightsState>;
}

/// @nodoc
class _$InsightsStateCopyWithImpl<$Res, $Val extends InsightsState>
    implements $InsightsStateCopyWith<$Res> {
  _$InsightsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InsightsInitialImplCopyWith<$Res> {
  factory _$$InsightsInitialImplCopyWith(_$InsightsInitialImpl value,
          $Res Function(_$InsightsInitialImpl) then) =
      __$$InsightsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsInitialImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsInitialImpl>
    implements _$$InsightsInitialImplCopyWith<$Res> {
  __$$InsightsInitialImplCopyWithImpl(
      _$InsightsInitialImpl _value, $Res Function(_$InsightsInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InsightsInitialImpl implements InsightsInitial {
  const _$InsightsInitialImpl();

  @override
  String toString() {
    return 'InsightsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InsightsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Post> posts) success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> posts)? success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> posts)? success,
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
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsSuccess value) success,
    required TResult Function(InsightsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsSuccess value)? success,
    TResult? Function(InsightsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsSuccess value)? success,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InsightsInitial implements InsightsState {
  const factory InsightsInitial() = _$InsightsInitialImpl;
}

/// @nodoc
abstract class _$$InsightsLoadingImplCopyWith<$Res> {
  factory _$$InsightsLoadingImplCopyWith(_$InsightsLoadingImpl value,
          $Res Function(_$InsightsLoadingImpl) then) =
      __$$InsightsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InsightsLoadingImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsLoadingImpl>
    implements _$$InsightsLoadingImplCopyWith<$Res> {
  __$$InsightsLoadingImplCopyWithImpl(
      _$InsightsLoadingImpl _value, $Res Function(_$InsightsLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InsightsLoadingImpl implements InsightsLoading {
  const _$InsightsLoadingImpl();

  @override
  String toString() {
    return 'InsightsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InsightsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Post> posts) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> posts)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> posts)? success,
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
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsSuccess value) success,
    required TResult Function(InsightsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsSuccess value)? success,
    TResult? Function(InsightsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsSuccess value)? success,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class InsightsLoading implements InsightsState {
  const factory InsightsLoading() = _$InsightsLoadingImpl;
}

/// @nodoc
abstract class _$$InsightsSuccessImplCopyWith<$Res> {
  factory _$$InsightsSuccessImplCopyWith(_$InsightsSuccessImpl value,
          $Res Function(_$InsightsSuccessImpl) then) =
      __$$InsightsSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Post> posts});
}

/// @nodoc
class __$$InsightsSuccessImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsSuccessImpl>
    implements _$$InsightsSuccessImplCopyWith<$Res> {
  __$$InsightsSuccessImplCopyWithImpl(
      _$InsightsSuccessImpl _value, $Res Function(_$InsightsSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
  }) {
    return _then(_$InsightsSuccessImpl(
      null == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
    ));
  }
}

/// @nodoc

class _$InsightsSuccessImpl implements InsightsSuccess {
  const _$InsightsSuccessImpl(final List<Post> posts) : _posts = posts;

  final List<Post> _posts;
  @override
  List<Post> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  String toString() {
    return 'InsightsState.success(posts: $posts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsSuccessImpl &&
            const DeepCollectionEquality().equals(other._posts, _posts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_posts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsSuccessImplCopyWith<_$InsightsSuccessImpl> get copyWith =>
      __$$InsightsSuccessImplCopyWithImpl<_$InsightsSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Post> posts) success,
    required TResult Function(String message) error,
  }) {
    return success(posts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> posts)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(posts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> posts)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(posts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsSuccess value) success,
    required TResult Function(InsightsError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsSuccess value)? success,
    TResult? Function(InsightsError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsSuccess value)? success,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class InsightsSuccess implements InsightsState {
  const factory InsightsSuccess(final List<Post> posts) = _$InsightsSuccessImpl;

  List<Post> get posts;
  @JsonKey(ignore: true)
  _$$InsightsSuccessImplCopyWith<_$InsightsSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsightsErrorImplCopyWith<$Res> {
  factory _$$InsightsErrorImplCopyWith(
          _$InsightsErrorImpl value, $Res Function(_$InsightsErrorImpl) then) =
      __$$InsightsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InsightsErrorImplCopyWithImpl<$Res>
    extends _$InsightsStateCopyWithImpl<$Res, _$InsightsErrorImpl>
    implements _$$InsightsErrorImplCopyWith<$Res> {
  __$$InsightsErrorImplCopyWithImpl(
      _$InsightsErrorImpl _value, $Res Function(_$InsightsErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$InsightsErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InsightsErrorImpl implements InsightsError {
  const _$InsightsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'InsightsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightsErrorImplCopyWith<_$InsightsErrorImpl> get copyWith =>
      __$$InsightsErrorImplCopyWithImpl<_$InsightsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Post> posts) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> posts)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> posts)? success,
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
    required TResult Function(InsightsInitial value) initial,
    required TResult Function(InsightsLoading value) loading,
    required TResult Function(InsightsSuccess value) success,
    required TResult Function(InsightsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InsightsInitial value)? initial,
    TResult? Function(InsightsLoading value)? loading,
    TResult? Function(InsightsSuccess value)? success,
    TResult? Function(InsightsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InsightsInitial value)? initial,
    TResult Function(InsightsLoading value)? loading,
    TResult Function(InsightsSuccess value)? success,
    TResult Function(InsightsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class InsightsError implements InsightsState {
  const factory InsightsError(final String message) = _$InsightsErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$InsightsErrorImplCopyWith<_$InsightsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
