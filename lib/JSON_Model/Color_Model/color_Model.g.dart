// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorModel _$ColorModelFromJson(Map<String, dynamic> json) {
  return ColorModel(
    (json['colors'] as List)
        ?.map((e) =>
            e == null ? null : Colorss.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ColorModelToJson(ColorModel instance) =>
    <String, dynamic>{
      'colors': instance.colors,
    };

Colorss _$ColorssFromJson(Map<String, dynamic> json) {
  return Colorss(
    json['id'],
    json['colorCode'],
    json['colorName'],
  );
}

Map<String, dynamic> _$ColorssToJson(Colorss instance) => <String, dynamic>{
      'id': instance.id,
      'colorName': instance.colorName,
      'colorCode': instance.colorCode,
    };
