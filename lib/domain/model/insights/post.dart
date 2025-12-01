import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

DateTime _dateTimeFromTimestamp(dynamic ts) {
  if (ts is int) {
    return DateTime.fromMillisecondsSinceEpoch(ts);
  }
  if (ts is String) {
    return DateTime.tryParse(ts) ?? DateTime.now();
  }
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime dt) => dt.toIso8601String();

@freezed
class Post with _$Post {
  @JsonSerializable(explicitToJson: true)
  const factory Post({
    required String id,
    required PostType type,
    required String language,
    String? title,
    String? content,
    String? mediaUrl,
    String? thumbnailUrl,
    String? articleUrl,
    required PostAuthor author,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @Default(0) int likes,
    @Default(0) int shares,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
class PostAuthor with _$PostAuthor {
  @JsonSerializable(explicitToJson: true)
  const factory PostAuthor({
    required String name,
    required String avatarUrl,
  }) = _PostAuthor;

  factory PostAuthor.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorFromJson(json);
}

enum PostType {
  text,
  image,
  video,
}
