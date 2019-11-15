// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) {
  return ShopModel(
    json['shopDetails'] == null
        ? null
        : ShopDetails.fromJson(json['shopDetails'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'shopDetails': instance.shopDetails,
    };

ShopDetails _$ShopDetailsFromJson(Map<String, dynamic> json) {
  return ShopDetails(
    json['shopType'],
    json['location'],
    json['id'],
    json['about'],
    (json['allProducts'] as List)
        ?.map((e) =>
            e == null ? null : AllProducts.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['banner'],
    json['logo'],
    json['shopLink'],
    json['shopName'],
    json['shopTagLine'],
    json['shopcategory_id'],
    json['seller_id'],
    json['status'],
    json['created_at'],
    json['updated_at'],
  );
}

Map<String, dynamic> _$ShopDetailsToJson(ShopDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopLink': instance.shopLink,
      'shopName': instance.shopName,
      'location': instance.location,
      'shopType': instance.shopType,
      'about': instance.about,
      'logo': instance.logo,
      'banner': instance.banner,
      'shopTagLine': instance.shopTagLine,
      'shopcategory_id': instance.shopcategoryId,
      'seller_id': instance.sellerId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'status': instance.status,
      'allProducts': instance.allProducts,
    };

AllProducts _$AllProductsFromJson(Map<String, dynamic> json) {
  return AllProducts(
    json['id'],
    json['seller_id'],
    json['lowerPrice'],
    json['productDesc'],
    json['upperPrice'],
    json['estimatedDeliveryDays'],
    json['singleImage'] == null
        ? null
        : SingleImage.fromJson(json['singleImage'] as Map<String, dynamic>),
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
  );
}

Map<String, dynamic> _$AllProductsToJson(AllProducts instance) =>
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
    json['image'],
  );
}

Map<String, dynamic> _$SingleImageToJson(SingleImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
    };
