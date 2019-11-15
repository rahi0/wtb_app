// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllCommentsModel _$AllCommentsModelFromJson(Map<String, dynamic> json) {
  return AllCommentsModel(
    (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comments.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AllCommentsModelToJson(AllCommentsModel instance) =>
    <String, dynamic>{
      'comments': instance.comments,
    };

Comments _$CommentsFromJson(Map<String, dynamic> json) {
  return Comments(
    json['comment'],
    json['id'],
    json['status_id'],
    json['type'],
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['user_id'],
    json['like'],
    json['__meta__'] == null
        ? null
        : Replay.fromJson(json['__meta__'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'status_id': instance.statusId,
      'user_id': instance.userId,
      'type': instance.type,
      'like': instance.like,
      'user': instance.user,
      '__meta__': instance.replay,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['jobTitle'],
    json['profilePic'],
    json['id'],
    json['firstName'],
    json['lastName'],
    json['userName'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
    };

Replay _$ReplayFromJson(Map<String, dynamic> json) {
  return Replay(
    json['totalLike_count'],
    json['totalReply_count'],
  );
}

Map<String, dynamic> _$ReplayToJson(Replay instance) => <String, dynamic>{
      'totalReply_count': instance.totalReplyCount,
      'totalLike_count': instance.totalLikeCount,
    };
