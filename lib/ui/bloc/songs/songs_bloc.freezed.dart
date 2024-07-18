// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'songs_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SongsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query) get,
    required TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)
        edit,
    required TResult Function(IcocUser? user, SongDetail song) add,
    required TResult Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)
        update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query)? get,
    TResult? Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult? Function(IcocUser? user, SongDetail song)? add,
    TResult? Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)?
        update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query)? get,
    TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult Function(IcocUser? user, SongDetail song)? add,
    TResult Function(IcocUser? user, SongDetail song, String lang, String title,
            String? description, String? link, String text)?
        update,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SongsGet value) get,
    required TResult Function(SongsEdit value) edit,
    required TResult Function(SongsAdd value) add,
    required TResult Function(SongsUpdate value) update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SongsGet value)? get,
    TResult? Function(SongsEdit value)? edit,
    TResult? Function(SongsAdd value)? add,
    TResult? Function(SongsUpdate value)? update,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SongsGet value)? get,
    TResult Function(SongsEdit value)? edit,
    TResult Function(SongsAdd value)? add,
    TResult Function(SongsUpdate value)? update,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongsEventCopyWith<$Res> {
  factory $SongsEventCopyWith(
          SongsEvent value, $Res Function(SongsEvent) then) =
      _$SongsEventCopyWithImpl<$Res, SongsEvent>;
}

/// @nodoc
class _$SongsEventCopyWithImpl<$Res, $Val extends SongsEvent>
    implements $SongsEventCopyWith<$Res> {
  _$SongsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SongsGetImplCopyWith<$Res> {
  factory _$$SongsGetImplCopyWith(
          _$SongsGetImpl value, $Res Function(_$SongsGetImpl) then) =
      __$$SongsGetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? query});
}

/// @nodoc
class __$$SongsGetImplCopyWithImpl<$Res>
    extends _$SongsEventCopyWithImpl<$Res, _$SongsGetImpl>
    implements _$$SongsGetImplCopyWith<$Res> {
  __$$SongsGetImplCopyWithImpl(
      _$SongsGetImpl _value, $Res Function(_$SongsGetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
  }) {
    return _then(_$SongsGetImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SongsGetImpl implements SongsGet {
  const _$SongsGetImpl({this.query});

  @override
  final String? query;

  @override
  String toString() {
    return 'SongsEvent.get(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongsGetImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongsGetImplCopyWith<_$SongsGetImpl> get copyWith =>
      __$$SongsGetImplCopyWithImpl<_$SongsGetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query) get,
    required TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)
        edit,
    required TResult Function(IcocUser? user, SongDetail song) add,
    required TResult Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)
        update,
  }) {
    return get(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query)? get,
    TResult? Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult? Function(IcocUser? user, SongDetail song)? add,
    TResult? Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)?
        update,
  }) {
    return get?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query)? get,
    TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult Function(IcocUser? user, SongDetail song)? add,
    TResult Function(IcocUser? user, SongDetail song, String lang, String title,
            String? description, String? link, String text)?
        update,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SongsGet value) get,
    required TResult Function(SongsEdit value) edit,
    required TResult Function(SongsAdd value) add,
    required TResult Function(SongsUpdate value) update,
  }) {
    return get(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SongsGet value)? get,
    TResult? Function(SongsEdit value)? edit,
    TResult? Function(SongsAdd value)? add,
    TResult? Function(SongsUpdate value)? update,
  }) {
    return get?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SongsGet value)? get,
    TResult Function(SongsEdit value)? edit,
    TResult Function(SongsAdd value)? add,
    TResult Function(SongsUpdate value)? update,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get(this);
    }
    return orElse();
  }
}

abstract class SongsGet implements SongsEvent {
  const factory SongsGet({final String? query}) = _$SongsGetImpl;

  String? get query;
  @JsonKey(ignore: true)
  _$$SongsGetImplCopyWith<_$SongsGetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SongsEditImplCopyWith<$Res> {
  factory _$$SongsEditImplCopyWith(
          _$SongsEditImpl value, $Res Function(_$SongsEditImpl) then) =
      __$$SongsEditImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {SongDetail song,
      String textVersion,
      String title,
      IcocUser? user,
      String description,
      String link,
      String text});
}

