import 'package:json_annotation/json_annotation.dart';

part 'shopModel.g.dart';

@JsonSerializable()
class ShopModel {
  ShopDetails shopDetails;
  ShopModel(this.shopDetails);
  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}

@JsonSerializable()
class ShopDetails {
  var id;
  var shopLink;
  var shopName;
  var location;
  var shopType;
  var about;
  var logo;
  var banner;
  var shopTagLine;
  @JsonKey(name: "shopcategory_id")
  dynamic shopcategoryId;
  @JsonKey(name: "seller_id")
  dynamic sellerId;
  @JsonKey(name: "created_at")
  dynamic createdAt;
  @JsonKey(name: "updated_at")
  dynamic updatedAt;
  var status;
  List<AllProducts> allProducts;
  ShopDetails(
      this.shopType,
      this.location,
      this.id,
      this.about,
      this.allProducts,
      this.banner,
      this.logo,
      this.shopLink,
      this.shopName,
      this.shopTagLine,
      this.shopcategoryId,
      this.sellerId,
      this.status,
      this.createdAt,
      this.updatedAt);
  factory ShopDetails.fromJson(Map<String, dynamic> json) =>
      _$ShopDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ShopDetailsToJson(this);
}

@JsonSerializable()
class AllProducts {
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

  AllProducts(
      this.id,
      this.sellerId,
      this.lowerPrice,
      this.productDesc,
      this.upperPrice,
      this.estimatedDeliveryDays,
      this.singleImage,
      this.isL,
      this.isM,
      this.isPrivateLabellingProvided,
      this.isS,
      this.isSampleProvided,
      this.isXL,
      this.isXS,
      this.isXXL,
      this.minimumOrderQuantity,
      this.productName,
      this.productType,
      this.shopId);

  factory AllProducts.fromJson(Map<String, dynamic> json) =>
      _$AllProductsFromJson(json);
  Map<String, dynamic> toJson() => _$AllProductsToJson(this);
}

@JsonSerializable()
class SingleImage {
  var id;
  var image;

  SingleImage(this.id, this.image);
  factory SingleImage.fromJson(Map<String, dynamic> json) =>
      _$SingleImageFromJson(json);
  Map<String, dynamic> toJson() => _$SingleImageToJson(this);
}
