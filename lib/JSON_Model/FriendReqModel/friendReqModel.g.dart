// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendReqModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendReqModel _$FriendReqModelFromJson(Map<String, dynamic> json) {
  return FriendReqModel(
    (json['friend'] as List)
        ?.map((e) =>
            e == null ? null : Friend.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['pending'] as List)
        ?.map((e) =>
            e == null ? null : Pending.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FriendReqModelToJson(FriendReqModel instance) =>
    <String, dynamic>{
      'friend': instance.friend,
      'pending': instance.pending,
    };

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['reason'],
    json['status'],
    json['userName'],
    json['isOnline'],
    json['profilePic'],
    json['user_id'],
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'reason': instance.reason,
      'userName': instance.userName,
      'isOnline': instance.isOnline,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'user_id': instance.userId,
    };

Pending _$PendingFromJson(Map<String, dynamic> json) {
  return Pending(
    json['id'],
    json['follower_id'],
    json['following_id'],
    json['reason'],
    json['status'],
    json['follower'] == null
        ? null
        : Follower.fromJson(json['follower'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PendingToJson(Pending instance) => <String, dynamic>{
      'id': instance.id,
      'follower_id': instance.followerId,
      'following_id': instance.followingId,
      'reason': instance.reason,
      'status': instance.status,
      'follower': instance.follower,
    };

Follower _$FollowerFromJson(Map<String, dynamic> json) {
  return Follower(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['userName'],
    json['jobTitle'],
  );
}

Map<String, dynamic> _$FollowerToJson(Follower instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'userName': instance.userName,
      'jobTitle': instance.jobTitle,
    };
