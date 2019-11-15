import 'package:json_annotation/json_annotation.dart';

part 'relatedProduct_model.g.dart';



@JsonSerializable()
class ReletedProductModel {
  List<RelatedProducts> relatedProducts;

  ReletedProductModel(this.relatedProducts);
  factory ReletedProductModel.fromJson(Map<String, dynamic> json) =>
      _$ReletedProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReletedProductModelToJson(this);
}


@JsonSerializable()
class RelatedProducts {
  
  var id;
   @JsonKey(name: "seller_id")
  dynamic sellerId;
   @JsonKey(name: "shop_id")
  dynamic shopId;
  var productName;
  var productDesc;
   @JsonKey(name: "product_type")
  dynamic productType;
  var minimumOrderQuantity;
  var lowerPrice;
  var upperPrice;
  var isSampleProvided;
  var isPrivateLabellingProvided;
  var isXS;
  var isS;
  var isM;
  var isL;
  var isXL;
  var isXXL;
  var estimatedDeliveryDays;
  SingleImage singleImage;

  RelatedProducts(this.id, this.sellerId, this.lowerPrice, this.productDesc, this.upperPrice,
   this.estimatedDeliveryDays, this.isL, this.isM, this.isPrivateLabellingProvided, this.isS, this.isSampleProvided
   , this.isXL, this.isXS, this.isXXL, this.minimumOrderQuantity, this.productName, this.productType, this.shopId
   , this.singleImage);
  
  factory RelatedProducts.fromJson(Map<String, dynamic> json) =>
      _$RelatedProductsFromJson(json);
  Map<String, dynamic> toJson() => _$RelatedProductsToJson(this);
}



@JsonSerializable()
class SingleImage {
  var id;
   @JsonKey(name: "product_id")
  dynamic productId;
  var image;

  SingleImage(this.id, this.productId, this.image);
  factory SingleImage.fromJson(Map<String, dynamic> json) =>
      _$SingleImageFromJson(json);
  Map<String, dynamic> toJson() => _$SingleImageToJson(this);
}