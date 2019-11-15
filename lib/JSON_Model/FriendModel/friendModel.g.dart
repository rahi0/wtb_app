// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllFriend _$AllFriendFromJson(Map<String, dynamic> json) {
  return AllFriend(
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

Map<String, dynamic> _$AllFriendToJson(AllFriend instance) => <String, dynamic>{
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
