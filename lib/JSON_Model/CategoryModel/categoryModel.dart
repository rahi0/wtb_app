import 'package:json_annotation/json_annotation.dart';

part 'categoryModel.g.dart';

@JsonSerializable()
class Catagory {
  List<Interests> interests;
  Catagory(this.interests);
  factory Catagory.fromJson(Map<String, dynamic> json) =>
      _$CatagoryFromJson(json);
  Map<String, dynamic> toJson() => _$CatagoryToJson(this);
}

@JsonSerializable()
class Interests {
  var id;
  var type;
  var name;

  Interests(this.id, this.name, this.type);
  factory Interests.fromJson(Map<String, dynamic> json) =>
      _$InterestsFromJson(json);
  Map<String, dynamic> toJson() => _$InterestsToJson(this);
}
