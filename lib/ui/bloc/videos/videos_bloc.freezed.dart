// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'videos_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideosEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(Playlist playlist) addPlaylist,
    required TResult Function(String playlistId) fetchFromPlaylist,
    required TResult Function(String videoId) fetchDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(Playlist playlist)? addPlaylist,
    TResult? Function(String playlistId)? fetchFromPlaylist,
    TResult? Function(String videoId)? fetchDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(Playlist playlist)? addPlaylist,
    TResult Function(String playlistId)? fetchFromPlaylist,
    TResult Function(String videoId)? fetchDetails,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VideosGet value) get,
    required TResult Function(VideosAddPlaylist value) addPlaylist,
    required TResult Function(VideosFetchFromPlaylist value) fetchFromPlaylist,
    required TResult Function(VideosFetchDetails value) fetchDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VideosGet value)? get,
    TResult? Function(VideosAddPlaylist value)? addPlaylist,
    TResult? Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult? Function(VideosFetchDetails value)? fetchDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VideosGet value)? get,
    TResult Function(VideosAddPlaylist value)? addPlaylist,
    TResult Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult Function(VideosFetchDetails value)? fetchDetails,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideosEventCopyWith<$Res> {
  factory $VideosEventCopyWith(
          VideosEvent value, $Res Function(VideosEvent) then) =
      _$VideosEventCopyWithImpl<$Res, VideosEvent>;
}

/// @nodoc
class _$VideosEventCopyWithImpl<$Res, $Val extends VideosEvent>
    implements $VideosEventCopyWith<$Res> {
  _$VideosEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$VideosGetImplCopyWith<$Res> {
  factory _$$VideosGetImplCopyWith(
          _$VideosGetImpl value, $Res Function(_$VideosGetImpl) then) =
      __$$VideosGetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VideosGetImplCopyWithImpl<$Res>
    extends _$VideosEventCopyWithImpl<$Res, _$VideosGetImpl>
    implements _$$VideosGetImplCopyWith<$Res> {
  __$$VideosGetImplCopyWithImpl(
      _$VideosGetImpl _value, $Res Function(_$VideosGetImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$VideosGetImpl implements VideosGet {
  const _$VideosGetImpl();

  @override
  String toString() {
    return 'VideosEvent.get()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VideosGetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(Playlist playlist) addPlaylist,
    required TResult Function(String playlistId) fetchFromPlaylist,
    required TResult Function(String videoId) fetchDetails,
  }) {
    return get();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(Playlist playlist)? addPlaylist,
    TResult? Function(String playlistId)? fetchFromPlaylist,
    TResult? Function(String videoId)? fetchDetails,
  }) {
    return get?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(Playlist playlist)? addPlaylist,
    TResult Function(String playlistId)? fetchFromPlaylist,
    TResult Function(String videoId)? fetchDetails,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VideosGet value) get,
    required TResult Function(VideosAddPlaylist value) addPlaylist,
    required TResult Function(VideosFetchFromPlaylist value) fetchFromPlaylist,
    required TResult Function(VideosFetchDetails value) fetchDetails,
  }) {
    return get(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VideosGet value)? get,
    TResult? Function(VideosAddPlaylist value)? addPlaylist,
    TResult? Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult? Function(VideosFetchDetails value)? fetchDetails,
  }) {
    return get?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VideosGet value)? get,
    TResult Function(VideosAddPlaylist value)? addPlaylist,
    TResult Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult Function(VideosFetchDetails value)? fetchDetails,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get(this);
    }
    return orElse();
  }
}

abstract class VideosGet implements VideosEvent {
  const factory VideosGet() = _$VideosGetImpl;
}

/// @nodoc
abstract class _$$VideosAddPlaylistImplCopyWith<$Res> {
  factory _$$VideosAddPlaylistImplCopyWith(_$VideosAddPlaylistImpl value,
          $Res Function(_$VideosAddPlaylistImpl) then) =
      __$$VideosAddPlaylistImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Playlist playlist});
}

/// @nodoc
class __$$VideosAddPlaylistImplCopyWithImpl<$Res>
    extends _$VideosEventCopyWithImpl<$Res, _$VideosAddPlaylistImpl>
    implements _$$VideosAddPlaylistImplCopyWith<$Res> {
  __$$VideosAddPlaylistImplCopyWithImpl(_$VideosAddPlaylistImpl _value,
      $Res Function(_$VideosAddPlaylistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlist = null,
  }) {
    return _then(_$VideosAddPlaylistImpl(
      null == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as Playlist,
    ));
  }
}

