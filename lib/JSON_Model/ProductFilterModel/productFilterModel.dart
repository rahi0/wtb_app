import 'package:json_annotation/json_annotation.dart';

part 'productFilterModel.g.dart';

@JsonSerializable()
class ProductFilterModel {
  SearchResult searchResult;
  ProductFilterModel(this. searchResult);
  factory ProductFilterModel.fromJson(Map<String, dynamic> json) =>
      _$ProductFilterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductFilterModelToJson(this);
}


@JsonSerializable()
class SearchResult {
  var total;
  var perPage;
  var page;
  var lastPage;
  List<Data> data;
  SearchResult(this.data, this.lastPage, this.page, this.perPage);
  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
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