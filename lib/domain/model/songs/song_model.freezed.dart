// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongModel _$SongModelFromJson(Map<String, dynamic> json) {
  return _SongModel.fromJson(json);
}

/// @nodoc
mixin _$SongModel {
  @override
  int get id => throw _privateConstructorUsedError;
  @override
  set id(int value) => throw _privateConstructorUsedError;
  List<SongVersion> get songVersions => throw _privateConstructorUsedError;
  set songVersions(List<SongVersion> value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongModelCopyWith<SongModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongModelCopyWith<$Res> {
  factory $SongModelCopyWith(SongModel value, $Res Function(SongModel) then) =
      _$SongModelCopyWithImpl<$Res, SongModel>;
  @useResult
  $Res call({@override int id, List<SongVersion> songVersions});
}

/// @nodoc
class _$SongModelCopyWithImpl<$Res, $Val extends SongModel>
    implements $SongModelCopyWith<$Res> {
  _$SongModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? songVersions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      songVersions: null == songVersions
          ? _value.songVersions
          : songVersions // ignore: cast_nullable_to_non_nullable
              as List<SongVersion>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongModelImplCopyWith<$Res>
    implements $SongModelCopyWith<$Res> {
  factory _$$SongModelImplCopyWith(
          _$SongModelImpl value, $Res Function(_$SongModelImpl) then) =
      __$$SongModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@override int id, List<SongVersion> songVersions});
}

/// @nodoc
class __$$SongModelImplCopyWithImpl<$Res>
    extends _$SongModelCopyWithImpl<$Res, _$SongModelImpl>
    implements _$$SongModelImplCopyWith<$Res> {
  __$$SongModelImplCopyWithImpl(
      _$SongModelImpl _value, $Res Function(_$SongModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? songVersions = null,
  }) {
    return _then(_$SongModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      songVersions: null == songVersions
          ? _value.songVersions
          : songVersions // ignore: cast_nullable_to_non_nullable
              as List<SongVersion>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SongModelImpl extends _SongModel {
  _$SongModelImpl({@override required this.id, required this.songVersions})
      : super._();

  factory _$SongModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongModelImplFromJson(json);

  @override
  @override
  int id;
  @override
  List<SongVersion> songVersions;

  @override
  String toString() {
    return 'SongModel(id: $id, songVersions: $songVersions)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongModelImplCopyWith<_$SongModelImpl> get copyWith =>
      __$$SongModelImplCopyWithImpl<_$SongModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongModelImplToJson(
      this,
    );
  }
}

abstract class _SongModel extends SongModel {
  factory _SongModel(
      {@override required int id,
      required List<SongVersion> songVersions}) = _$SongModelImpl;
  _SongModel._() : super._();

  factory _SongModel.fromJson(Map<String, dynamic> json) =
      _$SongModelImpl.fromJson;

  @override
  @override
  int get id;
  @override
  set id(int value);
  @override
  List<SongVersion> get songVersions;
  set songVersions(List<SongVersion> value);
  @override
  @JsonKey(ignore: true)
  _$$SongModelImplCopyWith<_$SongModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SongVersion _$SongVersionFromJson(Map<String, dynamic> json) {
  return _SongVersion.fromJson(json);
}

/// @nodoc
mixin _$SongVersion {
  int get id => throw _privateConstructorUsedError;
  set id(int value) => throw _privateConstructorUsedError;
  Languages get lang => throw _privateConstructorUsedError;
  set lang(Languages value) => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  set text(String value) => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  bool get isChords => throw _privateConstructorUsedError;
  set isChords(bool value) => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  set description(String? value) => throw _privateConstructorUsedError;
  List<YoutubeVideo>? get youtubeVideos => throw _privateConstructorUsedError;
  set youtubeVideos(List<YoutubeVideo>? value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongVersionCopyWith<SongVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongVersionCopyWith<$Res> {
  factory $SongVersionCopyWith(
          SongVersion value, $Res Function(SongVersion) then) =
      _$SongVersionCopyWithImpl<$Res, SongVersion>;
  @useResult
  $Res call(
      {int id,
      Languages lang,
      String text,
      String title,
      bool isChords,
      String? description,
      List<YoutubeVideo>? youtubeVideos});
}

/// @nodoc
class _$SongVersionCopyWithImpl<$Res, $Val extends SongVersion>
    implements $SongVersionCopyWith<$Res> {
  _$SongVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lang = null,
    Object? text = null,
    Object? title = null,
    Object? isChords = null,
    Object? description = freezed,
    Object? youtubeVideos = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Languages,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isChords: null == isChords
          ? _value.isChords
          : isChords // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeVideos: freezed == youtubeVideos
          ? _value.youtubeVideos
          : youtubeVideos // ignore: cast_nullable_to_non_nullable
              as List<YoutubeVideo>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongVersionImplCopyWith<$Res>
    implements $SongVersionCopyWith<$Res> {
  factory _$$SongVersionImplCopyWith(
          _$SongVersionImpl value, $Res Function(_$SongVersionImpl) then) =
      __$$SongVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      Languages lang,
      String text,
      String title,
      bool isChords,
      String? description,
      List<YoutubeVideo>? youtubeVideos});
}

/// @nodoc
class __$$SongVersionImplCopyWithImpl<$Res>
    extends _$SongVersionCopyWithImpl<$Res, _$SongVersionImpl>
    implements _$$SongVersionImplCopyWith<$Res> {
  __$$SongVersionImplCopyWithImpl(
      _$SongVersionImpl _value, $Res Function(_$SongVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lang = null,
    Object? text = null,
    Object? title = null,
    Object? isChords = null,
    Object? description = freezed,
    Object? youtubeVideos = freezed,
  }) {
    return _then(_$SongVersionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as Languages,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isChords: null == isChords
          ? _value.isChords
          : isChords // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      youtubeVideos: freezed == youtubeVideos
          ? _value.youtubeVideos
          : youtubeVideos // ignore: cast_nullable_to_non_nullable
              as List<YoutubeVideo>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SongVersionImpl implements _SongVersion {
  _$SongVersionImpl(
      {required this.id,
      required this.lang,
      required this.text,
      required this.title,
      this.isChords = false,
      this.description,
      this.youtubeVideos});

  factory _$SongVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongVersionImplFromJson(json);

  @override
  int id;
  @override
  Languages lang;
  @override
  String text;
  @override
  String title;
  @override
  @JsonKey()
  bool isChords;
  @override
  String? description;
  @override
  List<YoutubeVideo>? youtubeVideos;

  @override
  String toString() {
    return 'SongVersion(id: $id, lang: $lang, text: $text, title: $title, isChords: $isChords, description: $description, youtubeVideos: $youtubeVideos)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongVersionImplCopyWith<_$SongVersionImpl> get copyWith =>
      __$$SongVersionImplCopyWithImpl<_$SongVersionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongVersionImplToJson(
      this,
    );
  }
}

abstract class _SongVersion implements SongVersion {
  factory _SongVersion(
      {required int id,
      required Languages lang,
      required String text,
      required String title,
      bool isChords,
      String? description,
      List<YoutubeVideo>? youtubeVideos}) = _$SongVersionImpl;

  factory _SongVersion.fromJson(Map<String, dynamic> json) =
      _$SongVersionImpl.fromJson;

  @override
  int get id;
  set id(int value);
  @override
  Languages get lang;
  set lang(Languages value);
  @override
  String get text;
  set text(String value);
  @override
  String get title;
  set title(String value);
  @override
  bool get isChords;
  set isChords(bool value);
  @override
  String? get description;
  set description(String? value);
  @override
  List<YoutubeVideo>? get youtubeVideos;
  set youtubeVideos(List<YoutubeVideo>? value);
  @override
  @JsonKey(ignore: true)
  _$$SongVersionImplCopyWith<_$SongVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SongVersionLocal _$SongVersionLocalFromJson(Map<String, dynamic> json) {
  return _SongVersionLocal.fromJson(json);
}

/// @nodoc
mixin _$SongVersionLocal {
  int get id => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongVersionLocalCopyWith<SongVersionLocal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongVersionLocalCopyWith<$Res> {
  factory $SongVersionLocalCopyWith(
          SongVersionLocal value, $Res Function(SongVersionLocal) then) =
      _$SongVersionLocalCopyWithImpl<$Res, SongVersionLocal>;
  @useResult
  $Res call({int id, String lang, String text, String title});
}

/// @nodoc
class _$SongVersionLocalCopyWithImpl<$Res, $Val extends SongVersionLocal>
    implements $SongVersionLocalCopyWith<$Res> {
  _$SongVersionLocalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lang = null,
    Object? text = null,
    Object? title = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongVersionLocalImplCopyWith<$Res>
    implements $SongVersionLocalCopyWith<$Res> {
  factory _$$SongVersionLocalImplCopyWith(_$SongVersionLocalImpl value,
          $Res Function(_$SongVersionLocalImpl) then) =
      __$$SongVersionLocalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String lang, String text, String title});
}

/// @nodoc
class __$$SongVersionLocalImplCopyWithImpl<$Res>
    extends _$SongVersionLocalCopyWithImpl<$Res, _$SongVersionLocalImpl>
    implements _$$SongVersionLocalImplCopyWith<$Res> {
  __$$SongVersionLocalImplCopyWithImpl(_$SongVersionLocalImpl _value,
      $Res Function(_$SongVersionLocalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lang = null,
    Object? text = null,
    Object? title = null,
  }) {
    return _then(_$SongVersionLocalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongVersionLocalImpl implements _SongVersionLocal {
  const _$SongVersionLocalImpl(
      {required this.id,
      required this.lang,
      required this.text,
      required this.title});

  factory _$SongVersionLocalImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongVersionLocalImplFromJson(json);

  @override
  final int id;
  @override
  final String lang;
  @override
  final String text;
  @override
  final String title;

  @override
  String toString() {
    return 'SongVersionLocal(id: $id, lang: $lang, text: $text, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongVersionLocalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, lang, text, title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongVersionLocalImplCopyWith<_$SongVersionLocalImpl> get copyWith =>
      __$$SongVersionLocalImplCopyWithImpl<_$SongVersionLocalImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongVersionLocalImplToJson(
      this,
    );
  }
}

abstract class _SongVersionLocal implements SongVersionLocal {
  const factory _SongVersionLocal(
      {required final int id,
      required final String lang,
      required final String text,
      required final String title}) = _$SongVersionLocalImpl;

  factory _SongVersionLocal.fromJson(Map<String, dynamic> json) =
      _$SongVersionLocalImpl.fromJson;

  @override
  int get id;
  @override
  String get lang;
  @override
  String get text;
  @override
  String get title;
  @override
  @JsonKey(ignore: true)
  _$$SongVersionLocalImplCopyWith<_$SongVersionLocalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
