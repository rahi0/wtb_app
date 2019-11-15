import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/ProductDetails_Model/productDetails_Model.dart';
import 'package:chatapp_new/JSON_Model/ReletedProductModel/relatedProduct_model.dart';
import 'package:chatapp_new/JSON_Model/check.dart';
import 'package:chatapp_new/MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'package:chatapp_new/MainScreen/ChatPage/chatPage.dart';
import 'package:chatapp_new/MainScreen/ProductEdit/productEdit.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../../main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final proId;
  ProductDetailsPage(this.proId);
  @override
  State<StatefulWidget> createState() {
    return DetailsPageState();
  }
}

class DetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  TextEditingController _reviewController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  bool xsVal = false,
      sVal = false,
      mVal = false,
      lVal = false,
      xlVal = false,
      xxlVal = false;
  var productDetails;
  var relProduct;
  String _debugLabelString = "", review = '', _ratingStatus = '';
  String xsStr = "", sStr = '', mStr = '', lStr = '', xlStr = '', xxlStr = '';
  bool _requireConsent = false;
  CarouselSlider carouselSlider;
  int _current = 0, active = 0, quantity = 0, pID = 0, uID = 0;
  int _rating = 0;
  int xs = 0, s = 0, m = 0, l = 0, xl = 0, xxl = 0;
  bool loading = false;
  List imgList = [];
  var userData;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    _getUserInfo();
    loadProductDetails();
    active = _current + 1;
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
      //_isLoaded = true;
      //loading = false;
    });

    print(userData);
    uID = userData['id'];
  }

  void rate(int rating) {
    //Other actions based on rating such as api calls.
    setState(() {
      _rating = rating;
    });

    if (rating == 1) {
      _ratingStatus = "Poor";
    }
    if (rating == 2) {
      _ratingStatus = "Average";
    }
    if (rating == 3) {
      _ratingStatus = "Good";
    }
    if (rating == 4) {
      _ratingStatus = "Very Good";
    }
    if (rating == 5) {
      _ratingStatus = "Excellent";
    }
  }

  Future loadProductDetails() async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));

    var productresponse =
        await CallApi().getData2('getProductDetails/${widget.proId}');
    var productcontent = productresponse.body;
    final pro = json.decode(productcontent);
    var productdata = ProductDetailsModel.fromJson(pro);

    setState(() {
      productDetails = productdata;
      pID = productDetails.sellerId;
    });

    loadRelatedProducts(productDetails);

    //print(productDetails.sellerId);
    // print("productDetails");
    // print(productDetails.images.length);

    for (int i = 0; i < productDetails.images.length; i++) {
      // if (productDetails.images[i].image.contains("localhost")) {
      //   productDetails.images[i].image = productDetails.images[i].image
      //       .replaceAll("localhost", "http://10.0.2.2");
      // }
      imgList.add(productDetails.images[i].image);
    }

    // print("imgList.length");
    // print(imgList.length);

    setState(() {
      loading = false;
    });
  }

  Future loadRelatedProducts(ProductDetailsModel productDetails) async {
    //await Future.delayed(Duration(seconds: 3));

    var relproductresponse = await CallApi().getData(
        'getRelatedProduct/${productDetails.seller.shop.id}?product_type=${productDetails.productType}&product_id=${productDetails.id}');
    var relproductcontent = relproductresponse.body;
    final relpro = json.decode(relproductcontent);
    var relproductdata = ReletedProductModel.fromJson(relpro);

    setState(() {
      relProduct = relproductdata;
    });

    // print("relProduct");
    // print(relProduct.relatedProducts.length);
    for (int i = 0; i < relProduct.relatedProducts.length; i++) {
      // if (relProduct.relatedProducts[i].singleImage.image
      //     .contains("localhost")) {
      //   relProduct.relatedProducts[i].singleImage.image = relProduct
      //       .relatedProducts[i].singleImage.image
      //       .replaceAll("localhost", "http://10.0.2.2");
      // }
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse('0xFF' + hexColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Product Details",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ),
              pID == uID
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProductPage(widget.proId)));
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: header,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Icon(Icons.edit, color: header, size: 17)
                            ],
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: productDetails == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: sub_white,
                //height: MediaQuery.of(context).size.height,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 300,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 0.2, color: Colors.grey)),
                                child: CarouselSlider(
                                  //height: 400.0,
                                  initialPage: 0,
                                  enlargeCenterPage: true,
                                  autoPlay: false,
                                  reverse: false,
                                  enableInfiniteScroll: true,
                                  autoPlayInterval: Duration(seconds: 2),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 2000),
                                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  items: imgList.map((imgUrl) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              //viewImage(_current);
                                            },
                                            child: Image.network(
                                              imgUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.black,
                                  child: Text(
                                    "${_current + 1}/${imgList.length}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Oswald"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      // Container(
                      //     width: 50,
                      //     child: Divider(
                      //       color: mainheader,
                      //     )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              productDetails.productName == null
                                  ? ""
                                  : "${productDetails.productName}",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: "Oswald",
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Rating : ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black45,
                                      fontFamily: "Oswald"),
                                ),
                                Container(
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    rating: 4.5,
                                    size: 15,
                                    starCount: 1,
                                    spacing: 1.0,
                                    color: header,
                                    //borderColor: Colors.teal[400],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                    "4.5",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                        fontFamily: "Oswald"),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Seller : ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black45,
                                              fontFamily: "Oswald"),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 3),
                                          child: Text(
                                              "${productDetails.seller.shop.shopName}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Oswald",
                                                color: header,
                                              )),
                                        ),
                                        Icon(
                                          Icons.verified_user,
                                          size: 16,
                                          color: header,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.attach_money,
                                          size: 18,
                                          color: Colors.black54,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 3),
                                          child: Text(
                                              (productDetails.lowerPrice ==
                                                      null)
                                                  ? ""
                                                  : "${productDetails.lowerPrice}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Oswald",
                                                color: Colors.black54,
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 3),
                                          child: Text(
                                              productDetails.upperPrice == null
                                                  ? ""
                                                  : "${productDetails.upperPrice}",
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.black87,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                decorationThickness: 2,
                                                fontSize: 16,
                                                fontFamily: "Oswald",
                                                color: Colors.black54,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Product Information",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: "Oswald"),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0, right: 5),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            //color: Colors.grey[200],
                                            //padding: EdgeInsets.all(20),
                                            child: Text(
                                          "Address : ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Oswald"),
                                        )),
                                        Container(
                                            child: Text(
                                          productDetails.seller.shop.location !=
                                                  null
                                              ? "${productDetails.seller.shop.location}"
                                              : "",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Oswald"),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            //color: Colors.grey[200],
                                            //padding: EdgeInsets.all(20),
                                            child: Text(
                                          "Type : ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Oswald"),
                                        )),
                                        Container(
                                            child: Text(
                                          productDetails.productType != null
                                              ? "${productDetails.productType.toUpperCase()}"
                                              : "",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Oswald"),
                                        ))
                                      ],
                                    ),
                                  ),
                                  productDetails.productType == "service"
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  //color: Colors.grey[200],
                                                  //padding: EdgeInsets.all(20),
                                                  child: Text(
                                                "Size : ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "Oswald"),
                                              )),
                                              Row(
                                                children: <Widget>[
                                                  ////// <<<<< XS check >>>>> //////
                                                  productDetails.isXS == "No" ||
                                                          productDetails.isXS ==
                                                              "0"
                                                      ? Container()
                                                      : Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xs++;
                                                                if (xs % 2 ==
                                                                    0) {
                                                                  xsStr = "No";
                                                                } else {
                                                                  xsStr = "Yes";
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: xs % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: xs % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: xs % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "XS",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                  ////// <<<<< S check >>>>> //////
                                                  productDetails.isS == "No" ||
                                                          productDetails.isS ==
                                                              "0"
                                                      ? Container()
                                                      : Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                s++;
                                                                if (s % 2 ==
                                                                    0) {
                                                                  sStr = "No";
                                                                } else {
                                                                  sStr = "Yes";
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: s % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: s % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: s % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "S",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                  ////// <<<<< M check >>>>> //////
                                                  productDetails.isM == "No" ||
                                                          productDetails.isM ==
                                                              "0"
                                                      ? Container()
                                                      : Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                m++;
                                                                if (m % 2 ==
                                                                    0) {
                                                                  mStr = "No";
                                                                } else {
                                                                  mStr = "Yes";
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: m % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: m % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: m % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "M",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                  ////// <<<<< L check >>>>> //////
                                                  productDetails.isL == "No" ||
                                                          productDetails.isL ==
                                                              "0"
                                                      ? Container()
                                                      : Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                l++;
                                                                if (l % 2 ==
                                                                    0) {
                                                                  lStr = "No";
                                                                } else {
                                                                  lStr = "Yes";
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: l % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: l % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: l % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "L",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                  ////// <<<<< XL check >>>>> //////
                                                  productDetails.isXL == "No" ||
                                                          productDetails.isXL ==
                                                              "0"
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              xl++;
                                                              if (xl % 2 == 0) {
                                                                xlStr = "No";
                                                              } else {
                                                                xlStr = "Yes";
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                1),
                                                                    decoration: BoxDecoration(
                                                                        color: xl % 2 ==
                                                                                0
                                                                            ? Colors
                                                                                .white
                                                                            : header.withOpacity(
                                                                                0.7),
                                                                        border: Border.all(
                                                                            color: xl % 2 == 0
                                                                                ? Colors.grey
                                                                                : header.withOpacity(0.7),
                                                                            width: 0.3),
                                                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                    child: Icon(
                                                                      Icons
                                                                          .done,
                                                                      color: xl %
                                                                                  2 ==
                                                                              0
                                                                          ? Colors
                                                                              .grey
                                                                          : Colors
                                                                              .white,
                                                                      size: 14,
                                                                    )),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "XL",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors.black.withOpacity(
                                                                            0.6),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Oswald',
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                  ////// <<<<< XXL check >>>>> //////
                                                  productDetails.isXXL ==
                                                              "No" ||
                                                          productDetails
                                                                  .isXXL ==
                                                              "0"
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              xxl++;
                                                              if (xxl % 2 ==
                                                                  0) {
                                                                xxlStr = "No";
                                                              } else {
                                                                xxlStr = "Yes";
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                1),
                                                                    decoration: BoxDecoration(
                                                                        color: xxl % 2 ==
                                                                                0
                                                                            ? Colors
                                                                                .white
                                                                            : header.withOpacity(
                                                                                0.7),
                                                                        border: Border.all(
                                                                            color: xxl % 2 == 0
                                                                                ? Colors.grey
                                                                                : header.withOpacity(0.7),
                                                                            width: 0.3),
                                                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                    child: Icon(
                                                                      Icons
                                                                          .done,
                                                                      color: xxl %
                                                                                  2 ==
                                                                              0
                                                                          ? Colors
                                                                              .grey
                                                                          : Colors
                                                                              .white,
                                                                      size: 14,
                                                                    )),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    "XXL",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors.black.withOpacity(
                                                                            0.6),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Oswald',
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                  productDetails.productType == "service"
                                      ? Container()
                                      : productDetails.colors.length == 0
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      //color: Colors.grey[200],
                                                      //padding: EdgeInsets.all(20),
                                                      child: Text(
                                                    "Color : ",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: "Oswald"),
                                                  )),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 5,
                                                          bottom: 10),
                                                      //color: sub_white,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding: EdgeInsets.only(
                                                          left: 0),
                                                      height: 40,
                                                      child:
                                                          new ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    int index) =>
                                                                new Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5),
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            ////// <<<<< Color >>>>> //////
                                                            color: _getColorFromHex(
                                                                "${productDetails.colors[index].getColorCodes.colorCode}"),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        15.0)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 3.0,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .5),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Stack(
                                                            children: <Widget>[
                                                              ////// <<<<< Color Name >>>>> //////
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              5,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          bottom:
                                                                              0),
                                                                  child: Text(
                                                                    "",
                                                                    //"${productDetails.colors[index].getColorCodes.colorName}",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Oswald',
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),

                                                        ////// <<<<< Color Length >>>>> //////
                                                        itemCount:
                                                            productDetails
                                                                .colors.length,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                  productDetails.productType == "service"
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  //color: Colors.grey[200],
                                                  //padding: EdgeInsets.all(20),
                                                  child: Text(
                                                "Quantity : ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: "Oswald"),
                                              )),
                                              Expanded(
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (quantity <= 0) {
                                                              quantity = 0;
                                                            } else {
                                                              quantity--;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          child: Icon(
                                                            Icons
                                                                .remove_circle_outline,
                                                            color:
                                                                Colors.black26,
                                                            size: 22,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3),
                                                        child: Text(
                                                          "$quantity",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            quantity++;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 3),
                                                          child: Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            color:
                                                                Colors.black26,
                                                            size: 22,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Product Description",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: "Oswald"),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              productDetails.productDesc != null
                                  ? "${productDetails.productDesc}"
                                  : "",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontFamily: "Oswald"),
                            ),
                          ],
                        ),
                      ),
                      productDetails.productType == "service"
                          ? Container()
                          : productDetails.specs.length == 0
                              ? Container()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      top: 5, left: 10, right: 10, bottom: 5),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 0.2, color: Colors.grey)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Product Specification",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontFamily: "Oswald"),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Column(
                                          children: _specificationList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                      ////// <<<<< tags start >>>>> ///////
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 5),
                        //padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 15),
                              child: Text(
                                "Tags",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontFamily: "Oswald"),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              //padding: EdgeInsets.only(left: 10),
                              height: 57,
                              child: productDetails.tags.length == 0
                                  ? Container(
                                      child: Text(
                                        "No tags avilable",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontFamily: "Oswald"),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              new Container(
                                        //color: Colors.white,
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            color: Colors.grey[100],
                                            border: Border.all(
                                                width: 0.2,
                                                color: Colors.grey)),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) => DetailsPage()),
                                            // );
                                          },
                                          child: Container(
                                            //padding: EdgeInsets.only(left: 20),
                                            //width: 100,
                                            child: Column(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 0),
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.label,
                                                              color: Colors
                                                                  .black54,
                                                              size: 16),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 3),
                                                            child: Text(
                                                              productDetails
                                                                          .tags[
                                                                              index]
                                                                          .tagName ==
                                                                      null
                                                                  ? ""
                                                                  : "${productDetails.tags[index].tagName}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black54),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      itemCount: productDetails.tags.length,
                                    ),
                            ),
                          ],
                        ),
                      ),

                      ////// <<<<< tags end >>>>> ///////

                      ////// <<<<< related product start >>>>> ///////
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 5),
                        //padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 15),
                              child: Text(
                                "Related Product",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontFamily: "Oswald"),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            relProduct == null
                                ? Center(child: CircularProgressIndicator())
                                : relProduct.relatedProducts.length == 0
                                    ? Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        color: Colors.white,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 55,
                                        child: Text(
                                          "No related products",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontFamily: "Oswald"),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        color: Colors.white,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        //padding: EdgeInsets.only(left: 10),
                                        height: 250,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              new Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsPage(
                                                                relProduct
                                                                    .relatedProducts[
                                                                        index]
                                                                    .id)),
                                                  );
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0,
                                                      top: 5,
                                                      left: 2.5,
                                                      right: 2.5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 1.0,
                                                        color: Colors.black
                                                            .withOpacity(.1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    height: 190,
                                                    width: 170,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 10.0,
                                                          color:
                                                              Colors.grey[300],
                                                          //offset: Offset(3.0, 4.0),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        /////// <<<<< Pic start >>>>> ///////
                                                        Expanded(
                                                          child: Container(
                                                              child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  ////// <<<<< Product Image >>>>> //////
                                                                  Center(
                                                                    child: Container(
                                                                        padding: const EdgeInsets.all(5.0),
                                                                        margin: EdgeInsets.only(top: 5),
                                                                        child: Image(
                                                                          image:
                                                                              //     AssetImage(
                                                                              //   'assets/images/shirt.jpg',
                                                                              // ),
                                                                              NetworkImage("${relProduct.relatedProducts[index].singleImage.image}"),
                                                                        )),
                                                                  ),

                                                                  ////// <<<<< Product Tag >>>>> //////
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                12),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                            padding: EdgeInsets.all(
                                                                                5),
                                                                            color:
                                                                                header,
                                                                            child:
                                                                                Text(
                                                                              "New",
                                                                              style: TextStyle(fontFamily: "Oswald", color: Colors.white, fontSize: 12),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ]),
                                                          )),
                                                        ),
                                                        /////// <<<<< Pic end >>>>> ///////

                                                        Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Divider(
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                              /////// <<<<< product title start >>>>> //////
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            8,
                                                                        left:
                                                                            8),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        relProduct.relatedProducts[index].productName == null
                                                                            ? ""
                                                                            : " ${relProduct.relatedProducts[index].productName}",
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Oswald",
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.black87)),
                                                                  ],
                                                                ),
                                                              ),
                                                              /////// <<<<< product title end >>>>> //////
                                                              SizedBox(
                                                                height: 5,
                                                              ),

                                                              /////// <<<<< product price start >>>>> //////
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 0,
                                                                        left:
                                                                            6),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      color: Colors
                                                                          .black87,
                                                                      size: 20,
                                                                    ),
                                                                    Text(
                                                                      (relProduct.relatedProducts[index].lowerPrice == null &&
                                                                              relProduct.relatedProducts[index].upperPrice)
                                                                          ? ""
                                                                          : " ${relProduct.relatedProducts[index].lowerPrice} - ${relProduct.relatedProducts[index].upperPrice}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              "Oswald",
                                                                          color: Colors
                                                                              .black87,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              /////// <<<<< product price end >>>>> //////

                                                              /////// <<<<< product rating start >>>>> //////
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8,
                                                                        left:
                                                                            8),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                8,
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.star,
                                                                              size: 13,
                                                                              color: header,
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(left: 3),
                                                                                child: Text("5.0", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: "Oswald", fontWeight: FontWeight.bold)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    ////// <<<<< Product Arrival Time >>>>> //////
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              8,
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              "2 days ago",
                                                                              style: TextStyle(fontFamily: "Oswald", color: Colors.grey, fontSize: 10)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              /////// <<<<< product rating end >>>>> //////
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          itemCount:
                                              relProduct.relatedProducts.length,
                                        ),
                                      ),
                          ],
                        ),
                      ),

                      ////// <<<<< related product end >>>>> ///////
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 0),
                                      //padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.star_border,
                                              size: 15, color: Colors.black54),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Review",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(
                                      color: Colors.black54,
                                    )),
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 0),
                                      //padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.share,
                                              size: 15, color: Colors.black54),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Share",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShopPage(productDetails.shopId)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: header,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shop,
                          size: 18,
                          color: Colors.white,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("Shop",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: "Oswald")))
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => ChattingPage()),
              //       // );
              //     },
              //     child: Container(
              //       margin: EdgeInsets.only(left: 10, right: 20),
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //           color: header,
              //           border: Border.all(width: 0.2, color: Colors.grey)),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: <Widget>[
              //           Icon(
              //             Icons.chat_bubble,
              //             size: 18,
              //             color: Colors.white,
              //           ),
              //           Container(
              //               margin: EdgeInsets.only(left: 5),
              //               child: Text("Chat",
              //                   style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 15,
              //                       fontFamily: "Oswald")))
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  void bottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  // void viewImage(int index) {
  //   Navigator.of(context).push(new MaterialPageRoute<Null>(
  //       builder: (BuildContext context) {
  //         return new SomeDialog(id: index);
  //       },
  //       fullscreenDialog: true));
  // }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  void callUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                    padding: EdgeInsets.all(1.0),
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/man.png'),
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.grey, // border color
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      //padding: EdgeInsets.all(10),
                      child: Text(
                        "Appifylab",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: header,
                          fontSize: 18,
                        ),
                      )),
                  Divider(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            //padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: Colors.black54,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "017XXXXXXXX",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 20, top: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: header,
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("Call",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        //padding: EdgeInsets.all(5),
                        child: Icon(
                      Icons.cancel,
                      color: Colors.grey[400],
                    )),
                  ),
                ],
              )
            ]),
          ),
          // content: Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //           //padding: EdgeInsets.all(10),
          //           child: Row(
          //             children: <Widget>[
          //               Icon(Icons.phone, color: Colors.black54),
          //               SizedBox(width: 5,),
          //               Text(
          //                 "017XXXXXXXX",
          //                 style: TextStyle(
          //                     color: Colors.black54),
          //               ),
          //             ],
          //           )),
          //     ],
          //   ),
          // ),
          // actions: <Widget>[
          //   // usually buttons at the bottom of the dialog
          //   // new FlatButton(
          //   //   child: new Text("Close"),
          //   //   onPressed: () {
          //   //     Navigator.of(context).pop();
          //   //   },
          //   // ),
          //   Center(
          //     child: Container(
          //           margin: EdgeInsets.only(left: 10, right: 20),
          //           padding: EdgeInsets.all(10),
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //               color: header,
          //               border: Border.all(width: 0.2, color: Colors.grey)),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               Container(
          //                   margin: EdgeInsets.only(left: 5),
          //                   child: Text("Call",
          //                       style:
          //                           TextStyle(color: Colors.white, fontSize: 13)))
          //             ],
          //           ),
          //         ),
          //   ),
          // ],
        );
      },
    );
  }

  List<Widget> _specificationList() {
    List<Widget> cards = [];
    for (var s in productDetails.specs) {
      cards.add(
        Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Text(
                  s.specName != null ? "${s.specName} : " : "",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15, color: Colors.grey, fontFamily: "Oswald"),
                ),
              ),
              Container(
                child: Text(
                  s.specValue != null ? "${s.specValue}" : "",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontFamily: "Oswald"),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return cards;
  }
}
