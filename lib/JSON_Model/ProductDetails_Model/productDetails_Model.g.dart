// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productDetails_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailsModel _$ProductDetailsModelFromJson(Map<String, dynamic> json) {
  return ProductDetailsModel(
    json['id'],
    json['seller_id'],
    json['lowerPrice'],
    json['productDesc'],
    json['upperPrice'],
    (json['colors'] as List)
        ?.map((e) =>
            e == null ? null : Colorss.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['estimatedDeliveryDays'],
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : Images.fromJson(e as Map<String, dynamic>))
        ?.toList(),
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
    (json['specs'] as List)
        ?.map(
            (e) => e == null ? null : Specs.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['tags'] as List)
        ?.map(
            (e) => e == null ? null : Tags.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['seller'] == null
        ? null
        : Seller.fromJson(json['seller'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProductDetailsModelToJson(
        ProductDetailsModel instance) =>
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
      'images': instance.images,
      'colors': instance.colors,
      'specs': instance.specs,
      'tags': instance.tags,
      'seller': instance.seller,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    json['id'],
    json['image'],
  );
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
    };

Colorss _$ColorssFromJson(Map<String, dynamic> json) {
  return Colorss(
    json['id'],
    json['product_id'],
    json['color_id'],
    json['getColorCodes'] == null
        ? null
        : GetColorCodes.fromJson(json['getColorCodes'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ColorssToJson(Colorss instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'color_id': instance.colorId,
      'getColorCodes': instance.getColorCodes,
    };

GetColorCodes _$GetColorCodesFromJson(Map<String, dynamic> json) {
  return GetColorCodes(
    json['id'],
    json['colorName'],
    json['colorCode'],
  );
}

Map<String, dynamic> _$GetColorCodesToJson(GetColorCodes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'colorName': instance.colorName,
      'colorCode': instance.colorCode,
    };

Specs _$SpecsFromJson(Map<String, dynamic> json) {
  return Specs(
    json['id'],
    json['product_id'],
    json['specName'],
    json['specValue'],
  );
}

Map<String, dynamic> _$SpecsToJson(Specs instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'specName': instance.specName,
      'specValue': instance.specValue,
    };

Tags _$TagsFromJson(Map<String, dynamic> json) {
  return Tags(
    json['id'],
    json['product_id'],
    json['tagName'],
  );
}

Map<String, dynamic> _$TagsToJson(Tags instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'tagName': instance.tagName,
    };

Seller _$SellerFromJson(Map<String, dynamic> json) {
  return Seller(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['jobTitle'],
    json['dayJob'],
    json['userName'],
  )..shop = json['shop'] == null
      ? null
      : Shop.fromJson(json['shop'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SellerToJson(Seller instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'userName': instance.userName,
      'shop': instance.shop,
    };

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    json['id'],
    json['shopLink'],
    json['shopName'],
    json['location'],
    json['shopType'],
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'id': instance.id,
      'shopLink': instance.shopLink,
      'shopName': instance.shopName,
      'location': instance.location,
      'shopType': instance.shopType,
    };
