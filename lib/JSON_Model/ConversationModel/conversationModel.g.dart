// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return ConversationModel(
    (json['chats'] as List)
        ?.map(
            (e) => e == null ? null : Chats.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'chats': instance.chats,
    };

Chats _$ChatsFromJson(Map<String, dynamic> json) {
  return Chats(
    json['id'],
    json['con_id'],
    json['created_at'],
    json['seen'],
    json['msg_sender'],
    json['msg'],
    json['deleted'],
    json['file'],
  );
}

Map<String, dynamic> _$ChatsToJson(Chats instance) => <String, dynamic>{
      'id': instance.id,
      'con_id': instance.conId,
      'created_at': instance.createdAt,
      'msg': instance.msg,
      'file': instance.file,
      'seen': instance.seen,
      'deleted': instance.deleted,
      'msg_sender': instance.msgSender,
    };