/// @nodoc

class _$VideosAddPlaylistImpl implements VideosAddPlaylist {
  const _$VideosAddPlaylistImpl(this.playlist);

  @override
  final Playlist playlist;

  @override
  String toString() {
    return 'VideosEvent.addPlaylist(playlist: $playlist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosAddPlaylistImpl &&
            (identical(other.playlist, playlist) ||
                other.playlist == playlist));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playlist);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosAddPlaylistImplCopyWith<_$VideosAddPlaylistImpl> get copyWith =>
      __$$VideosAddPlaylistImplCopyWithImpl<_$VideosAddPlaylistImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(Playlist playlist) addPlaylist,
    required TResult Function(String playlistId) fetchFromPlaylist,
    required TResult Function(String videoId) fetchDetails,
  }) {
    return addPlaylist(playlist);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(Playlist playlist)? addPlaylist,
    TResult? Function(String playlistId)? fetchFromPlaylist,
    TResult? Function(String videoId)? fetchDetails,
  }) {
    return addPlaylist?.call(playlist);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(Playlist playlist)? addPlaylist,
    TResult Function(String playlistId)? fetchFromPlaylist,
    TResult Function(String videoId)? fetchDetails,
    required TResult orElse(),
  }) {
    if (addPlaylist != null) {
      return addPlaylist(playlist);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VideosGet value) get,
    required TResult Function(VideosAddPlaylist value) addPlaylist,
    required TResult Function(VideosFetchFromPlaylist value) fetchFromPlaylist,
    required TResult Function(VideosFetchDetails value) fetchDetails,
  }) {
    return addPlaylist(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VideosGet value)? get,
    TResult? Function(VideosAddPlaylist value)? addPlaylist,
    TResult? Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult? Function(VideosFetchDetails value)? fetchDetails,
  }) {
    return addPlaylist?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VideosGet value)? get,
    TResult Function(VideosAddPlaylist value)? addPlaylist,
    TResult Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult Function(VideosFetchDetails value)? fetchDetails,
    required TResult orElse(),
  }) {
    if (addPlaylist != null) {
      return addPlaylist(this);
    }
    return orElse();
  }
}

abstract class VideosAddPlaylist implements VideosEvent {
  const factory VideosAddPlaylist(final Playlist playlist) =
      _$VideosAddPlaylistImpl;

  Playlist get playlist;
  @JsonKey(ignore: true)
  _$$VideosAddPlaylistImplCopyWith<_$VideosAddPlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VideosFetchFromPlaylistImplCopyWith<$Res> {
  factory _$$VideosFetchFromPlaylistImplCopyWith(
          _$VideosFetchFromPlaylistImpl value,
          $Res Function(_$VideosFetchFromPlaylistImpl) then) =
      __$$VideosFetchFromPlaylistImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String playlistId});
}

