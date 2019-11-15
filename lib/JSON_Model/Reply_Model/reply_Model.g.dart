// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllReplyModel _$AllReplyModelFromJson(Map<String, dynamic> json) {
  return AllReplyModel(
    (json['replies'] as List)
        ?.map((e) =>
            e == null ? null : Replies.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AllReplyModelToJson(AllReplyModel instance) =>
    <String, dynamic>{
      'replies': instance.replies,
    };

Replies _$RepliesFromJson(Map<String, dynamic> json) {
  return Replies(
    json['replyTxt'],
    json['id'],
    json['comment_id'],
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

Map<String, dynamic> _$RepliesToJson(Replies instance) => <String, dynamic>{
      'id': instance.id,
      'replyTxt': instance.replyTxt,
      'comment_id': instance.commentId,
      'user_id': instance.userId,
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
  );
}

Map<String, dynamic> _$ReplayToJson(Replay instance) => <String, dynamic>{
      'totalLike_count': instance.totalLikeCount,
    };
