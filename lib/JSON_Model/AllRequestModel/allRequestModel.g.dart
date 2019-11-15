// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllRequestModel _$AllRequestModelFromJson(Map<String, dynamic> json) {
  return AllRequestModel(
    (json['pending'] as List)
        ?.map((e) =>
            e == null ? null : Pending.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AllRequestModelToJson(AllRequestModel instance) =>
    <String, dynamic>{
      'pending': instance.pending,
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