/// @nodoc
class __$$VideosFetchFromPlaylistImplCopyWithImpl<$Res>
    extends _$VideosEventCopyWithImpl<$Res, _$VideosFetchFromPlaylistImpl>
    implements _$$VideosFetchFromPlaylistImplCopyWith<$Res> {
  __$$VideosFetchFromPlaylistImplCopyWithImpl(
      _$VideosFetchFromPlaylistImpl _value,
      $Res Function(_$VideosFetchFromPlaylistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = null,
  }) {
    return _then(_$VideosFetchFromPlaylistImpl(
      null == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$VideosFetchFromPlaylistImpl implements VideosFetchFromPlaylist {
  const _$VideosFetchFromPlaylistImpl(this.playlistId);

  @override
  final String playlistId;

  @override
  String toString() {
    return 'VideosEvent.fetchFromPlaylist(playlistId: $playlistId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosFetchFromPlaylistImpl &&
            (identical(other.playlistId, playlistId) ||
                other.playlistId == playlistId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, playlistId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosFetchFromPlaylistImplCopyWith<_$VideosFetchFromPlaylistImpl>
      get copyWith => __$$VideosFetchFromPlaylistImplCopyWithImpl<
          _$VideosFetchFromPlaylistImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(Playlist playlist) addPlaylist,
    required TResult Function(String playlistId) fetchFromPlaylist,
    required TResult Function(String videoId) fetchDetails,
  }) {
    return fetchFromPlaylist(playlistId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(Playlist playlist)? addPlaylist,
    TResult? Function(String playlistId)? fetchFromPlaylist,
    TResult? Function(String videoId)? fetchDetails,
  }) {
    return fetchFromPlaylist?.call(playlistId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(Playlist playlist)? addPlaylist,
    TResult Function(String playlistId)? fetchFromPlaylist,
    TResult Function(String videoId)? fetchDetails,
    required TResult orElse(),
  }) {
    if (fetchFromPlaylist != null) {
      return fetchFromPlaylist(playlistId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VideosGet value) get,
    required TResult Function(VideosAddPlaylist value) addPlaylist,
    required TResult Function(VideosFetchFromPlaylist value) fetchFromPlaylist,
    required TResult Function(VideosFetchDetails value) fetchDetails,
  }) {
    return fetchFromPlaylist(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VideosGet value)? get,
    TResult? Function(VideosAddPlaylist value)? addPlaylist,
    TResult? Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult? Function(VideosFetchDetails value)? fetchDetails,
  }) {
    return fetchFromPlaylist?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VideosGet value)? get,
    TResult Function(VideosAddPlaylist value)? addPlaylist,
    TResult Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult Function(VideosFetchDetails value)? fetchDetails,
    required TResult orElse(),
  }) {
    if (fetchFromPlaylist != null) {
      return fetchFromPlaylist(this);
    }
    return orElse();
  }
}

abstract class VideosFetchFromPlaylist implements VideosEvent {
  const factory VideosFetchFromPlaylist(final String playlistId) =
      _$VideosFetchFromPlaylistImpl;

  String get playlistId;
  @JsonKey(ignore: true)
  _$$VideosFetchFromPlaylistImplCopyWith<_$VideosFetchFromPlaylistImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VideosFetchDetailsImplCopyWith<$Res> {
  factory _$$VideosFetchDetailsImplCopyWith(_$VideosFetchDetailsImpl value,
          $Res Function(_$VideosFetchDetailsImpl) then) =
      __$$VideosFetchDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String videoId});
}

/// @nodoc
class __$$VideosFetchDetailsImplCopyWithImpl<$Res>
    extends _$VideosEventCopyWithImpl<$Res, _$VideosFetchDetailsImpl>
    implements _$$VideosFetchDetailsImplCopyWith<$Res> {
  __$$VideosFetchDetailsImplCopyWithImpl(_$VideosFetchDetailsImpl _value,
      $Res Function(_$VideosFetchDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
  }) {
    return _then(_$VideosFetchDetailsImpl(
      null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$VideosFetchDetailsImpl implements VideosFetchDetails {
  const _$VideosFetchDetailsImpl(this.videoId);

  @override
  final String videoId;

  @override
  String toString() {
    return 'VideosEvent.fetchDetails(videoId: $videoId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosFetchDetailsImpl &&
            (identical(other.videoId, videoId) || other.videoId == videoId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, videoId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosFetchDetailsImplCopyWith<_$VideosFetchDetailsImpl> get copyWith =>
      __$$VideosFetchDetailsImplCopyWithImpl<_$VideosFetchDetailsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(Playlist playlist) addPlaylist,
    required TResult Function(String playlistId) fetchFromPlaylist,
    required TResult Function(String videoId) fetchDetails,
  }) {
    return fetchDetails(videoId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(Playlist playlist)? addPlaylist,
    TResult? Function(String playlistId)? fetchFromPlaylist,
    TResult? Function(String videoId)? fetchDetails,
  }) {
    return fetchDetails?.call(videoId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(Playlist playlist)? addPlaylist,
    TResult Function(String playlistId)? fetchFromPlaylist,
    TResult Function(String videoId)? fetchDetails,
    required TResult orElse(),
  }) {
    if (fetchDetails != null) {
      return fetchDetails(videoId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VideosGet value) get,
    required TResult Function(VideosAddPlaylist value) addPlaylist,
    required TResult Function(VideosFetchFromPlaylist value) fetchFromPlaylist,
    required TResult Function(VideosFetchDetails value) fetchDetails,
  }) {
    return fetchDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VideosGet value)? get,
    TResult? Function(VideosAddPlaylist value)? addPlaylist,
    TResult? Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult? Function(VideosFetchDetails value)? fetchDetails,
  }) {
    return fetchDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VideosGet value)? get,
    TResult Function(VideosAddPlaylist value)? addPlaylist,
    TResult Function(VideosFetchFromPlaylist value)? fetchFromPlaylist,
    TResult Function(VideosFetchDetails value)? fetchDetails,
    required TResult orElse(),
  }) {
    if (fetchDetails != null) {
      return fetchDetails(this);
    }
    return orElse();
  }
}