/// @nodoc
class __$$SongsEditImplCopyWithImpl<$Res>
    extends _$SongsEventCopyWithImpl<$Res, _$SongsEditImpl>
    implements _$$SongsEditImplCopyWith<$Res> {
  __$$SongsEditImplCopyWithImpl(
      _$SongsEditImpl _value, $Res Function(_$SongsEditImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = null,
    Object? textVersion = null,
    Object? title = null,
    Object? user = freezed,
    Object? description = null,
    Object? link = null,
    Object? text = null,
  }) {
    return _then(_$SongsEditImpl(
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as SongDetail,
      textVersion: null == textVersion
          ? _value.textVersion
          : textVersion // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SongsEditImpl implements SongsEdit {
  const _$SongsEditImpl(
      {required this.song,
      required this.textVersion,
      required this.title,
      required this.user,
      required this.description,
      required this.link,
      required this.text});

  @override
  final SongDetail song;
  @override
  final String textVersion;
  @override
  final String title;
  @override
  final IcocUser? user;
  @override
  final String description;
  @override
  final String link;
  @override
  final String text;

  @override
  String toString() {
    return 'SongsEvent.edit(song: $song, textVersion: $textVersion, title: $title, user: $user, description: $description, link: $link, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongsEditImpl &&
            (identical(other.song, song) || other.song == song) &&
            (identical(other.textVersion, textVersion) ||
                other.textVersion == textVersion) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, song, textVersion, title, user, description, link, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongsEditImplCopyWith<_$SongsEditImpl> get copyWith =>
      __$$SongsEditImplCopyWithImpl<_$SongsEditImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query) get,
    required TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)
        edit,
    required TResult Function(IcocUser? user, SongDetail song) add,
    required TResult Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)
        update,
  }) {
    return edit(song, textVersion, title, user, description, link, text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query)? get,
    TResult? Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult? Function(IcocUser? user, SongDetail song)? add,
    TResult? Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)?
        update,
  }) {
    return edit?.call(song, textVersion, title, user, description, link, text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query)? get,
    TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult Function(IcocUser? user, SongDetail song)? add,
    TResult Function(IcocUser? user, SongDetail song, String lang, String title,
            String? description, String? link, String text)?
        update,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(song, textVersion, title, user, description, link, text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SongsGet value) get,
    required TResult Function(SongsEdit value) edit,
    required TResult Function(SongsAdd value) add,
    required TResult Function(SongsUpdate value) update,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SongsGet value)? get,
    TResult? Function(SongsEdit value)? edit,
    TResult? Function(SongsAdd value)? add,
    TResult? Function(SongsUpdate value)? update,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SongsGet value)? get,
    TResult Function(SongsEdit value)? edit,
    TResult Function(SongsAdd value)? add,
    TResult Function(SongsUpdate value)? update,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class SongsEdit implements SongsEvent {
  const factory SongsEdit(
      {required final SongDetail song,
      required final String textVersion,
      required final String title,
      required final IcocUser? user,
      required final String description,
      required final String link,
      required final String text}) = _$SongsEditImpl;

  SongDetail get song;
  String get textVersion;
  String get title;
  IcocUser? get user;
  String get description;
  String get link;
  String get text;
  @JsonKey(ignore: true)
  _$$SongsEditImplCopyWith<_$SongsEditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SongsAddImplCopyWith<$Res> {
  factory _$$SongsAddImplCopyWith(
          _$SongsAddImpl value, $Res Function(_$SongsAddImpl) then) =
      __$$SongsAddImplCopyWithImpl<$Res>;
  @useResult
  $Res call({IcocUser? user, SongDetail song});
}

/// @nodoc
class __$$SongsAddImplCopyWithImpl<$Res>
    extends _$SongsEventCopyWithImpl<$Res, _$SongsAddImpl>
    implements _$$SongsAddImplCopyWith<$Res> {
  __$$SongsAddImplCopyWithImpl(
      _$SongsAddImpl _value, $Res Function(_$SongsAddImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? song = null,
  }) {
    return _then(_$SongsAddImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as SongDetail,
    ));
  }
}

/// @nodoc

class _$SongsAddImpl implements SongsAdd {
  const _$SongsAddImpl({required this.user, required this.song});

  @override
  final IcocUser? user;
  @override
  final SongDetail song;

