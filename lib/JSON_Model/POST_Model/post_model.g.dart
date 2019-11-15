// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    (json['res'] as List)
        ?.map((e) => e == null ? null : Res.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'user': instance.user,
      'res': instance.res,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['jobTitle'],
    json['dayJob'],
    json['userName'],
    json['country'],
    json['shop_id'],
    json['avgReview'],
  )..userType = json['userType'];
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'userName': instance.userName,
      'country': instance.country,
      'shop_id': instance.shop_id,
      'avgReview': instance.avgReview,
      'userType': instance.userType,
    };

Res _$ResFromJson(Map<String, dynamic> json) {
  return Res(
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
    json['__meta__'] == null
        ? null
        : Meta.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['type'],
    json['user_id'],
  )..fuser = json['fuser'] == null
      ? null
      : Fuser.fromJson(json['fuser'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
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
      'fuser': instance.fuser,
      'images': instance.images,
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

Fuser _$FuserFromJson(Map<String, dynamic> json) {
  return Fuser(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['userName'],
    json['profilePic'],
    json['jobTitle'],
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
