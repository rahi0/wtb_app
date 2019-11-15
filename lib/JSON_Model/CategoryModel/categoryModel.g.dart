// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catagory _$CatagoryFromJson(Map<String, dynamic> json) {
  return Catagory(
    (json['interests'] as List)
        ?.map((e) =>
            e == null ? null : Interests.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CatagoryToJson(Catagory instance) => <String, dynamic>{
      'interests': instance.interests,
    };

Interests _$InterestsFromJson(Map<String, dynamic> json) {
  return Interests(
    json['id'],
    json['name'],
    json['type'],
  );
}

Map<String, dynamic> _$InterestsToJson(Interests instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
    };