  @override
  String toString() {
    return 'SongsEvent.add(user: $user, song: $song)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongsAddImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.song, song) || other.song == song));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, song);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongsAddImplCopyWith<_$SongsAddImpl> get copyWith =>
      __$$SongsAddImplCopyWithImpl<_$SongsAddImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query) get,
    required TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)
        edit,
    required TResult Function(IcocUser? user, SongDetail song) add,
    required TResult Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)
        update,
  }) {
    return add(user, song);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query)? get,
    TResult? Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult? Function(IcocUser? user, SongDetail song)? add,
    TResult? Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)?
        update,
  }) {
    return add?.call(user, song);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query)? get,
    TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult Function(IcocUser? user, SongDetail song)? add,
    TResult Function(IcocUser? user, SongDetail song, String lang, String title,
            String? description, String? link, String text)?
        update,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(user, song);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SongsGet value) get,
    required TResult Function(SongsEdit value) edit,
    required TResult Function(SongsAdd value) add,
    required TResult Function(SongsUpdate value) update,
  }) {
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SongsGet value)? get,
    TResult? Function(SongsEdit value)? edit,
    TResult? Function(SongsAdd value)? add,
    TResult? Function(SongsUpdate value)? update,
  }) {
    return add?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SongsGet value)? get,
    TResult Function(SongsEdit value)? edit,
    TResult Function(SongsAdd value)? add,
    TResult Function(SongsUpdate value)? update,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class SongsAdd implements SongsEvent {
  const factory SongsAdd(
      {required final IcocUser? user,
      required final SongDetail song}) = _$SongsAddImpl;

  IcocUser? get user;
  SongDetail get song;
  @JsonKey(ignore: true)
  _$$SongsAddImplCopyWith<_$SongsAddImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SongsUpdateImplCopyWith<$Res> {
  factory _$$SongsUpdateImplCopyWith(
          _$SongsUpdateImpl value, $Res Function(_$SongsUpdateImpl) then) =
      __$$SongsUpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {IcocUser? user,
      SongDetail song,
      String lang,
      String title,
      String? description,
      String? link,
      String text});
}

