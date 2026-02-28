// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      language: json['language'] as String,
      title: json['title'] as String?,
      content: json['content'] as String?,
      mediaUrls: json['mediaUrls'] == null
          ? const <String>[]
          : _stringListFromJson(json['mediaUrls'] as List?),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      youtubeId: json['youtubeId'] as String?,
      articleUrl: json['articleUrl'] as String?,
      mediaAspectRatios: json['mediaAspectRatios'] == null
          ? const <double>[]
          : _doubleListFromJson(json['mediaAspectRatios'] as List?),
      author: PostAuthor.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      status: json['status'] as String? ?? 'published',
      allowComments: json['allowComments'] as bool? ?? true,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PostTypeEnumMap[instance.type]!,
      'language': instance.language,
      'title': instance.title,
      'content': instance.content,
      'mediaUrls': instance.mediaUrls,
      'thumbnailUrl': instance.thumbnailUrl,
      'youtubeId': instance.youtubeId,
      'articleUrl': instance.articleUrl,
      'mediaAspectRatios': instance.mediaAspectRatios,
      'author': instance.author.toJson(),
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'status': instance.status,
      'allowComments': instance.allowComments,
      'likes': instance.likes,
      'commentsCount': instance.commentsCount,
      'shares': instance.shares,
    };

const _$PostTypeEnumMap = {
  PostType.image: 'image',
  PostType.video: 'video',
};

_$PostAuthorImpl _$$PostAuthorImplFromJson(Map<String, dynamic> json) =>
    _$PostAuthorImpl(
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$$PostAuthorImplToJson(_$PostAuthorImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
    };
