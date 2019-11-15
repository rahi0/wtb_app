import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post {
  User user;
  List<Res> res;
  Post(this.user, this.res);
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class User {
  var id;
  var firstName;
  var lastName;
  var profilePic;
  var jobTitle;
  var dayJob;
  var userName;
  var country;
  var shop_id;
  var avgReview;
  var userType;

  User(this.id, this.firstName, this.lastName, this.profilePic, this.jobTitle,
      this.dayJob, this.userName, this.country, this.shop_id, this.avgReview);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Res {
  var id;
  @JsonKey(name: "user_id")
  var userId;
  var status;
  var activityType;
  var interest;
  var link;
  var privacy;
  var type;
  var likeCount;
  var commentCount;
  var shareCount;
  var like;
  Fuser fuser;
  List<Images> images;
  @JsonKey(name: "__meta__")
  final Meta meta;

  Res(
      this.id,
      this.status,
      this.activityType,
      this.interest,
      this.like,
      this.privacy,
      this.commentCount,
      this.images,
      this.likeCount,
      this.link,
      this.shareCount,
      this.meta,
      this.type,
      this.userId);

  factory Res.fromJson(Map<String, dynamic> json) => _$ResFromJson(json);
  Map<String, dynamic> toJson() => _$ResToJson(this);
}

@JsonSerializable()
class Images {
  var id;
  var file;
  var thum;
  var type;

  Images(
    this.id,
    this.file,
    this.thum,
    this.type,
  );
  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: "totalComments_count")
  dynamic totalCommentsCount;
  @JsonKey(name: "totalLikes_count")
  dynamic totalLikesCount;
  @JsonKey(name: "totalShares_count")
  dynamic totalSharesCount;

  Meta(this.totalCommentsCount, this.totalLikesCount, this.totalSharesCount);
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Fuser {
  var id;
  var firstName;
  var lastName;
  var userName;
  var profilePic;
  var jobTitle;

  Fuser(this.id, this.firstName, this.lastName, this.userName, this.profilePic,
      this.jobTitle);
  factory Fuser.fromJson(Map<String, dynamic> json) => _$FuserFromJson(json);
  Map<String, dynamic> toJson() => _$FuserToJson(this);
}
