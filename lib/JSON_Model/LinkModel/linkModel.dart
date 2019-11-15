import 'package:json_annotation/json_annotation.dart';

part 'linkModel.g.dart';



@JsonSerializable()
class LinkModel {
  var status;
  var message;

  LinkModel(this.status, this.message);
  factory LinkModel.fromJson(Map<String, dynamic> json) =>
      _$LinkModelFromJson(json);
  Map<String, dynamic> toJson() => _$LinkModelToJson(this);
}
