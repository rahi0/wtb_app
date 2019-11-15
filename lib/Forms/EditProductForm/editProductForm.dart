import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp_new/JSON_Model/Color_Model/color_Model.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:flutter/services.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/LinkModel/linkModel.dart';
import 'package:chatapp_new/JSON_Model/ProductDetails_Model/productDetails_Model.dart';
import 'package:chatapp_new/JSON_Model/ReletedProductModel/relatedProduct_model.dart';
import 'package:chatapp_new/JSON_Model/check.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';

import '../../main.dart';

List colors = [];
bool colorClicked = false;

class EditProductForm extends StatefulWidget {
  final proID;

  EditProductForm(this.proID);
  @override
  State<StatefulWidget> createState() {
    return EditProductFormState();
  }
}

class EditProductFormState extends State<EditProductForm> {
  bool loading = false;

  final TextEditingController proNameController = TextEditingController();
  final TextEditingController orderController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController shopTagsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController daysNameController = TextEditingController();

  String textValue, sample = '', labelling = '';
  String xsStr = "", sStr = '', mStr = '', lStr = '', xlStr = '', xxlStr = '';
  int xs = 0, s = 0, m = 0, l = 0, xl = 0, xxl = 0;
  Timer timeHandle;
  bool xsVal = false,
      sVal = false,
      mVal = false,
      lVal = false,
      xlVal = false,
      xxlVal = false;
  bool isNetwork = false;

  List<String> selectedTag = [];
  var finalTag;

  ScaffoldState scaffoldState;
  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  int selectedID = 0;
  SharedPreferences sharedPreferences;
  String theme = "", user = "";
  String productCategory = "";
  String shopID = "";
  int sellerID = 0;
  List allImages = [];
  List images = [];
  List imagesBase64 = [];
  var img;
  int maxImageNo = 10;
  bool selectSingleImage = false;

  var catList;
  var colorDetails;
  var userData;
  bool isLoading = false;
  bool isSubmit = false;
  bool isOpen = false;
  bool okButton = false;
  bool valueEnabled = false;
  //bool colorClicked = false;
  List imgList = [];
  //List sizeList = ["No", "No", "No", "No", "No", "No"];
  List sizeList = [];
  List specList = [];
  List selectedColorList = [];
  var specificationList;

  @override
  void initState() {
    sharedPrefcheck();
    loadProductDetails();
    _getUserInfo();
    loadColor();
    super.initState();
  }

