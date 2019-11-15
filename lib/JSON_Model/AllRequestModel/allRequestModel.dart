import 'package:json_annotation/json_annotation.dart';

part 'allRequestModel.g.dart';

@JsonSerializable()
class AllRequestModel {
  List<Pending> pending;

  AllRequestModel(this.pending);
  factory AllRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AllRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AllRequestModelToJson(this);
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
