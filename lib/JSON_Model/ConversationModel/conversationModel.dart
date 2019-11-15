import 'package:json_annotation/json_annotation.dart';

part 'conversationModel.g.dart';

@JsonSerializable()
class ConversationModel {
  List<Chats> chats;

  ConversationModel(this.chats);
  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}

@JsonSerializable()
class Chats {
  var id;
  @JsonKey(name: "con_id")
  dynamic conId;
  @JsonKey(name: "created_at")
  dynamic createdAt;
  var msg;
  var file;
  var seen;
  var deleted;
  @JsonKey(name: "msg_sender")
  dynamic msgSender;

  Chats(this.id, this.conId, this.createdAt, this.seen, this.msgSender, this.msg, this.deleted, this.file);
  factory Chats.fromJson(Map<String, dynamic> json) =>
      _$ChatsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsToJson(this);
}
