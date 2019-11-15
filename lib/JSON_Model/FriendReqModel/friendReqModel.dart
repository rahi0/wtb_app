import 'package:json_annotation/json_annotation.dart';

part 'friendReqModel.g.dart';

@JsonSerializable()
class FriendReqModel {
  List<Friend> friend;
  List<Pending> pending;

  FriendReqModel(this.friend, this.pending);
  factory FriendReqModel.fromJson(Map<String, dynamic> json) =>
      _$FriendReqModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendReqModelToJson(this);
}

@JsonSerializable()
class Friend {
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

  Friend(this.id, this.firstName, this.lastName, this.reason, this.status, this.userName, this.isOnline, this.profilePic, this.userId);
  factory Friend.fromJson(Map<String, dynamic> json) =>
      _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}

@JsonSerializable()
class Pending {
  var id;
  @JsonKey(name: "follower_id")
  dynamic followerId;
  @JsonKey(name: "following_id")
  dynamic followingId;
  var reason;
  var status;
  Follower follower;

  Pending(this.id, this.followerId, this.followingId, this.reason, this.status, this.follower);
  factory Pending.fromJson(Map<String, dynamic> json) =>
      _$PendingFromJson(json);
  Map<String, dynamic> toJson() => _$PendingToJson(this);
}

@JsonSerializable()
class Follower {
  var id;
  var firstName;
  var lastName;
  var profilePic;
  var userName;
  var jobTitle;

  Follower(this.id, this.firstName, this.lastName, this.profilePic, this.userName, this.jobTitle);
  factory Follower.fromJson(Map<String, dynamic> json) =>
      _$FollowerFromJson(json);
  Map<String, dynamic> toJson() => _$FollowerToJson(this);
}
