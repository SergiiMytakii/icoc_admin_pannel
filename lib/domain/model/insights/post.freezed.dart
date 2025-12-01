// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  PostType get type => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get articleUrl => throw _privateConstructorUsedError;
  PostAuthor get author => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  int get shares => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {String id,
      PostType type,
      String language,
      String? title,
      String? content,
      String? mediaUrl,
      String? thumbnailUrl,
      String? articleUrl,
      PostAuthor author,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      int likes,
      int shares});

  $PostAuthorCopyWith<$Res> get author;
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? language = null,
    Object? title = freezed,
    Object? content = freezed,
    Object? mediaUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? articleUrl = freezed,
    Object? author = null,
    Object? createdAt = null,
    Object? likes = null,
    Object? shares = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      articleUrl: freezed == articleUrl
          ? _value.articleUrl
          : articleUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as PostAuthor,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PostAuthorCopyWith<$Res> get author {
    return $PostAuthorCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PostType type,
      String language,
      String? title,
      String? content,
      String? mediaUrl,
      String? thumbnailUrl,
      String? articleUrl,
      PostAuthor author,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      int likes,
      int shares});

  @override
  $PostAuthorCopyWith<$Res> get author;
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? language = null,
    Object? title = freezed,
    Object? content = freezed,
    Object? mediaUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? articleUrl = freezed,
    Object? author = null,
    Object? createdAt = null,
    Object? likes = null,
    Object? shares = null,
  }) {
    return _then(_$PostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      articleUrl: freezed == articleUrl
          ? _value.articleUrl
          : articleUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as PostAuthor,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PostImpl implements _Post {
  const _$PostImpl(
      {required this.id,
      required this.type,
      required this.language,
      this.title,
      this.content,
      this.mediaUrl,
      this.thumbnailUrl,
      this.articleUrl,
      required this.author,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt,
      this.likes = 0,
      this.shares = 0});

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  final String id;
  @override
  final PostType type;
  @override
  final String language;
  @override
  final String? title;
  @override
  final String? content;
  @override
  final String? mediaUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? articleUrl;
  @override
  final PostAuthor author;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey()
  final int shares;

  @override
  String toString() {
    return 'Post(id: $id, type: $type, language: $language, title: $title, content: $content, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, articleUrl: $articleUrl, author: $author, createdAt: $createdAt, likes: $likes, shares: $shares)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.articleUrl, articleUrl) ||
                other.articleUrl == articleUrl) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.shares, shares) || other.shares == shares));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      language,
      title,
      content,
      mediaUrl,
      thumbnailUrl,
      articleUrl,
      author,
      createdAt,
      likes,
      shares);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(
      this,
    );
  }
}

abstract class _Post implements Post {
  const factory _Post(
      {required final String id,
      required final PostType type,
      required final String language,
      final String? title,
      final String? content,
      final String? mediaUrl,
      final String? thumbnailUrl,
      final String? articleUrl,
      required final PostAuthor author,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required final DateTime createdAt,
      final int likes,
      final int shares}) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  String get id;
  @override
  PostType get type;
  @override
  String get language;
  @override
  String? get title;
  @override
  String? get content;
  @override
  String? get mediaUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get articleUrl;
  @override
  PostAuthor get author;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  int get likes;
  @override
  int get shares;
  @override
  @JsonKey(ignore: true)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostAuthor _$PostAuthorFromJson(Map<String, dynamic> json) {
  return _PostAuthor.fromJson(json);
}

/// @nodoc
mixin _$PostAuthor {
  String get name => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostAuthorCopyWith<PostAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostAuthorCopyWith<$Res> {
  factory $PostAuthorCopyWith(
          PostAuthor value, $Res Function(PostAuthor) then) =
      _$PostAuthorCopyWithImpl<$Res, PostAuthor>;
  @useResult
  $Res call({String name, String avatarUrl});
}

/// @nodoc
class _$PostAuthorCopyWithImpl<$Res, $Val extends PostAuthor>
    implements $PostAuthorCopyWith<$Res> {
  _$PostAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatarUrl = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostAuthorImplCopyWith<$Res>
    implements $PostAuthorCopyWith<$Res> {
  factory _$$PostAuthorImplCopyWith(
          _$PostAuthorImpl value, $Res Function(_$PostAuthorImpl) then) =
      __$$PostAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String avatarUrl});
}

/// @nodoc
class __$$PostAuthorImplCopyWithImpl<$Res>
    extends _$PostAuthorCopyWithImpl<$Res, _$PostAuthorImpl>
    implements _$$PostAuthorImplCopyWith<$Res> {
  __$$PostAuthorImplCopyWithImpl(
      _$PostAuthorImpl _value, $Res Function(_$PostAuthorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatarUrl = null,
  }) {
    return _then(_$PostAuthorImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PostAuthorImpl implements _PostAuthor {
  const _$PostAuthorImpl({required this.name, required this.avatarUrl});

  factory _$PostAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostAuthorImplFromJson(json);

  @override
  final String name;
  @override
  final String avatarUrl;

  @override
  String toString() {
    return 'PostAuthor(name: $name, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostAuthorImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostAuthorImplCopyWith<_$PostAuthorImpl> get copyWith =>
      __$$PostAuthorImplCopyWithImpl<_$PostAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostAuthorImplToJson(
      this,
    );
  }
}

abstract class _PostAuthor implements PostAuthor {
  const factory _PostAuthor(
      {required final String name,
      required final String avatarUrl}) = _$PostAuthorImpl;

  factory _PostAuthor.fromJson(Map<String, dynamic> json) =
      _$PostAuthorImpl.fromJson;

  @override
  String get name;
  @override
  String get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$PostAuthorImplCopyWith<_$PostAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
