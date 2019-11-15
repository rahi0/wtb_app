import 'package:json_annotation/json_annotation.dart';

part 'check.g.dart';

@JsonSerializable()
class Check {
  List<Result> result;
  Check(this.result);
  factory Check.fromJson(Map<String, dynamic> json) =>
      _$CheckFromJson(json);
  Map<String, dynamic> toJson() => _$CheckToJson(this);
}

@JsonSerializable()
class Result {
  var id;
  var category;
  var subcat;

  Result(this.id, this.subcat, this.category);
  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