  int count = 0, tnc = 0;
  var productDetails;

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
  }

  Future loadProductDetails() async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));

    var productresponse =
        await CallApi().getData2('getProductDetails/${widget.proID}');
    var productcontent = productresponse.body;
    final pro = json.decode(productcontent);
    var productdata = ProductDetailsModel.fromJson(pro);

    setState(() {
      productDetails = productdata;
    });

    setState(() {
      colors = [];
      proNameController.text = productDetails.productName;
      orderController.text = "${productDetails.minimumOrderQuantity}";
      minPriceController.text = "${productDetails.lowerPrice}";
      maxPriceController.text = "${productDetails.upperPrice}";
      daysNameController.text = "${productDetails.estimatedDeliveryDays}";
      descriptionController.text = "${productDetails.productDesc}";
      sellerID = productDetails.sellerId;
      xsStr = productDetails.isXS;
      if (xsStr == "Yes") {
        setState(() {
          xsVal = true;
        });
      } else {
        setState(() {
          xsVal = false;
        });
      }
      sStr = productDetails.isS;
      if (sStr == "Yes") {
        setState(() {
          sVal = true;
        });
      } else {
        setState(() {
          sVal = false;
        });
      }
      mStr = productDetails.isM;
      if (mStr == "Yes") {
        setState(() {
          mVal = true;
        });
      } else {
        setState(() {
          mVal = false;
        });
      }
      lStr = productDetails.isL;
      if (lStr == "Yes") {
        setState(() {
          lVal = true;
        });
      } else {
        setState(() {
          lVal = false;
        });
      }
      xlStr = productDetails.isXL;
      if (xlStr == "Yes") {
        setState(() {
          xlVal = true;
        });
      } else {
        setState(() {
          xlVal = false;
        });
      }
      xxlStr = productDetails.isXXL;
      if (xxlStr == "Yes") {
        setState(() {
          xxlVal = true;
        });
      } else {
        setState(() {
          xxlVal = false;
        });
      }

      sample = productDetails.isSampleProvided;
      labelling = productDetails.isPrivateLabellingProvided;

      for (int i = 0; i < productDetails.tags.length; i++) {
        selectedTag.add(productDetails.tags[i].tagName);
        finalTag = selectedTag.toList();
      }

      for (int i = 0; i < productDetails.specs.length; i++) {
        specList.add({
          "key": productDetails.specs[i].specName,
          "value": productDetails.specs[i].specValue
        });
        specificationList = specList.toList();
        valueEnabled = false;
      }

      for (int i = 0; i < productDetails.images.length; i++) {
        if (productDetails.images[i].image.contains("localhost")) {
          productDetails.images[i].image = productDetails.images[i].image
              .replaceAll("localhost", "http://10.0.2.2");
        }
        images.add("${productDetails.images[i].image}");
        img = images.toList();
        allImages.add("${productDetails.images[i].image}");

        isNetwork = true;
      }

      loading = false;

      for (int i = 0; i < productDetails.colors.length; i++) {
        colors.add(productDetails.colors[i].colorId);
      }
    });
  }

  Future loadColor() async {
    setState(() {
      loading = true;
    });

    var colorresponse = await CallApi().getData3('getAllProductColor');
    var colorcontent = colorresponse.body;
    final color = json.decode(colorcontent);
    var colordata = ColorModel.fromJson(color);

    setState(() {
      colorDetails = colordata;
    });

    setState(() {
      loading = false;
    });
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse('0xFF' + hexColor));
  }

  initMultiPickUp() async {
    setState(() {
      maxImageNo = maxImageNo - images.length;
    });
    List resultList;
    try {
      resultList = await FlutterMultipleImagePicker.pickMultiImages(
          maxImageNo, selectSingleImage);
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (!mounted) return;

    uploadImages(resultList);
    isNetwork = false;
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      shopID = "${userData['shop_id']}";
    });
  }

  Future uploadImages(List resultList) async {
    for (int i = 0; i < resultList.length; i++) {
      File file = new File(resultList[i].toString());
      List<int> imageBytes = file.readAsBytesSync();
      String image = base64.encode(imageBytes);
      image = 'data:image/png;base64,' + image;
      setState(() {
        images.add(resultList[i]);
        imagesBase64.add(image);
      });
    }
    var data3 = {'images': imagesBase64};
    var res1 = await CallApi().postData(data3, 'upload/imageMultiple');
    var body1 = json.decode(res1.body);

    if (body1['success'] == true) {
      //allImages = body1['uploadImages'];
      for (int i = 0; i < body1['uploadImages'].length; i++) {
        if (body1['uploadImages'][i]['image'].contains("localhost")) {
          body1['uploadImages'][i]['image'] = body1['uploadImages'][i]['image']
              .replaceAll("localhost", "http://10.0.2.2");
          allImages.add(body1['uploadImages'][i]['image']);
        }
      }
      print(allImages);
      setState(() {
        img = images.toList();
      });
    } else if (body1['success'] == false) {
      _showMsg(body1['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      child: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 0, left: 20),
                      child: Text(
                        "Edit Product",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(top: 10, left: 20),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                //offset: Offset(6.0, 7.0),
                              ),
                            ],
                            border:
                                Border.all(width: 0.5, color: Colors.black)),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 12, left: 20),
                      child: Text(
                        "Update your product information",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      )),

                  ////// <<<<< Product Name Field start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Product Name*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: proNameController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Product name",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Product Name Field end >>>>> //////

                  ///////// <<<<< Order Quantity Field start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Minimum Order Quantity*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: orderController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Order Quantity",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Product Name Field end >>>>> //////

                  ////// <<<<< Minimum Order Quantity Field >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Minimum Price*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 2, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: minPriceController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Minimum Price",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Shop location Field >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Maximum Price*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 2, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: maxPriceController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Maximum Price",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Shop location Field end >>>>> /////

                  ////// <<<<< Service or product Field end >>>>> /////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Available Sizes*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 2, top: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (xsVal == true) {
                                                xsVal = false;
                                              } else {
                                                xsVal = true;
                                              }
                                              //print(xsVal);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        color: xsVal == false
                                                            ? Colors.white
                                                            : header
                                                                .withOpacity(
                                                                    0.7),
                                                        border: Border.all(
                                                            color: xsVal ==
                                                                    false
                                                                ? Colors.grey
                                                                : header
                                                                    .withOpacity(
                                                                        0.7),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: xsVal == false
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      size: 14,
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "XS",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (sVal == true) {
                                                sVal = false;
                                              } else {
                                                sVal = true;
                                              }
                                              //print(sVal);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        color: sVal == false
                                                            ? Colors.white
                                                            : header
                                                                .withOpacity(
                                                                    0.7),
                                                        border: Border.all(
                                                            color: sVal == false
                                                                ? Colors.grey
                                                                : header
                                                                    .withOpacity(
                                                                        0.7),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: sVal == false
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      size: 14,
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "S",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (mVal == true) {
                                                mVal = false;
                                              } else {
                                                mVal = true;
                                              }
                                              //print(mVal);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        color: mVal == false
                                                            ? Colors.white
                                                            : header
                                                                .withOpacity(
                                                                    0.7),
                                                        border: Border.all(
                                                            color: mVal == false
                                                                ? Colors.grey
                                                                : header
                                                                    .withOpacity(
                                                                        0.7),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: mVal == false
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      size: 14,
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "M",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (lVal == true) {
                                                lVal = false;
                                              } else {
                                                lVal = true;
                                              }
                                              //print(lVal);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        color: lVal == false
                                                            ? Colors.white
                                                            : header
                                                                .withOpacity(
                                                                    0.7),
                                                        border: Border.all(
                                                            color: lVal == false
                                                                ? Colors.grey
                                                                : header
                                                                    .withOpacity(
                                                                        0.7),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: lVal == false
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      size: 14,
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "L",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (xlVal == true) {
                                                xlVal = false;
                                              } else {
                                                xlVal = true;
                                              }
                                              //print(xlVal);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        color: xlVal == false
                                                            ? Colors.white
                                                            : header
                                                                .withOpacity(
                                                                    0.7),
                                                        border: Border.all(
                                                            color: xlVal ==
                                                                    false
                                                                ? Colors.grey
                                                                : header
                                                                    .withOpacity(
                                                                        0.7),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: xlVal == false
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      size: 14,
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "XL",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (xxlVal == true) {
                                                xxlVal = false;
                                              } else {
                                                xxlVal = true;
                                              }
                                              //print(xxlVal);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        color: xxlVal == false
                                                            ? Colors.white
                                                            : header
                                                                .withOpacity(
                                                                    0.7),
                                                        border: Border.all(
                                                            color: xxlVal ==
                                                                    false
                                                                ? Colors.grey
                                                                : header
                                                                    .withOpacity(
                                                                        0.7),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Icon(
                                                      Icons.done,
                                                      color: xxlVal == false
                                                          ? Colors.grey
                                                          : Colors.white,
                                                      size: 14,
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "XXL",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontSize: 14,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                  ),
                  ////// <<<<< service or product Field end >>>>> /////

                  ////// <<<<< Is Sample Provided start >>>>> /////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Is Sample Provided*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.only(
                              left: 0, right: 15, top: 10, bottom: 10),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sample = 'Yes';
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: sample == 'Yes'
                                                    ? header.withOpacity(0.7)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: sample == 'Yes'
                                                        ? header
                                                            .withOpacity(0.7)
                                                        : Colors.grey,
                                                    width: 0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.radio_button_unchecked,
                                              color: sample == 'Yes'
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Yes",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sample = 'No';
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: sample == 'No'
                                                    ? header.withOpacity(0.7)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: sample == 'No'
                                                        ? header
                                                            .withOpacity(0.7)
                                                        : Colors.grey,
                                                    width: 0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.radio_button_unchecked,
                                              color: sample == 'No'
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "No",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Is Sample Provided end >>>>> //////

                  ////// <<<<< Is Private Labelling Provided start >>>>> /////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Is Private Labelling Provided*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.only(
                              left: 0, right: 15, top: 10, bottom: 10),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      labelling = 'Yes';
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: labelling == 'Yes'
                                                    ? header.withOpacity(0.7)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: labelling == 'Yes'
                                                        ? header
                                                            .withOpacity(0.7)
                                                        : Colors.grey,
                                                    width: 0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.radio_button_unchecked,
                                              color: labelling == 'Yes'
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Yes",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      labelling = 'No';
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: labelling == 'No'
                                                    ? header.withOpacity(0.7)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: labelling == 'No'
                                                        ? header
                                                            .withOpacity(0.7)
                                                        : Colors.grey,
                                                    width: 0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.radio_button_unchecked,
                                              color: labelling == 'No'
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "No",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Is Private Labelling Provided end >>>>> //////

                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Color*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsets.only(
                              left: 0, right: 15, top: 5, bottom: 5),
                          child: Container(
                            //color: sub_white,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 5),
                            height: 40,
                            child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) =>
                                  //ColorCard(colorDetails.colors[index]),
                                  GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (colors.contains(
                                        colorDetails.colors[index].id)) {
                                      colors.remove(
                                          colorDetails.colors[index].id);
                                      //print(colors);
                                    } else {
                                      colors.add(colorDetails.colors[index].id);
                                      //print(colors);
                                    }
                                  });
                                },
                                child: new Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    ////// <<<<< Color >>>>> //////
                                    color: _getColorFromHex(
                                        "${colorDetails.colors[index].colorCode}"),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(.5),
                                      ),
                                    ],
                                  ),
                                  child: colors.length != 0 &&
                                          colors.contains(
                                              colorDetails.colors[index].id)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                          ),
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          ))
                                      : Container(),
                                ),
                              ),
                              itemCount: colorDetails.colors.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Tag Line Field >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Service Tags*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 2, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: TextField(
                                            controller: shopTagsController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Oswald',
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Enter tag and press ok button",
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                              //labelStyle: TextStyle(color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10.0, 2.5, 20.0, 2.5),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (shopTagsController.text ==
                                                    "") {
                                                  okButton = false;
                                                } else {
                                                  okButton = true;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      okButton
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (selectedTag.length <= 4) {
                                                    selectedTag.add(
                                                        shopTagsController
                                                            .text);
                                                    finalTag =
                                                        selectedTag.toList();
                                                    shopTagsController.text =
                                                        "";
                                                    okButton = false;
                                                  } else {
                                                    _showMsg(
                                                        "Maximum 5 tags can be added");
                                                  }
                                                  //print(finalTag);
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(Icons.done,
                                                    color: header, size: 22),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Tag Line Field end >>>>> //////

                  ////// <<<<< Tag List Start >>>>> //////

                  selectedTag.length != 0
                      ? Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          margin:
                              EdgeInsets.only(top: 10, bottom: 15, left: 15),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedTag.length,
                            //separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 8, bottom: 8),
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "${finalTag[index]}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedTag.removeAt(index);
                                              finalTag = selectedTag;
                                              //print(finalTag);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Icon(Icons.clear),
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            },
                          ),
                        )
                      : Container(),

                  ////// <<<<< Tag List End >>>>> //////

                  ////// <<<<< Estimated Day Field start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Estimated Delivery Days*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: daysNameController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Delivery Days",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Estimated Day Field end >>>>> //////

                  ////// <<<<< Tag List Start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Product Description*",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 2, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: descriptionController,
                                    maxLines: 4,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Shop description",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Shop location Field end >>>>> /////

                  ////// <<<<< Specs Field Start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Product Specification (Optional)",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 2, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Container(
                                            child: TextField(
                                              controller: keyController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontFamily: 'Oswald',
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Key*",
                                                hintStyle: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                                //labelStyle: TextStyle(color: Colors.white70),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10.0, 2.5, 20.0, 2.5),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (keyController.text ==
                                                      "") {
                                                    valueEnabled = false;
                                                  } else {
                                                    valueEnabled = true;
                                                  }
                                                });
                                              },
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: Container(
                                            child: TextField(
                                              enabled:
                                                  valueEnabled ? true : false,
                                              controller: valueController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontFamily: 'Oswald',
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Value*",
                                                hintStyle: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                                //labelStyle: TextStyle(color: Colors.white70),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10.0, 2.5, 20.0, 2.5),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          )),
                                    ),
                                    ////// <<<<< Add Spec button >>>>> //////
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (valueController.text == "" &&
                                                  keyController.text == "") {
                                                _showMsg(
                                                    "Please enter a valid specification");
                                              } else {
                                                keyValues(keyController.text,
                                                    valueController.text);
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 0),
                                                decoration: BoxDecoration(
                                                    color: header,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
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
                      ],
                    ),
                  ),
                  ////// <<<<< Specs Field End >>>>> //////

                  ///// <<<<<  SpecList start >>>>> //////
                  specList.length == 0
                      ? Container()
                      : Container(
                          height: 150,
                          margin: EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            itemCount: specList.length,
                            //separatorBuilder: (context, index) => Divider(),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.only(
                                      bottom: 5, top: 3, left: 20, right: 20),
                                  padding: EdgeInsets.only(
                                      bottom: 6, top: 6, left: 10, right: 10),
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "${specificationList[index]['key']} :",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Oswald"),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 3),
                                                  child: Text(
                                                    "${specificationList[index]['value']}",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "Oswald",
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              specificationList.removeAt(index);
                                              specList = specificationList;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.grey,
                                                size: 18,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),

                  ///// <<<<<  SpecList end >>>>> //////

                  ////// <<<<< Upload Images Field Start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Upload Images",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        GestureDetector(
                          onTap: images.length < 10 ? initMultiPickUp : null,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              (images == null ||
                                                      images.length == 0)
                                                  ? "Select from gallery (Max. 10 images)"
                                                  : "${images.length}/10 images",
                                              style: TextStyle(
                                                  color: (images == null ||
                                                          images.length == 0)
                                                      ? Colors.black38
                                                      : header,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(Icons.photo_camera,
                                              color: header, size: 22),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Upload Images Field end >>>>> //////

                  ////// <<<<< Delete title >>>>> //////
                  (images == null || images.length == 0)
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                            "Tap on image to delete",
                            style: TextStyle(
                                fontFamily: "Oswald", color: Colors.grey[700]),
                          ),
                        ),
                  ////// <<<<< Image List Start >>>>> //////

                  (images == null || images.length == 0)
                      ? Container()
                      : Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(top: 10, bottom: 0, left: 15),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            //separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      img.removeAt(index);
                                      allImages.removeAt(index);
                                      images = img;
                                      print(images.length);
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        border: Border.all(
                                            color: Colors.grey, width: 0.3),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: img[index]
                                                    .contains("storage")
                                                ? FileImage(
                                                    File(img[index].toString()))
                                                : NetworkImage(
                                                    img[index].toString()))),
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 8, bottom: 8),
                                    // padding:
                                    //     EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                    // child: Image.file(
                                    //   new File(images[index].toString()),
                                    //   // height: 20,
                                    //   // width: 20,
                                    // )),
                                  ));
                            },
                          ),
                        ),

                  ////// <<<<< Image List End >>>>> //////

                  ////// <<<<< Create Shop button >>>>> //////
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: isSubmit ? null : signUpButton,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  color: isSubmit ? Colors.grey : header,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                isSubmit ? "Please wait..." : "Edit Product",
                                style: TextStyle(
                                  color: isSubmit ? Colors.black : Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'BebasNeue',
                                ),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void signUpButton() async {
    if (proNameController.text.isEmpty) {
      return _showMsg("Product name is empty");
    } else if (orderController.text.isEmpty) {
      return _showMsg("Minimum Order Quantity is empty");
    } else if (minPriceController.text.isEmpty) {
      return _showMsg("Minimum Price is empty");
    } else if (maxPriceController.text.isEmpty) {
      return _showMsg("Maximum Price is empty");
    } else if (daysNameController.text.isEmpty) {
      return _showMsg("Estimated Delivery Days is empty");
    } else if (sample == "") {
      return _showMsg("Sample not selected");
    } else if (labelling == "") {
      return _showMsg("Private Labelling not selected");
    } else if (colors.length == 0) {
      return _showMsg("Please select colors");
    } else if (selectedTag.length == 0) {
      return _showMsg("Please enter tags");
    } else if (descriptionController.text.isEmpty) {
      return _showMsg("Product description is empty");
    } else if (keyController.text.isNotEmpty && valueController.text.isEmpty) {
      return _showMsg("Specification value is empty");
    } else if (allImages.length == 0) {
      return _showMsg("Please select image");
    }

    setState(() {
      isSubmit = true;
    });

    var data2 = {
      'shop_id': shopID,
      'seller_id': sellerID,
      'productName': proNameController.text,
      'productDesc': descriptionController.text,
      'minimumOrderQuantity': orderController.text,
      'lowerPrice': minPriceController.text,
      'upperPrice': maxPriceController.text,
      'isSampleProvided': sample,
      'isPrivateLabellingProvided': labelling,
      //'sizes': sizeList,
      'isXS': xsVal,
      'isS': sVal,
      'isM': mVal,
      'isL': lVal,
      'isXL': xlVal,
      'isXXL': xxlVal,
      'estimatedDeliveryDays': daysNameController.text,
      'colors': colors,
      'tags': selectedTag,
      'images': allImages,
      'specs': specList,
    };

    print(data2);

    var res = await CallApi().postData1(data2, 'edit/Product/${widget.proID}');
    var body = json.decode(res.body);
    print(body);

    if (body['succes'] == true) {
      // setState(() {
      //   proNameController.text = "";
      //   descriptionController.text = "";
      //   orderController.text = "";
      //   minPriceController.text = "";
      //   maxPriceController.text = "";
      //   daysNameController.text = "";
      //   sample = "";
      //   labelling = "";
      //   sizeList = [];
      //   colors = [];
      //   selectedTag = [];
      //   allImages = [];
      //   images = [];
      //   specList = [];
      // });
      //loadColor();
      _showCompleteDialog();
    } else if (body['succes'] == false) {
      //print(body['message']);
      _showMsg(body['message']);
    }

    setState(() {
      isSubmit = false;
    });
  }

  Future<Null> _showCompleteDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: header, width: 1.5),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white),
                        child: Icon(
                          Icons.done,
                          color: header,
                          size: 50,
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Product has been edited successfully!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopPage(userData['shop_id'])));
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void keyValues(String key, String value) {
    setState(() {
      specList.add({"key": key, "value": value});
      specificationList = specList.toList();
      keyController.text = "";
      valueController.text = "";
      valueEnabled = false;
      //print(specList);
    });
  }
}
