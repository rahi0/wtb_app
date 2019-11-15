import 'package:json_annotation/json_annotation.dart';

part 'commentModel.g.dart';

@JsonSerializable()
class AllCommentsModel {
  List<Comments> comments;
  AllCommentsModel(this. comments);
  factory AllCommentsModel.fromJson(Map<String, dynamic> json) =>
      _$AllCommentsModelFromJson(json);
  Map<String, dynamic> toJson() => _$AllCommentsModelToJson(this);
}

@JsonSerializable()
class Comments {
  var id;
  var comment;
   @JsonKey(name: "status_id")
  dynamic statusId;
   @JsonKey(name: "user_id")
  dynamic userId;
  var type;
  var like;
  User user;
   @JsonKey(name: "__meta__")
  final Replay replay;
  Comments(this.comment, this.id, this.statusId, this.type, this.user, this.userId, this.like, this.replay);
  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsToJson(this);
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
   @JsonKey(name: "totalReply_count")
  dynamic totalReplyCount;
   @JsonKey(name: "totalLike_count")
  dynamic totalLikeCount;
  Replay(this.totalLikeCount, this.totalReplyCount);
  factory Replay.fromJson(Map<String, dynamic> json) =>
      _$ReplayFromJson(json);
  Map<String, dynamic> toJson() => _$ReplayToJson(this);
}