abstract class VideosFetchDetails implements VideosEvent {
  const factory VideosFetchDetails(final String videoId) =
      _$VideosFetchDetailsImpl;

  String get videoId;
  @JsonKey(ignore: true)
  _$$VideosFetchDetailsImplCopyWith<_$VideosFetchDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VideosState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideosStateCopyWith<$Res> {
  factory $VideosStateCopyWith(
          VideosState value, $Res Function(VideosState) then) =
      _$VideosStateCopyWithImpl<$Res, VideosState>;
}

/// @nodoc
class _$VideosStateCopyWithImpl<$Res, $Val extends VideosState>
    implements $VideosStateCopyWith<$Res> {
  _$VideosStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$VideosInitialStateImplCopyWith<$Res> {
  factory _$$VideosInitialStateImplCopyWith(_$VideosInitialStateImpl value,
          $Res Function(_$VideosInitialStateImpl) then) =
      __$$VideosInitialStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VideosInitialStateImplCopyWithImpl<$Res>
    extends _$VideosStateCopyWithImpl<$Res, _$VideosInitialStateImpl>
    implements _$$VideosInitialStateImplCopyWith<$Res> {
  __$$VideosInitialStateImplCopyWithImpl(_$VideosInitialStateImpl _value,
      $Res Function(_$VideosInitialStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$VideosInitialStateImpl implements _VideosInitialState {
  const _$VideosInitialStateImpl();

  @override
  String toString() {
    return 'VideosState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VideosInitialStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
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
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _VideosInitialState implements VideosState {
  const factory _VideosInitialState() = _$VideosInitialStateImpl;
}

/// @nodoc
abstract class _$$VideosLoadingStateImplCopyWith<$Res> {
  factory _$$VideosLoadingStateImplCopyWith(_$VideosLoadingStateImpl value,
          $Res Function(_$VideosLoadingStateImpl) then) =
      __$$VideosLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VideosLoadingStateImplCopyWithImpl<$Res>
    extends _$VideosStateCopyWithImpl<$Res, _$VideosLoadingStateImpl>
    implements _$$VideosLoadingStateImplCopyWith<$Res> {
  __$$VideosLoadingStateImplCopyWithImpl(_$VideosLoadingStateImpl _value,
      $Res Function(_$VideosLoadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$VideosLoadingStateImpl implements _VideosLoadingState {
  const _$VideosLoadingStateImpl();

  @override
  String toString() {
    return 'VideosState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VideosLoadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
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
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _VideosLoadingState implements VideosState {
  const factory _VideosLoadingState() = _$VideosLoadingStateImpl;
}

/// @nodoc
abstract class _$$VideosErrorStateImplCopyWith<$Res> {
  factory _$$VideosErrorStateImplCopyWith(_$VideosErrorStateImpl value,
          $Res Function(_$VideosErrorStateImpl) then) =
      __$$VideosErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$VideosErrorStateImplCopyWithImpl<$Res>
    extends _$VideosStateCopyWithImpl<$Res, _$VideosErrorStateImpl>
    implements _$$VideosErrorStateImplCopyWith<$Res> {
  __$$VideosErrorStateImplCopyWithImpl(_$VideosErrorStateImpl _value,
      $Res Function(_$VideosErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$VideosErrorStateImpl(
      null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$VideosErrorStateImpl implements _VideosErrorState {
  const _$VideosErrorStateImpl(this.errorMessage);

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'VideosState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosErrorStateImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosErrorStateImplCopyWith<_$VideosErrorStateImpl> get copyWith =>
      __$$VideosErrorStateImplCopyWithImpl<_$VideosErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
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
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _VideosErrorState implements VideosState {
  const factory _VideosErrorState(final String errorMessage) =
      _$VideosErrorStateImpl;

  String get errorMessage;
  @JsonKey(ignore: true)
  _$$VideosErrorStateImplCopyWith<_$VideosErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VideosSuccessStateImplCopyWith<$Res> {
  factory _$$VideosSuccessStateImplCopyWith(_$VideosSuccessStateImpl value,
          $Res Function(_$VideosSuccessStateImpl) then) =
      __$$VideosSuccessStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Playlist> playlists});
}

/// @nodoc
class __$$VideosSuccessStateImplCopyWithImpl<$Res>
    extends _$VideosStateCopyWithImpl<$Res, _$VideosSuccessStateImpl>
    implements _$$VideosSuccessStateImplCopyWith<$Res> {
  __$$VideosSuccessStateImplCopyWithImpl(_$VideosSuccessStateImpl _value,
      $Res Function(_$VideosSuccessStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlists = null,
  }) {
    return _then(_$VideosSuccessStateImpl(
      null == playlists
          ? _value._playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as List<Playlist>,
    ));
  }
}

/// @nodoc

class _$VideosSuccessStateImpl implements _VideosSuccessState {
  const _$VideosSuccessStateImpl(final List<Playlist> playlists)
      : _playlists = playlists;

  final List<Playlist> _playlists;
  @override
  List<Playlist> get playlists {
    if (_playlists is EqualUnmodifiableListView) return _playlists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playlists);
  }

  @override
  String toString() {
    return 'VideosState.success(playlists: $playlists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosSuccessStateImpl &&
            const DeepCollectionEquality()
                .equals(other._playlists, _playlists));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_playlists));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosSuccessStateImplCopyWith<_$VideosSuccessStateImpl> get copyWith =>
      __$$VideosSuccessStateImplCopyWithImpl<_$VideosSuccessStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) {
    return success(playlists);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) {
    return success?.call(playlists);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(playlists);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _VideosSuccessState implements VideosState {
  const factory _VideosSuccessState(final List<Playlist> playlists) =
      _$VideosSuccessStateImpl;

  List<Playlist> get playlists;
  @JsonKey(ignore: true)
  _$$VideosSuccessStateImplCopyWith<_$VideosSuccessStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VideosPlaylistVideosStateImplCopyWith<$Res> {
  factory _$$VideosPlaylistVideosStateImplCopyWith(
          _$VideosPlaylistVideosStateImpl value,
          $Res Function(_$VideosPlaylistVideosStateImpl) then) =
      __$$VideosPlaylistVideosStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Resources>? resources});
}

/// @nodoc
class __$$VideosPlaylistVideosStateImplCopyWithImpl<$Res>
    extends _$VideosStateCopyWithImpl<$Res, _$VideosPlaylistVideosStateImpl>
    implements _$$VideosPlaylistVideosStateImplCopyWith<$Res> {
  __$$VideosPlaylistVideosStateImplCopyWithImpl(
      _$VideosPlaylistVideosStateImpl _value,
      $Res Function(_$VideosPlaylistVideosStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resources = freezed,
  }) {
    return _then(_$VideosPlaylistVideosStateImpl(
      freezed == resources
          ? _value._resources
          : resources // ignore: cast_nullable_to_non_nullable
              as List<Resources>?,
    ));
  }
}

/// @nodoc

class _$VideosPlaylistVideosStateImpl implements _VideosPlaylistVideosState {
  const _$VideosPlaylistVideosStateImpl(final List<Resources>? resources)
      : _resources = resources;

  final List<Resources>? _resources;
  @override
  List<Resources>? get resources {
    final value = _resources;
    if (value == null) return null;
    if (_resources is EqualUnmodifiableListView) return _resources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'VideosState.playlistVideos(resources: $resources)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosPlaylistVideosStateImpl &&
            const DeepCollectionEquality()
                .equals(other._resources, _resources));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_resources));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosPlaylistVideosStateImplCopyWith<_$VideosPlaylistVideosStateImpl>
      get copyWith => __$$VideosPlaylistVideosStateImplCopyWithImpl<
          _$VideosPlaylistVideosStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) {
    return playlistVideos(resources);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) {
    return playlistVideos?.call(resources);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
    required TResult orElse(),
  }) {
    if (playlistVideos != null) {
      return playlistVideos(resources);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) {
    return playlistVideos(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) {
    return playlistVideos?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) {
    if (playlistVideos != null) {
      return playlistVideos(this);
    }
    return orElse();
  }
}

abstract class _VideosPlaylistVideosState implements VideosState {
  const factory _VideosPlaylistVideosState(final List<Resources>? resources) =
      _$VideosPlaylistVideosStateImpl;

  List<Resources>? get resources;
  @JsonKey(ignore: true)
  _$$VideosPlaylistVideosStateImplCopyWith<_$VideosPlaylistVideosStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VideosDetailsStateImplCopyWith<$Res> {
  factory _$$VideosDetailsStateImplCopyWith(_$VideosDetailsStateImpl value,
          $Res Function(_$VideosDetailsStateImpl) then) =
      __$$VideosDetailsStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Resources? videoDetails});
}

/// @nodoc
class __$$VideosDetailsStateImplCopyWithImpl<$Res>
    extends _$VideosStateCopyWithImpl<$Res, _$VideosDetailsStateImpl>
    implements _$$VideosDetailsStateImplCopyWith<$Res> {
  __$$VideosDetailsStateImplCopyWithImpl(_$VideosDetailsStateImpl _value,
      $Res Function(_$VideosDetailsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoDetails = freezed,
  }) {
    return _then(_$VideosDetailsStateImpl(
      freezed == videoDetails
          ? _value.videoDetails
          : videoDetails // ignore: cast_nullable_to_non_nullable
              as Resources?,
    ));
  }
}

/// @nodoc

class _$VideosDetailsStateImpl implements _VideosDetailsState {
  const _$VideosDetailsStateImpl(this.videoDetails);

  @override
  final Resources? videoDetails;

  @override
  String toString() {
    return 'VideosState.videoDetails(videoDetails: $videoDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosDetailsStateImpl &&
            (identical(other.videoDetails, videoDetails) ||
                other.videoDetails == videoDetails));
  }

  @override
  int get hashCode => Object.hash(runtimeType, videoDetails);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosDetailsStateImplCopyWith<_$VideosDetailsStateImpl> get copyWith =>
      __$$VideosDetailsStateImplCopyWithImpl<_$VideosDetailsStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Playlist> playlists) success,
    required TResult Function(List<Resources>? resources) playlistVideos,
    required TResult Function(Resources? videoDetails) videoDetails,
  }) {
    return videoDetails(this.videoDetails);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Playlist> playlists)? success,
    TResult? Function(List<Resources>? resources)? playlistVideos,
    TResult? Function(Resources? videoDetails)? videoDetails,
  }) {
    return videoDetails?.call(this.videoDetails);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Playlist> playlists)? success,
    TResult Function(List<Resources>? resources)? playlistVideos,
    TResult Function(Resources? videoDetails)? videoDetails,
    required TResult orElse(),
  }) {
    if (videoDetails != null) {
      return videoDetails(this.videoDetails);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VideosInitialState value) initial,
    required TResult Function(_VideosLoadingState value) loading,
    required TResult Function(_VideosErrorState value) error,
    required TResult Function(_VideosSuccessState value) success,
    required TResult Function(_VideosPlaylistVideosState value) playlistVideos,
    required TResult Function(_VideosDetailsState value) videoDetails,
  }) {
    return videoDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VideosInitialState value)? initial,
    TResult? Function(_VideosLoadingState value)? loading,
    TResult? Function(_VideosErrorState value)? error,
    TResult? Function(_VideosSuccessState value)? success,
    TResult? Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult? Function(_VideosDetailsState value)? videoDetails,
  }) {
    return videoDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VideosInitialState value)? initial,
    TResult Function(_VideosLoadingState value)? loading,
    TResult Function(_VideosErrorState value)? error,
    TResult Function(_VideosSuccessState value)? success,
    TResult Function(_VideosPlaylistVideosState value)? playlistVideos,
    TResult Function(_VideosDetailsState value)? videoDetails,
    required TResult orElse(),
  }) {
    if (videoDetails != null) {
      return videoDetails(this);
    }
    return orElse();
  }
}

abstract class _VideosDetailsState implements VideosState {
  const factory _VideosDetailsState(final Resources? videoDetails) =
      _$VideosDetailsStateImpl;

  Resources? get videoDetails;
  @JsonKey(ignore: true)
  _$$VideosDetailsStateImplCopyWith<_$VideosDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
