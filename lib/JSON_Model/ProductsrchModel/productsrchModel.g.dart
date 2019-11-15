// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productsrchModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchModel _$ProductSearchModelFromJson(Map<String, dynamic> json) {
  return ProductSearchModel(
    (json['searchResult'] as List)
        ?.map((e) =>
            e == null ? null : SearchResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductSearchModelToJson(ProductSearchModel instance) =>
    <String, dynamic>{
      'searchResult': instance.searchResult,
    };

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
    json['id'],
    json['productName'],
    json['singleImage'] == null
        ? null
        : SingleImage.fromJson(json['singleImage'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'singleImage': instance.singleImage,
    };

SingleImage _$SingleImageFromJson(Map<String, dynamic> json) {
  return SingleImage(
    json['image'],
  );
}

Map<String, dynamic> _$SingleImageToJson(SingleImage instance) =>
    <String, dynamic>{
      'image': instance.image,
    };
