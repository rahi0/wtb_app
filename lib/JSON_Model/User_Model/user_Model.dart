import 'package:json_annotation/json_annotation.dart';

part 'user_Model.g.dart';

@JsonSerializable()
class Connection {
  User user;
  List<Res> res;
  Connection(this.user, this.res);
  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);
}

@JsonSerializable()
class Res {
  var id;
  var firstName;
  var lastName;
  var profilePic;
  var jobTitle;
  var dayJob;
  var userName;
  var tag;
  var friendStatus;

  Res(this.id, this.firstName, this.lastName, this.profilePic, this.jobTitle,
      this.dayJob, this.userName, this.tag, this.friendStatus);

  factory Res.fromJson(Map<String, dynamic> json) => _$ResFromJson(json);
  Map<String, dynamic> toJson() => _$ResToJson(this);
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
  var email;
  var gender;
  var userType;
  List<InterestLists> interestLists;

  User(
      this.id,
      this.firstName,
      this.lastName,
      this.profilePic,
      this.jobTitle,
      this.dayJob,
      this.userName,
      this.country,
      this.shop_id,
      this.avgReview,
      this.email,
      this.gender,
      this.userType, this.interestLists);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}


@JsonSerializable()
class InterestLists {
  var id;
  var tag;

  InterestLists(this.id, this.tag);

  factory InterestLists.fromJson(Map<String, dynamic> json) => _$InterestListsFromJson(json);
  Map<String, dynamic> toJson() => _$InterestListsToJson(this);
}