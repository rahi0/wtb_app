import 'package:json_annotation/json_annotation.dart';

part 'reply_Model.g.dart';

@JsonSerializable()
class AllReplyModel {
  List<Replies> replies;
  AllReplyModel(this. replies);
  factory AllReplyModel.fromJson(Map<String, dynamic> json) =>
      _$AllReplyModelFromJson(json);
  Map<String, dynamic> toJson() => _$AllReplyModelToJson(this);
}

@JsonSerializable()
class Replies {
  var id;
  var replyTxt;
   @JsonKey(name: "comment_id")
  dynamic commentId;
   @JsonKey(name: "user_id")
  dynamic userId;
  var like;
  User user;
   @JsonKey(name: "__meta__")
   final Replay replay;
  Replies(this.replyTxt, this.id, this.commentId, this.user, this.userId, this.like, this.replay);
  factory Replies.fromJson(Map<String, dynamic> json) =>
      _$RepliesFromJson(json);
  Map<String, dynamic> toJson() => _$RepliesToJson(this);
}

@JsonSerializable()
class User {
  var id;
  var userName;
  var firstName;
  var lastName;
  var profilePic;
  var jobTitle;
  User(this.jobTitle, this.profilePic, this.id, this.firstName, this.lastName, this.userName);
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Replay {
   @JsonKey(name: "totalLike_count")
  dynamic totalLikeCount;
  Replay(this.totalLikeCount);
  factory Replay.fromJson(Map<String, dynamic> json) =>
      _$ReplayFromJson(json);
  Map<String, dynamic> toJson() => _$ReplayToJson(this);
}