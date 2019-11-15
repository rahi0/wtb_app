// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedPost_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedPost _$FeedPostFromJson(Map<String, dynamic> json) {
  return FeedPost(
    (json['feed'] as List)
        ?.map(
            (e) => e == null ? null : Feed.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['lcid'],
    json['llid'],
    json['lsid'],
    json['sid'],
  );
}

Map<String, dynamic> _$FeedPostToJson(FeedPost instance) => <String, dynamic>{
      'feed': instance.feed,
      'llid': instance.llid,
      'lcid': instance.lcid,
      'lsid': instance.lsid,
      'sid': instance.sid,
    };

Feed _$FeedFromJson(Map<String, dynamic> json) {
  return Feed(
    json['id'],
    json['status'],
    json['activityType'],
    json['interest'],
    json['like'],
    json['privacy'],
    json['commentCount'],
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : Images.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['likeCount'],
    json['link'],
    json['shareCount'],
    json['fuser'] == null
        ? null
        : Fuser.fromJson(json['fuser'] as Map<String, dynamic>),
    json['type'],
    json['__meta__'] == null
        ? null
        : Meta.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['user_id'],
  );
}

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'status': instance.status,
      'activityType': instance.activityType,
      'interest': instance.interest,
      'link': instance.link,
      'privacy': instance.privacy,
      'type': instance.type,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'like': instance.like,
      'images': instance.images,
      'fuser': instance.fuser,
      '__meta__': instance.meta,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    json['id'],
    json['file'],
    json['thum'],
    json['type'],
  );
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'thum': instance.thum,
      'type': instance.type,
    };

Fuser _$FuserFromJson(Map<String, dynamic> json) {
  return Fuser(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['userName'],
    json['jobTitle'],
    json['profilePic'],
  );
}

Map<String, dynamic> _$FuserToJson(Fuser instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['totalComments_count'],
    json['totalLikes_count'],
    json['totalShares_count'],
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'totalComments_count': instance.totalCommentsCount,
      'totalLikes_count': instance.totalLikesCount,
      'totalShares_count': instance.totalSharesCount,
    };