/// @nodoc
class __$$SongsUpdateImplCopyWithImpl<$Res>
    extends _$SongsEventCopyWithImpl<$Res, _$SongsUpdateImpl>
    implements _$$SongsUpdateImplCopyWith<$Res> {
  __$$SongsUpdateImplCopyWithImpl(
      _$SongsUpdateImpl _value, $Res Function(_$SongsUpdateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? song = null,
    Object? lang = null,
    Object? title = null,
    Object? description = freezed,
    Object? link = freezed,
    Object? text = null,
  }) {
    return _then(_$SongsUpdateImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as IcocUser?,
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as SongDetail,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SongsUpdateImpl implements SongsUpdate {
  const _$SongsUpdateImpl(
      {required this.user,
      required this.song,
      required this.lang,
      required this.title,
      this.description,
      this.link,
      required this.text});

  @override
  final IcocUser? user;
  @override
  final SongDetail song;
  @override
  final String lang;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? link;
  @override
  final String text;

  @override
  String toString() {
    return 'SongsEvent.update(user: $user, song: $song, lang: $lang, title: $title, description: $description, link: $link, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongsUpdateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.song, song) || other.song == song) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, user, song, lang, title, description, link, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongsUpdateImplCopyWith<_$SongsUpdateImpl> get copyWith =>
      __$$SongsUpdateImplCopyWithImpl<_$SongsUpdateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? query) get,
    required TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)
        edit,
    required TResult Function(IcocUser? user, SongDetail song) add,
    required TResult Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)
        update,
  }) {
    return update(user, song, lang, title, description, link, text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? query)? get,
    TResult? Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult? Function(IcocUser? user, SongDetail song)? add,
    TResult? Function(IcocUser? user, SongDetail song, String lang,
            String title, String? description, String? link, String text)?
        update,
  }) {
    return update?.call(user, song, lang, title, description, link, text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? query)? get,
    TResult Function(SongDetail song, String textVersion, String title,
            IcocUser? user, String description, String link, String text)?
        edit,
    TResult Function(IcocUser? user, SongDetail song)? add,
    TResult Function(IcocUser? user, SongDetail song, String lang, String title,
            String? description, String? link, String text)?
        update,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(user, song, lang, title, description, link, text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SongsGet value) get,
    required TResult Function(SongsEdit value) edit,
    required TResult Function(SongsAdd value) add,
    required TResult Function(SongsUpdate value) update,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SongsGet value)? get,
    TResult? Function(SongsEdit value)? edit,
    TResult? Function(SongsAdd value)? add,
    TResult? Function(SongsUpdate value)? update,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SongsGet value)? get,
    TResult Function(SongsEdit value)? edit,
    TResult Function(SongsAdd value)? add,
    TResult Function(SongsUpdate value)? update,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class SongsUpdate implements SongsEvent {
  const factory SongsUpdate(
      {required final IcocUser? user,
      required final SongDetail song,
      required final String lang,
      required final String title,
      final String? description,
      final String? link,
      required final String text}) = _$SongsUpdateImpl;

  IcocUser? get user;
  SongDetail get song;
  String get lang;
  String get title;
  String? get description;
  String? get link;
  String get text;
  @JsonKey(ignore: true)
  _$$SongsUpdateImplCopyWith<_$SongsUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SongsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<SongDetail> songs) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<SongDetail> songs)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<SongDetail> songs)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_SongsLoadingState value) loading,
    required TResult Function(_SongsErrorState value) error,
    required TResult Function(_GetSongsSuccessState value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_SongsLoadingState value)? loading,
    TResult? Function(_SongsErrorState value)? error,
    TResult? Function(_GetSongsSuccessState value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_SongsLoadingState value)? loading,
    TResult Function(_SongsErrorState value)? error,
    TResult Function(_GetSongsSuccessState value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongsStateCopyWith<$Res> {
  factory $SongsStateCopyWith(
          SongsState value, $Res Function(SongsState) then) =
      _$SongsStateCopyWithImpl<$Res, SongsState>;
}

/// @nodoc
class _$SongsStateCopyWithImpl<$Res, $Val extends SongsState>
    implements $SongsStateCopyWith<$Res> {
  _$SongsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialStateImplCopyWith<$Res> {
  factory _$$InitialStateImplCopyWith(
          _$InitialStateImpl value, $Res Function(_$InitialStateImpl) then) =
      __$$InitialStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialStateImplCopyWithImpl<$Res>
    extends _$SongsStateCopyWithImpl<$Res, _$InitialStateImpl>
    implements _$$InitialStateImplCopyWith<$Res> {
  __$$InitialStateImplCopyWithImpl(
      _$InitialStateImpl _value, $Res Function(_$InitialStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialStateImpl implements _InitialState {
  const _$InitialStateImpl();

  @override
  String toString() {
    return 'SongsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<SongDetail> songs) success,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<SongDetail> songs)? success,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<SongDetail> songs)? success,
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
    required TResult Function(_InitialState value) initial,
    required TResult Function(_SongsLoadingState value) loading,
    required TResult Function(_SongsErrorState value) error,
    required TResult Function(_GetSongsSuccessState value) success,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_SongsLoadingState value)? loading,
    TResult? Function(_SongsErrorState value)? error,
    TResult? Function(_GetSongsSuccessState value)? success,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_SongsLoadingState value)? loading,
    TResult Function(_SongsErrorState value)? error,
    TResult Function(_GetSongsSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialState implements SongsState {
  const factory _InitialState() = _$InitialStateImpl;
}

/// @nodoc
abstract class _$$SongsLoadingStateImplCopyWith<$Res> {
  factory _$$SongsLoadingStateImplCopyWith(_$SongsLoadingStateImpl value,
          $Res Function(_$SongsLoadingStateImpl) then) =
      __$$SongsLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SongsLoadingStateImplCopyWithImpl<$Res>
    extends _$SongsStateCopyWithImpl<$Res, _$SongsLoadingStateImpl>
    implements _$$SongsLoadingStateImplCopyWith<$Res> {
  __$$SongsLoadingStateImplCopyWithImpl(_$SongsLoadingStateImpl _value,
      $Res Function(_$SongsLoadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SongsLoadingStateImpl implements _SongsLoadingState {
  const _$SongsLoadingStateImpl();

  @override
  String toString() {
    return 'SongsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SongsLoadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<SongDetail> songs) success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<SongDetail> songs)? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<SongDetail> songs)? success,
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
    required TResult Function(_InitialState value) initial,
    required TResult Function(_SongsLoadingState value) loading,
    required TResult Function(_SongsErrorState value) error,
    required TResult Function(_GetSongsSuccessState value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_SongsLoadingState value)? loading,
    TResult? Function(_SongsErrorState value)? error,
    TResult? Function(_GetSongsSuccessState value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_SongsLoadingState value)? loading,
    TResult Function(_SongsErrorState value)? error,
    TResult Function(_GetSongsSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _SongsLoadingState implements SongsState {
  const factory _SongsLoadingState() = _$SongsLoadingStateImpl;
}

/// @nodoc
abstract class _$$SongsErrorStateImplCopyWith<$Res> {
  factory _$$SongsErrorStateImplCopyWith(_$SongsErrorStateImpl value,
          $Res Function(_$SongsErrorStateImpl) then) =
      __$$SongsErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$SongsErrorStateImplCopyWithImpl<$Res>
    extends _$SongsStateCopyWithImpl<$Res, _$SongsErrorStateImpl>
    implements _$$SongsErrorStateImplCopyWith<$Res> {
  __$$SongsErrorStateImplCopyWithImpl(
      _$SongsErrorStateImpl _value, $Res Function(_$SongsErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$SongsErrorStateImpl(
      null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SongsErrorStateImpl implements _SongsErrorState {
  const _$SongsErrorStateImpl(this.errorMessage);

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'SongsState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongsErrorStateImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongsErrorStateImplCopyWith<_$SongsErrorStateImpl> get copyWith =>
      __$$SongsErrorStateImplCopyWithImpl<_$SongsErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<SongDetail> songs) success,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<SongDetail> songs)? success,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<SongDetail> songs)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_SongsLoadingState value) loading,
    required TResult Function(_SongsErrorState value) error,
    required TResult Function(_GetSongsSuccessState value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_SongsLoadingState value)? loading,
    TResult? Function(_SongsErrorState value)? error,
    TResult? Function(_GetSongsSuccessState value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_SongsLoadingState value)? loading,
    TResult Function(_SongsErrorState value)? error,
    TResult Function(_GetSongsSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _SongsErrorState implements SongsState {
  const factory _SongsErrorState(final String errorMessage) =
      _$SongsErrorStateImpl;

  String get errorMessage;
  @JsonKey(ignore: true)
  _$$SongsErrorStateImplCopyWith<_$SongsErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetSongsSuccessStateImplCopyWith<$Res> {
  factory _$$GetSongsSuccessStateImplCopyWith(_$GetSongsSuccessStateImpl value,
          $Res Function(_$GetSongsSuccessStateImpl) then) =
      __$$GetSongsSuccessStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SongDetail> songs});
}

/// @nodoc
class __$$GetSongsSuccessStateImplCopyWithImpl<$Res>
    extends _$SongsStateCopyWithImpl<$Res, _$GetSongsSuccessStateImpl>
    implements _$$GetSongsSuccessStateImplCopyWith<$Res> {
  __$$GetSongsSuccessStateImplCopyWithImpl(_$GetSongsSuccessStateImpl _value,
      $Res Function(_$GetSongsSuccessStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songs = null,
  }) {
    return _then(_$GetSongsSuccessStateImpl(
      null == songs
          ? _value._songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SongDetail>,
    ));
  }
}

/// @nodoc

class _$GetSongsSuccessStateImpl implements _GetSongsSuccessState {
  const _$GetSongsSuccessStateImpl(final List<SongDetail> songs)
      : _songs = songs;

  final List<SongDetail> _songs;
  @override
  List<SongDetail> get songs {
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songs);
  }

  @override
  String toString() {
    return 'SongsState.success(songs: $songs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetSongsSuccessStateImpl &&
            const DeepCollectionEquality().equals(other._songs, _songs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_songs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetSongsSuccessStateImplCopyWith<_$GetSongsSuccessStateImpl>
      get copyWith =>
          __$$GetSongsSuccessStateImplCopyWithImpl<_$GetSongsSuccessStateImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<SongDetail> songs) success,
  }) {
    return success(songs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<SongDetail> songs)? success,
  }) {
    return success?.call(songs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<SongDetail> songs)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(songs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_SongsLoadingState value) loading,
    required TResult Function(_SongsErrorState value) error,
    required TResult Function(_GetSongsSuccessState value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_SongsLoadingState value)? loading,
    TResult? Function(_SongsErrorState value)? error,
    TResult? Function(_GetSongsSuccessState value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_SongsLoadingState value)? loading,
    TResult Function(_SongsErrorState value)? error,
    TResult Function(_GetSongsSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _GetSongsSuccessState implements SongsState {
  const factory _GetSongsSuccessState(final List<SongDetail> songs) =
      _$GetSongsSuccessStateImpl;

  List<SongDetail> get songs;
  @JsonKey(ignore: true)
  _$$GetSongsSuccessStateImplCopyWith<_$GetSongsSuccessStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
