import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart'
    hide Object;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/constants.dart';

part 'post.freezed.dart';
part 'post.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return DateTime.now();
}

Timestamp _dateTimeToTimestamp(DateTime dateTime) =>
    Timestamp.fromDate(dateTime);

List<String> _stringListFromJson(List<dynamic>? values) =>
    (values ?? <dynamic>[])
        .map((dynamic value) => value.toString().trim())
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);

List<double> _doubleListFromJson(List<dynamic>? values) =>
    (values ?? <dynamic>[])
        .whereType<num>()
        .map((num value) => value.toDouble())
        .where((double value) => value > 0.1 && value < 10)
        .toList(growable: false);

@freezed
abstract class Post with _$Post {
  const Post._();

  @JsonSerializable(explicitToJson: true)
  const factory Post({
    required String id,
    required PostType type,
    required String language,
    String? title,
    String? content,
    @Default(<String>[])
    @JsonKey(fromJson: _stringListFromJson)
    List<String> mediaUrls,
    String? thumbnailUrl,
    String? youtubeId,
    String? articleUrl,
    @Default(<double>[])
    @JsonKey(fromJson: _doubleListFromJson)
    List<double> mediaAspectRatios,
    required PostAuthor author,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @Default('published') String status,
    @Default(true) bool allowComments,
    @Default(0) int likes,
    @Default(0) int commentsCount,
    @Default(0) int shares,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  String? get primaryMediaUrl => mediaUrls.isEmpty ? null : mediaUrls.first;

  double aspectRatioForIndex(int index, {double fallback = 1}) {
    if (index >= 0 && index < mediaAspectRatios.length) {
      return mediaAspectRatios[index];
    }
    if (mediaAspectRatios.isNotEmpty) {
      return mediaAspectRatios.first;
    }
    return fallback;
  }

  String get appDeepLink => '$ICOC_WEB_PAGE/insights/post/$id?lang=$language';
}

@freezed
abstract class PostAuthor with _$PostAuthor {
  @JsonSerializable(explicitToJson: true)
  const factory PostAuthor({
    required String name,
    required String avatarUrl,
  }) = _PostAuthor;

  factory PostAuthor.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorFromJson(json);
}

enum PostType {
  image,
  video,
}
