// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListModel _$ChatListModelFromJson(Map<String, dynamic> json) {
  return ChatListModel(
    (json['lists'] as List)
        ?.map(
            (e) => e == null ? null : Lists.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ChatListModelToJson(ChatListModel instance) =>
    <String, dynamic>{
      'lists': instance.lists,
    };

Lists _$ListsFromJson(Map<String, dynamic> json) {
  return Lists(
    json['id'],
    json['sender'],
    json['reciever'],
    json['created_at'],
    json['conType'],
    json['dayJob'],
    json['firstName'],
    json['isOnline'],
    json['jobTitle'],
    json['lastName'],
    json['msg'],
    json['msg_sender'],
    json['profilePic'],
    json['seen'],
    json['username'],
    json['userType'],
  );
}

Map<String, dynamic> _$ListsToJson(Lists instance) => <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'reciever': instance.reciever,
      'conType': instance.conType,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'created_at': instance.createdAt,
      'userType': instance.userType,
      'isOnline': instance.isOnline,
      'msg': instance.msg,
      'seen': instance.seen,
      'msg_sender': instance.msgSender,
    };
