import 'package:json_annotation/json_annotation.dart';

part 'color_Model.g.dart';

@JsonSerializable()
class ColorModel {
  List<Colorss> colors;

  ColorModel(this.colors);
  factory ColorModel.fromJson(Map<String, dynamic> json) =>
      _$ColorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ColorModelToJson(this);
}

@JsonSerializable()
class Colorss {
  var id;
  var colorName;
  var colorCode;

  Colorss(this.id, this.colorCode, this.colorName);
  factory Colorss.fromJson(Map<String, dynamic> json) =>
      _$ColorssFromJson(json);
  Map<String, dynamic> toJson() => _$ColorssToJson(this);
}
