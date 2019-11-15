// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productFilterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductFilterModel _$ProductFilterModelFromJson(Map<String, dynamic> json) {
  return ProductFilterModel(
    json['searchResult'] == null
        ? null
        : SearchResult.fromJson(json['searchResult'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProductFilterModelToJson(ProductFilterModel instance) =>
    <String, dynamic>{
      'searchResult': instance.searchResult,
    };

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return SearchResult(
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['lastPage'],
    json['page'],
    json['perPage'],
  )..total = json['total'];
}

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'perPage': instance.perPage,
      'page': instance.page,
      'lastPage': instance.lastPage,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['id'],
    json['productName'],
    json['lowerPrice'],
    json['productDesc'],
    json['singleImage'] == null
        ? null
        : SingleImage.fromJson(json['singleImage'] as Map<String, dynamic>),
    json['status'],
    json['upperPrice'],
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'productDesc': instance.productDesc,
      'status': instance.status,
      'lowerPrice': instance.lowerPrice,
      'upperPrice': instance.upperPrice,
      'singleImage': instance.singleImage,
    };

SingleImage _$SingleImageFromJson(Map<String, dynamic> json) {
  return SingleImage(
    json['id'],
    json['image'],
  );
}

Map<String, dynamic> _$SingleImageToJson(SingleImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
    };
