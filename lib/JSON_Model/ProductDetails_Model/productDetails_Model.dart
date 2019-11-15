import 'package:json_annotation/json_annotation.dart';

part 'productDetails_Model.g.dart';

@JsonSerializable()
class ProductDetailsModel {
  
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
  List<Images> images;
  List<Colorss> colors;
  List<Specs> specs;
  List<Tags> tags;
  Seller seller;

  ProductDetailsModel(this.id, this.sellerId, this.lowerPrice, this.productDesc, this.upperPrice, this.colors,
   this.estimatedDeliveryDays, this.images, this.isL, this.isM, this.isPrivateLabellingProvided, this.isS, this.isSampleProvided
   , this.isXL, this.isXS, this.isXXL, this.minimumOrderQuantity, this.productName, this.productType, this.shopId
   , this.specs, this.tags, this.seller);
  
  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsModelToJson(this);
}

@JsonSerializable()
class Images {
  var id;
  var image;

  Images(this.id, this.image);
  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class Colorss {
  var id;
   @JsonKey(name: "product_id")
  dynamic productId;
   @JsonKey(name: "color_id")
  dynamic colorId;
  GetColorCodes getColorCodes;

  Colorss(this.id, this.productId, this.colorId, this.getColorCodes);
  factory Colorss.fromJson(Map<String, dynamic> json) =>
      _$ColorssFromJson(json);
  Map<String, dynamic> toJson() => _$ColorssToJson(this);
}

@JsonSerializable()
class GetColorCodes {
  var id;
  var colorName;
  var colorCode;

  GetColorCodes(this.id, this.colorName, this.colorCode);
  factory GetColorCodes.fromJson(Map<String, dynamic> json) =>
      _$GetColorCodesFromJson(json);
  Map<String, dynamic> toJson() => _$GetColorCodesToJson(this);
}

@JsonSerializable()
class Specs {
  var id;
   @JsonKey(name: "product_id")
  dynamic productId;
  var specName;
  var specValue;

  Specs(this.id, this.productId, this.specName, this.specValue);
  factory Specs.fromJson(Map<String, dynamic> json) =>
      _$SpecsFromJson(json);
  Map<String, dynamic> toJson() => _$SpecsToJson(this);
}

@JsonSerializable()
class Tags {
  var id;
   @JsonKey(name: "product_id")
  dynamic productId;
  var tagName;

  Tags(this.id, this.productId, this.tagName);
  factory Tags.fromJson(Map<String, dynamic> json) =>
      _$TagsFromJson(json);
  Map<String, dynamic> toJson() => _$TagsToJson(this);
}

@JsonSerializable()
class Seller {
  var id;
  var firstName;
  var lastName;
  var profilePic;
  var jobTitle;
  var dayJob;
  var userName;
  Shop shop;

  Seller(this.id, this.firstName, this.lastName, this.profilePic, this.jobTitle, this.dayJob, this.userName);
  factory Seller.fromJson(Map<String, dynamic> json) =>
      _$SellerFromJson(json);
  Map<String, dynamic> toJson() => _$SellerToJson(this);
}

@JsonSerializable()
class Shop {
  var id;
  var shopLink;
  var shopName;
  var location;
  var shopType;

  Shop(this.id, this.shopLink, this.shopName, this.location, this.shopType);
  factory Shop.fromJson(Map<String, dynamic> json) =>
      _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);
}