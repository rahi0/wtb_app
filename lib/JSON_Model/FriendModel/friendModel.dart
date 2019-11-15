import 'package:json_annotation/json_annotation.dart';

part 'friendModel.g.dart';

// @JsonSerializable()
// class FriendModel {
//   List<Friend> friend;

//   FriendModel(this.friend);
//   factory FriendModel.fromJson(Map<String, dynamic> json) =>
//       _$FriendModelFromJson(json);
//   Map<String, dynamic> toJson() => _$FriendModelToJson(this);
// }

@JsonSerializable()
class AllFriend {
  var id;
  var status;
  var reason;
  var userName;
  var isOnline;
  var firstName;
  var lastName;
  var profilePic;
  @JsonKey(name: "user_id")
  dynamic userId;

  AllFriend(this.id, this.firstName, this.lastName, this.reason, this.status, this.userName, this.isOnline, this.profilePic, this.userId);
  factory AllFriend.fromJson(Map<String, dynamic> json) =>
      _$AllFriendFromJson(json);
  Map<String, dynamic> toJson() => _$AllFriendToJson(this);
}