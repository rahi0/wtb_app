import 'package:json_annotation/json_annotation.dart';

part 'marketPlace_model.g.dart';




@JsonSerializable()
class MarketPlaceModel {
  var total;
  var perPage;
  var page;
  var lastPage;
  List<Data> data;
  MarketPlaceModel(this.data, this.lastPage, this.page, this.perPage);
  factory MarketPlaceModel.fromJson(Map<String, dynamic> json) =>
      _$MarketPlaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketPlaceModelToJson(this);
}



@JsonSerializable()
class Data {
  var id;
  var productName;
  var productDesc;
  var status;
  var lowerPrice;
  var upperPrice;
  SingleImage singleImage;
  Data(this.id, this.productName, this.lowerPrice, 
       this.productDesc, this.singleImage, this.status, this.upperPrice);
  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}




@JsonSerializable()
class SingleImage {
  var id;
  var image;
  SingleImage(this.id, this.image, );
  factory SingleImage.fromJson(Map<String, dynamic> json) =>
      _$SingleImageFromJson(json);
  Map<String, dynamic> toJson() => _$SingleImageToJson(this);
}