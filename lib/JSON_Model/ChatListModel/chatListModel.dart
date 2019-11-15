import 'package:json_annotation/json_annotation.dart';

part 'chatListModel.g.dart';

@JsonSerializable()
class ChatListModel {
  List<Lists> lists;

  ChatListModel(this.lists);
  factory ChatListModel.fromJson(Map<String, dynamic> json) =>
      _$ChatListModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatListModelToJson(this);
}

@JsonSerializable()
class Lists {
  var id;
  var sender;
  var reciever;
  var conType;
  var username;
  var firstName;
  var lastName;
  var profilePic;
  var jobTitle;
  var dayJob;
  @JsonKey(name: "created_at")
  dynamic createdAt;
  var userType;
  var isOnline;
  var msg;
  var seen;
  @JsonKey(name: "msg_sender")
  dynamic msgSender;

  Lists(this.id, this.sender, this.reciever, this.createdAt, this.conType, this.dayJob, this.firstName, this.isOnline, this.jobTitle, this.lastName, this.msg, this.msgSender, this.profilePic, this.seen, this.username, this.userType);
  factory Lists.fromJson(Map<String, dynamic> json) =>
      _$ListsFromJson(json);
  Map<String, dynamic> toJson() => _$ListsToJson(this);
}
