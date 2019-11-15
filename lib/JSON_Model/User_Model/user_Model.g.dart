// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) {
  return Connection(
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    (json['res'] as List)
        ?.map((e) => e == null ? null : Res.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'user': instance.user,
      'res': instance.res,
    };

Res _$ResFromJson(Map<String, dynamic> json) {
  return Res(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['jobTitle'],
    json['dayJob'],
    json['userName'],
    json['tag'],
    json['friendStatus'],
  );
}

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'userName': instance.userName,
      'tag': instance.tag,
      'friendStatus': instance.friendStatus,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['jobTitle'],
    json['dayJob'],
    json['userName'],
    json['country'],
    json['shop_id'],
    json['avgReview'],
    json['email'],
    json['gender'],
    json['userType'],
    (json['interestLists'] as List)
        ?.map((e) => e == null
            ? null
            : InterestLists.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'userName': instance.userName,
      'country': instance.country,
      'shop_id': instance.shop_id,
      'avgReview': instance.avgReview,
      'email': instance.email,
      'gender': instance.gender,
      'userType': instance.userType,
      'interestLists': instance.interestLists,
    };

InterestLists _$InterestListsFromJson(Map<String, dynamic> json) {
  return InterestLists(
    json['id'],
    json['tag'],
  );
}

Map<String, dynamic> _$InterestListsToJson(InterestLists instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
    };
