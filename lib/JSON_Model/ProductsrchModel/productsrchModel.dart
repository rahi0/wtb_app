import 'package:json_annotation/json_annotation.dart';

part 'productsrchModel.g.dart';

@JsonSerializable()
class ProductSearchModel {
  List<SearchResult> searchResult;
  ProductSearchModel(this. searchResult);
  factory ProductSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSearchModelToJson(this);
}

@JsonSerializable()
class SearchResult {
  var id;
  var productName;
  SingleImage singleImage;
  SearchResult(this. id, this.productName, this.singleImage);
  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class SingleImage {
  var image;
  SingleImage(this. image);
  factory SingleImage.fromJson(Map<String, dynamic> json) =>
      _$SingleImageFromJson(json);
  Map<String, dynamic> toJson() => _$SingleImageToJson(this);
}