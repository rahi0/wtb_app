// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatedProduct_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReletedProductModel _$ReletedProductModelFromJson(Map<String, dynamic> json) {
  return ReletedProductModel(
    (json['relatedProducts'] as List)
        ?.map((e) => e == null
            ? null
            : RelatedProducts.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReletedProductModelToJson(
        ReletedProductModel instance) =>
    <String, dynamic>{
      'relatedProducts': instance.relatedProducts,
    };

RelatedProducts _$RelatedProductsFromJson(Map<String, dynamic> json) {
  return RelatedProducts(
    json['id'],
    json['seller_id'],
    json['lowerPrice'],
    json['productDesc'],
    json['upperPrice'],
    json['estimatedDeliveryDays'],
    json['isL'],
    json['isM'],
    json['isPrivateLabellingProvided'],
    json['isS'],
    json['isSampleProvided'],
    json['isXL'],
    json['isXS'],
    json['isXXL'],
    json['minimumOrderQuantity'],
    json['productName'],
    json['product_type'],
    json['shop_id'],
    json['singleImage'] == null
        ? null
        : SingleImage.fromJson(json['singleImage'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RelatedProductsToJson(RelatedProducts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seller_id': instance.sellerId,
      'shop_id': instance.shopId,
      'productName': instance.productName,
      'productDesc': instance.productDesc,
      'product_type': instance.productType,
      'minimumOrderQuantity': instance.minimumOrderQuantity,
      'lowerPrice': instance.lowerPrice,
      'upperPrice': instance.upperPrice,
      'isSampleProvided': instance.isSampleProvided,
      'isPrivateLabellingProvided': instance.isPrivateLabellingProvided,
      'isXS': instance.isXS,
      'isS': instance.isS,
      'isM': instance.isM,
      'isL': instance.isL,
      'isXL': instance.isXL,
      'isXXL': instance.isXXL,
      'estimatedDeliveryDays': instance.estimatedDeliveryDays,
      'singleImage': instance.singleImage,
    };

SingleImage _$SingleImageFromJson(Map<String, dynamic> json) {
  return SingleImage(
    json['id'],
    json['product_id'],
    json['image'],
  );
}

Map<String, dynamic> _$SingleImageToJson(SingleImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'image': instance.image,
    };
