import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/MarketplaceCard/marketplaceCard.dart';
import 'package:chatapp_new/Cards/MarketplaceCard/marketplacelandscapeCard.dart';
import 'package:chatapp_new/Cards/ShopProductCard/shopProductCard.dart';
import 'package:chatapp_new/Cards/ShopProductCard/shopProductLandCard.dart';
import 'package:chatapp_new/JSON_Model/Color_Model/color_Model.dart';
import 'package:chatapp_new/JSON_Model/MarketPlace_Model/marketPlace_model.dart';
import 'package:chatapp_new/JSON_Model/ShopModel/shopModel.dart';
import 'package:chatapp_new/Loader/MarketplaceLoader/marketplaceLoader.dart';
import 'package:chatapp_new/MainScreen/CreateProductPage/createProductPage.dart';
import 'package:chatapp_new/MainScreen/EditShopPage/editShopPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../main.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

int totalPage = 0, lastPage = 0;
int total = 0;
List colors = [];
bool colorClicked = false;

class ShopPage extends StatefulWidget {
  final shopId;

  ShopPage(this.shopId);
  @override
  _ShopPageState createState() => _ShopPageState();
}

enum PhotoCrop {
  free,
  picked,
  cropped,
}

class _ShopPageState extends State<ShopPage> {
  var productList, shopProductList;
  SharedPreferences sharedPreferences;
  String theme = "",
      typeService = "",
      productColor = "",
      productSize = "",
      productCategory = "";
  String des = "";
  String firstHalf;
  String secondHalf;
  String logo, logoImg, bannerImg;
  bool flag = true;
  Timer _timer;
  int _start = 3,
      selectType = 1,
      open = 0,
      activePage = 1,
      currentPage = 1,
      initLoad = 0, shopLength = 0;
  int xs = 0, s = 0, m = 0, l = 0, xl = 0, xxl = 0;
  bool loading = false, ratingOpen = false, proloading = false;
  var userData;
  var colorDetails;
  bool isSizeOpen = false;
  File logoImage, bannerImage;
  PhotoCrop state, state1;
  TextEditingController minPriceController = new TextEditingController();
  TextEditingController maxPriceController = new TextEditingController();
  List selectedColorList = [];
  List sizeList = [];
  List type = ["Product", "Service"];
  List color = ["Red", "Green", "Blue", "Orange", "Pink", "Violet", "Yellow"];
  List size = ["XS", "S", "M", "L", "XL", "XXL"];
  List category = [
    "Management",
    "App Development",
    "Web Development",
    "UI/UX",
    "SEO"
  ];

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownColorItems,
      _dropDownSizeItems,
      _dropDownCategoryItems;

  List<DropdownMenuItem<String>> getDropDowntypeService() {
    List<DropdownMenuItem<String>> items = new List();
    for (String typeServe in type) {
      items.add(new DropdownMenuItem(
          value: typeServe,
          child: new Text(
            typeServe,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownColorItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String colors in color) {
      items.add(new DropdownMenuItem(
          value: colors,
          child: new Text(
            colors,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownSizeItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sizes in size) {
      items.add(new DropdownMenuItem(
          value: sizes,
          child: new Text(
            sizes,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownCategoryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in category) {
      items.add(new DropdownMenuItem(
          value: cat,
          child: new Text(
            cat,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  @override
  void initState() {
    _getUserInfo();
    loadData();
    showProduct(1);
    state = PhotoCrop.free;
    state1 = PhotoCrop.free;

    _dropDowntypeService = getDropDowntypeService();
    typeService = _dropDowntypeService[0].value;

    _dropDownColorItems = getDropDownColorItems();
    productColor = _dropDownColorItems[0].value;

    _dropDownSizeItems = getDropDownSizeItems();
    productSize = _dropDownSizeItems[0].value;

    _dropDownCategoryItems = getDropDownCategoryItems();
    productCategory = _dropDownCategoryItems[0].value;

    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });

    print(userData);
  }

  Future loadData() async {
    setState(() {
      loading = true;
    });

    var postresponse =
        await CallApi().getData('getShopDetails/${widget.shopId}');
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var shopdata = ShopModel.fromJson(posts);

    setState(() {
      productList = shopdata;
    });

    des = productList.shopDetails.about;
    if (des.length > 150) {
      firstHalf = des.substring(0, 150);
      secondHalf = des.substring(150, des.length);
    } else {
      firstHalf = des;
      secondHalf = "";
    }

    logoImg = productList.shopDetails.logo;
    // if (logoImg == null) {
    //   productList.shopDetails.logo = null;
    // } else {
    //   if (logoImg.contains("localhost")) {
    //     logoImg = logoImg.replaceAll("localhost", "http://10.0.2.2");
    //   }
    // }

    bannerImg = productList.shopDetails.banner;
    // if (bannerImg == null) {
    //   productList.shopDetails.banner = null;
    // } else {
    //   if (bannerImg.contains("localhost")) {
    //     bannerImg = bannerImg.replaceAll("localhost", "http://10.0.2.2");
    //   }
    // }

    setState(() {
      loading = false;
    });
  }

  Future showProduct(int page) async {
    setState(() {
      proloading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi()
        .getData('getAllProductsByShop/${widget.shopId}?page=$activePage');
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var marketdata = MarketPlaceModel.fromJson(posts);

    setState(() {
      shopProductList = marketdata;
      lastPage = shopProductList.lastPage;
      totalPage = totalPage + shopProductList.data.length;
      proloading = false;
      shopLength = shopProductList.data.length;
    });

    // print("productList.data.length");
    // print(productList.data.length);

    // print("shopProductList.data.length");
    // print(shopProductList.data.length);
  }

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

  ////// <<<<< Logo Upload Start >>>>> //////

  Future<Null> _pickLogo() async {
    logoImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (logoImage != null) {
      setState(() {
        state = PhotoCrop.picked;
      });
    }
  }

  Future<Null> _cropLogo() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: logoImage.path,
      toolbarTitle: 'Cropper',
      toolbarColor: back,
      toolbarWidgetColor: Colors.grey,
    );
    if (croppedFile != null) {
      logoImage = croppedFile;
      setState(() {
        // state = PhotoCrop.free;
        state = PhotoCrop.cropped;
      });
      uploadLogo();
    }
  }

  Future uploadLogo() async {
    List<int> imageBytes = logoImage.readAsBytesSync();
    logo = base64.encode(imageBytes);
    logo = 'data:image/png;base64,' + logo;

    var data = {'shopId': userData['shop_id'], 'type': 1, 'image': logo};
    print(data);

    var res1 = await CallApi().postData(data, 'upload/shopImages');
    var body1 = json.decode(res1.body);
    print(body1);

    // setState(() {
    //   state = PhotoCrop.free;
    // });

    if (body1['success'] == true) {
      _showMsg("Shop Logo uploaded successfully!");
    }
  }

  ////// <<<<< Logo Upload End >>>>> //////

  ////// <<<<< Banner Upload Start >>>>> //////

  Future<Null> _pickBanner() async {
    bannerImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (bannerImage != null) {
      setState(() {
        state1 = PhotoCrop.picked;
      });
    }
  }

  Future<Null> _cropBanner() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: bannerImage.path,
      toolbarTitle: 'Cropper',
      toolbarColor: back,
      toolbarWidgetColor: Colors.grey,
    );
    if (croppedFile != null) {
      bannerImage = croppedFile;
      setState(() {
        // state = PhotoCrop.free;
        state1 = PhotoCrop.cropped;
      });
      uploadBanner();
    }
  }

  Future uploadBanner() async {
    List<int> imageBytes = bannerImage.readAsBytesSync();
    logo = base64.encode(imageBytes);
    logo = 'data:image/png;base64,' + logo;

    var data = {'shopId': userData['shop_id'], 'type': 0, 'image': logo};
    print(data);

    var res1 = await CallApi().postData(data, 'upload/shopImages');
    var body1 = json.decode(res1.body);
    print(body1);

    // setState(() {
    //   state1 = PhotoCrop.free;
    // });

    if (body1['success'] == true) {
      _showMsg("Shop Banner uploaded successfully!");
    }
  }

  ////// <<<<< Banner Upload End >>>>> //////
  ///

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
      Navigator.of(context).pop();
      _showFilterDialog();
    });

    setState(() {
      loading = false;
    });
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse('0xFF' + hexColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
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
                          "Shop Information",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditShopPage(widget.shopId)));
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
                ),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        body: loading == true && proloading == true
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        ////// <<<<< Cover Photo >>>>> //////
                        Container(
                          child: Stack(
                            children: <Widget>[
                              state1 == PhotoCrop.free
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 0, left: 0, right: 0),
                                      child: Container(
                                        height: 220,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: productList
                                                          .shopDetails.banner ==
                                                      null
                                                  ? AssetImage(
                                                      "assets/images/f9.jpg")
                                                  : NetworkImage("$bannerImg"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(0))),
                                        child: null,
                                      ),
                                    )
                                  : (state1 == PhotoCrop.picked ||
                                          state1 == PhotoCrop.cropped)
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: 0, left: 0, right: 0),
                                          child: Container(
                                            height: 220,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(bannerImage),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(0))),
                                            child: null,
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 0, left: 0, right: 0),
                                          child: Container(
                                            height: 220,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: productList.shopDetails
                                                              .banner ==
                                                          null
                                                      ? AssetImage(
                                                          "assets/images/f9.jpg")
                                                      : NetworkImage(
                                                          "$bannerImg"),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(0))),
                                            child: null,
                                          ),
                                        ),
                              // Container(
                              //     height: 200,
                              //     padding: const EdgeInsets.all(0.0),
                              //     margin: EdgeInsets.only(
                              //         top: 0, left: 0, right: 0),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black.withOpacity(0.2),
                              //       borderRadius: BorderRadius.only(
                              //           topLeft: Radius.circular(0),
                              //           topRight: Radius.circular(0)),
                              //     ),
                              //     child: null),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    ////// <<<<< Banner Crop Buttons >>>>> //////

                                    Container(
                                      child: state1 == PhotoCrop.picked
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20, right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          _cropBanner();
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  //shape: BoxShape.circle,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: Colors
                                                                          .grey[
                                                                      300]),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  left: 10,
                                                                  right: 10),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 5,
                                                                  top: 20,
                                                                  bottom: 0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(Icons.crop,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .black87),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                      "Crop",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontFamily:
                                                                              "Oswald"))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            state1 = PhotoCrop
                                                                .cropped;
                                                            uploadBanner();
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  //shape: BoxShape.circle,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color:
                                                                      header),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  left: 10,
                                                                  right: 10),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  top: 20,
                                                                  bottom: 0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(Icons.done,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .white),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                      "Done",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              "Oswald"))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container(),
                                    ),

                                    ////// <<<<< Banner Camera Button >>>>> //////
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _pickBanner();
                                        });
                                      },
                                      child: Container(
                                        height: 205,
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: header,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.all(4),
                                            margin: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.photo_camera,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ////// <<<<< Title >>>>> //////
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 0, left: 20),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _pickLogo();
                                  },
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        state == PhotoCrop.free
                                            ? Container(
                                                width: 50,
                                                height: 50,
                                                margin: EdgeInsets.only(
                                                    top: 15,
                                                    left: 0,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    image: DecorationImage(
                                                        image: productList
                                                                    .shopDetails
                                                                    .logo ==
                                                                null
                                                            ? AssetImage(
                                                                "assets/images/add_image.jpg")
                                                            : NetworkImage(
                                                                "$logoImg"),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        width: 0.3,
                                                        color:
                                                            Colors.grey[300])),
                                              )
                                            : (state == PhotoCrop.picked ||
                                                    state == PhotoCrop.cropped)
                                                ? Container(
                                                    width: 50,
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        top: 15,
                                                        left: 0,
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                logoImage),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                            width: 0.3,
                                                            color: Colors
                                                                .grey[300])),
                                                  )
                                                : Container(
                                                    width: 50,
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        top: 15,
                                                        left: 0,
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        image: DecorationImage(
                                                            image: productList
                                                                        .shopDetails
                                                                        .logo ==
                                                                    null
                                                                ? AssetImage(
                                                                    "assets/images/add_image.jpg")
                                                                : NetworkImage(
                                                                    "$logoImg"),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                            width: 0.3,
                                                            color: Colors
                                                                .grey[300])),
                                                  ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: header,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            padding: EdgeInsets.all(3),
                                            margin: EdgeInsets.only(
                                                left: 30, top: 50),
                                            child: Icon(
                                              Icons.photo_camera,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      productList.shopDetails.shopName == null
                                          ? ""
                                          : "${productList.shopDetails.shopName}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            )),

                        ////// <<<<< Logo Crop Buttons >>>>> //////

                        state == PhotoCrop.picked
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            _cropLogo();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                //shape: BoxShape.circle,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey[300]),
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            margin: EdgeInsets.only(
                                                right: 5, top: 20, bottom: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.crop,
                                                    size: 15,
                                                    color: Colors.black87),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text("Crop",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontFamily:
                                                                "Oswald"))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              state = PhotoCrop.cropped;
                                              uploadLogo();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                //shape: BoxShape.circle,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: header),
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10),
                                            margin: EdgeInsets.only(
                                                left: 5, top: 20, bottom: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.done,
                                                    size: 15,
                                                    color: Colors.white),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text("Done",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "Oswald"))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Container(),

                        ////// <<<<< Divider 1 >>>>> //////
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
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                            ),
                          ],
                        ),

                        ////// <<<<< Shop Category >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      top: 12, left: 20, bottom: 0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.label,
                                        size: 17,
                                        color: header,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 3),
                                        child: Text(
                                          productList.shopDetails.shopType ==
                                                  null
                                              ? ""
                                              : "Shop Type : ${productList.shopDetails.shopType.toUpperCase()}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),

                        ////// <<<<< Address >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      top: 0, left: 20, bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        size: 17,
                                        color: header,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 3),
                                        child: Text(
                                          productList.shopDetails.location ==
                                                  null
                                              ? ""
                                              : "${productList.shopDetails.location}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),

                        ////// <<<<< Description >>>>> //////
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              top: 0, left: 20, right: 20, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Description",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 0, right: 20, left: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                flag = !flag;
                              });
                            },
                            child: Container(
                              child: secondHalf == ""
                                  ? new Text(firstHalf,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 13,
                                          fontFamily: "Oswald",
                                          fontWeight: FontWeight.w300))
                                  : RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: flag
                                                  ? firstHalf + "..."
                                                  : firstHalf + secondHalf,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.w300)),
                                          TextSpan(
                                              text: flag ? " Read more" : "",
                                              style: TextStyle(
                                                  color: header,
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.w400)),
                                          // can add more TextSpans here...
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        ////// <<<<< Show all option >>>>> //////
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (ratingOpen == false) {
                                ratingOpen = true;
                              } else {
                                ratingOpen = false;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Colors.grey[300],
                                  )
                                ]),
                            margin:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            padding:
                                EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              //width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "4.5",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 30,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 3),
                                                          child: Text(
                                                            "Overall Rating",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              SmoothStarRating(
                                                            allowHalfRating:
                                                                false,
                                                            rating: 4.5,
                                                            size: 15,
                                                            starCount: 5,
                                                            spacing: 1.0,
                                                            color: Colors
                                                                .yellow[700],
                                                            //borderColor: Colors.teal[400],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ////// <<<<< Down arrow >>>>> //////
                                      Icon(
                                        ratingOpen
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        size: 20,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                ),
                                ratingOpen
                                    ? Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      "5*",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        lineHeight: 5.0,
                                                        percent: 0.95,
                                                        // center: Text(
                                                        //   "50.0%",
                                                        //   style:
                                                        //       new TextStyle(fontSize: 12.0),
                                                        // ),
                                                        // trailing: Text(
                                                        //   "95%",
                                                        //   textAlign: TextAlign.start,
                                                        //   style: TextStyle(
                                                        //       color: Colors.black54,
                                                        //       fontSize: 13,
                                                        //       fontFamily: 'Oswald',
                                                        //       fontWeight: FontWeight.w300),
                                                        // ),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        backgroundColor:
                                                            Colors.white,
                                                        progressColor: header,
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       right: 15),
                                                  //   child: Text(
                                                  //     "95%",
                                                  //     textAlign: TextAlign.start,
                                                  //     style: TextStyle(
                                                  //         color: Colors.black54,
                                                  //         fontSize: 13,
                                                  //         fontFamily: 'Oswald',
                                                  //         fontWeight:
                                                  //             FontWeight.w300),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      "4*",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        lineHeight: 5.0,
                                                        percent: 0.80,
                                                        // center: Text(
                                                        //   "50.0%",
                                                        //   style:
                                                        //       new TextStyle(fontSize: 12.0),
                                                        // ),
                                                        // trailing: Text(
                                                        //   "95%",
                                                        //   textAlign: TextAlign.start,
                                                        //   style: TextStyle(
                                                        //       color: Colors.black54,
                                                        //       fontSize: 13,
                                                        //       fontFamily: 'Oswald',
                                                        //       fontWeight: FontWeight.w300),
                                                        // ),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        backgroundColor:
                                                            Colors.white,
                                                        progressColor: header,
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       right: 15),
                                                  //   child: Text(
                                                  //     "80%",
                                                  //     textAlign: TextAlign.start,
                                                  //     style: TextStyle(
                                                  //         color: Colors.black54,
                                                  //         fontSize: 13,
                                                  //         fontFamily: 'Oswald',
                                                  //         fontWeight:
                                                  //             FontWeight.w300),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      "3*",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        lineHeight: 5.0,
                                                        percent: 0.85,
                                                        // center: Text(
                                                        //   "50.0%",
                                                        //   style:
                                                        //       new TextStyle(fontSize: 12.0),
                                                        // ),
                                                        // trailing: Text(
                                                        //   "95%",
                                                        //   textAlign: TextAlign.start,
                                                        //   style: TextStyle(
                                                        //       color: Colors.black54,
                                                        //       fontSize: 13,
                                                        //       fontFamily: 'Oswald',
                                                        //       fontWeight: FontWeight.w300),
                                                        // ),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        backgroundColor:
                                                            Colors.white,
                                                        progressColor: header,
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       right: 15),
                                                  //   child: Text(
                                                  //     "85%",
                                                  //     textAlign: TextAlign.start,
                                                  //     style: TextStyle(
                                                  //         color: Colors.black54,
                                                  //         fontSize: 13,
                                                  //         fontFamily: 'Oswald',
                                                  //         fontWeight:
                                                  //             FontWeight.w300),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      "2*",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        lineHeight: 5.0,
                                                        percent: 0.70,
                                                        // center: Text(
                                                        //   "50.0%",
                                                        //   style:
                                                        //       new TextStyle(fontSize: 12.0),
                                                        // ),
                                                        // trailing: Text(
                                                        //   "95%",
                                                        //   textAlign: TextAlign.start,
                                                        //   style: TextStyle(
                                                        //       color: Colors.black54,
                                                        //       fontSize: 13,
                                                        //       fontFamily: 'Oswald',
                                                        //       fontWeight: FontWeight.w300),
                                                        // ),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        backgroundColor:
                                                            Colors.white,
                                                        progressColor: header,
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       right: 15),
                                                  //   child: Text(
                                                  //     "70%",
                                                  //     textAlign: TextAlign.start,
                                                  //     style: TextStyle(
                                                  //         color: Colors.black54,
                                                  //         fontSize: 13,
                                                  //         fontFamily: 'Oswald',
                                                  //         fontWeight:
                                                  //             FontWeight.w300),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      "1*",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 12),
                                                      child:
                                                          LinearPercentIndicator(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            100,
                                                        lineHeight: 5.0,
                                                        percent: 0.78,
                                                        // center: Text(
                                                        //   "50.0%",
                                                        //   style:
                                                        //       new TextStyle(fontSize: 12.0),
                                                        // ),
                                                        // trailing: Text(
                                                        //   "95%",
                                                        //   textAlign: TextAlign.start,
                                                        //   style: TextStyle(
                                                        //       color: Colors.black54,
                                                        //       fontSize: 13,
                                                        //       fontFamily: 'Oswald',
                                                        //       fontWeight: FontWeight.w300),
                                                        // ),
                                                        linearStrokeCap:
                                                            LinearStrokeCap
                                                                .roundAll,
                                                        backgroundColor:
                                                            Colors.white,
                                                        progressColor: header,
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       right: 15),
                                                  //   child: Text(
                                                  //     "78%",
                                                  //     textAlign: TextAlign.start,
                                                  //     style: TextStyle(
                                                  //         color: Colors.black54,
                                                  //         fontSize: 13,
                                                  //         fontFamily: 'Oswald',
                                                  //         fontWeight:
                                                  //             FontWeight.w300),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< Number of products >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 20, bottom: 10),
                                  child: Text(
                                    shopLength == 0
                                        ? "No products"
                                        : "$shopLength products",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  )),

                              ////// <<<<< Show all option >>>>> //////
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    ////// <<<<< Add Product option >>>>> //////
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateProductPage()));
                                      },
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 5,
                                              bottom: 5),
                                          margin: EdgeInsets.only(right: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 2.0,
                                                  color: Colors.grey,
                                                )
                                              ]),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Add Product",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: header,
                                                      fontSize: 14,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 3, left: 3),
                                                child: Icon(Icons.add,
                                                    color: header, size: 15),
                                              )
                                            ],
                                          )),
                                    ),

                                    ////// <<<<< Filter option >>>>> //////
                                    // productList.shopDetails.allProducts
                                    //             .length ==
                                    //         0
                                    //     ? Container()
                                    //     : GestureDetector(
                                    //         onTap: () {
                                    //           loadColor();
                                    //           _showFilterDialog();
                                    //         },
                                    //         child: Container(
                                    //             alignment: Alignment.centerLeft,
                                    //             padding: EdgeInsets.only(
                                    //                 left: 8,
                                    //                 right: 8,
                                    //                 top: 5,
                                    //                 bottom: 5),
                                    //             margin:
                                    //                 EdgeInsets.only(right: 20),
                                    //             decoration: BoxDecoration(
                                    //                 color: Colors.white,
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         8),
                                    //                 boxShadow: [
                                    //                   BoxShadow(
                                    //                     blurRadius: 2.0,
                                    //                     color: Colors.grey,
                                    //                   )
                                    //                 ]),
                                    //             child: Row(
                                    //               children: <Widget>[
                                    //                 Container(
                                    //                   child: Text(
                                    //                     "Filter",
                                    //                     textAlign:
                                    //                         TextAlign.start,
                                    //                     style: TextStyle(
                                    //                         color: header,
                                    //                         fontSize: 14,
                                    //                         fontFamily:
                                    //                             'Oswald',
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .w400),
                                    //                   ),
                                    //                 ),
                                    //                 Container(
                                    //                   margin: EdgeInsets.only(
                                    //                       top: 3, left: 3),
                                    //                   child: Icon(
                                    //                       Icons.filter_list,
                                    //                       color: header,
                                    //                       size: 15),
                                    //                 )
                                    //               ],
                                    //             )),
                                    //       ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 10, right: 10),

                    ////// <<<<< Gridview >>>>> //////
                    sliver: SliverGrid(
                      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      //   maxCrossAxisExtent: 300.0,
                      //   mainAxisSpacing: 0.0,
                      //   crossAxisSpacing: 0.0,
                      //   childAspectRatio: 1.0,
                      // ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / 2) /
                                (MediaQuery.of(context).size.height / 2.5),
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        ////// <<<<< Portrait Card >>>>> //////
                        return proloading == true
                            ? MarketplaceLoaderCard()
                            : OrientationBuilder(
                                builder: (context, orientation) {
                                return orientation == Orientation.portrait
                                    ? MarketplaceCard(
                                        shopProductList.data[index])
                                    : MarketplaceLandCard(
                                        shopProductList.data[index]);
                              });

                        // ////// <<<<< Loader >>>>> //////
                        // : GroupLoaderCard();
                      },
                          childCount:
                              productList.shopDetails.allProducts.length),
                    ),
                  ),
                  shopLength == 0
                      ? SliverToBoxAdapter(
                          child: Container(),
                        )
                      : SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activePage--;
                                      //page3 = 0;
                                      if (activePage <= 1) {
                                        activePage = 1;
                                      }
                                      if (activePage % totalPage == 0) {
                                        currentPage = activePage - 2;
                                      }
                                    });
                                    // print(productList.lastPage);
                                    // print(productList.page);
                                    showProduct(activePage);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin:
                                          EdgeInsets.only(right: 0, left: 20),
                                      decoration: BoxDecoration(
                                          color: activePage == 1
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey,
                                            )
                                          ]),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 3, left: 0),
                                        child: Icon(Icons.chevron_left,
                                            color: activePage == 1
                                                ? Colors.grey[400]
                                                : header,
                                            size: 18),
                                      )),
                                ),
                                currentPage > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage;
                                          });
                                          showProduct(activePage);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right: activePage == lastPage
                                                    ? 10
                                                    : 5,
                                                left: 10),
                                            decoration: BoxDecoration(
                                                color: activePage == currentPage
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "$currentPage",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                currentPage + 1 > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage + 1;
                                          });
                                          showProduct(activePage);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right:
                                                    currentPage + 1 > lastPage
                                                        ? 5
                                                        : 10,
                                                left: 5),
                                            decoration: BoxDecoration(
                                                color: activePage ==
                                                        currentPage + 1
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "${currentPage + 1}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage + 1
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                currentPage + 2 > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage + 2;
                                          });
                                          showProduct(activePage);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right: 10, left: 5),
                                            decoration: BoxDecoration(
                                                color: activePage ==
                                                        currentPage + 2
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "${currentPage + 2}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage + 2
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activePage++;
                                      //page3 = 0;
                                      if (activePage >= lastPage) {
                                        activePage = lastPage;
                                      }
                                      if (activePage > currentPage + 2) {
                                        currentPage = activePage;
                                      }
                                    });
                                    // print(productList.lastPage);
                                    // print(productList.page);
                                    showProduct(activePage);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin:
                                          EdgeInsets.only(right: 20, left: 0),
                                      decoration: BoxDecoration(
                                          color: activePage == lastPage
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey,
                                            )
                                          ]),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 3, left: 0),
                                        child: Icon(Icons.chevron_right,
                                            color: activePage == lastPage
                                                ? Colors.grey[400]
                                                : header,
                                            size: 18),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ));
  }

  Future<Null> _showFilterDialog() async {
    if (typeService == "Product") {
      selectType = 1;
    } else {
      selectType = 2;
    }
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: colorDetails == null
              ? Center(child: Container(child: Text("Please wait...")))
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text(
                                    "Type: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w200),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      value: typeService,
                                      items: _dropDowntypeService,
                                      onChanged: (String value) {
                                        setState(() {
                                          typeService = value;
                                          print(typeService);
                                        });
                                        Navigator.of(context).pop();
                                        _showFilterDialog();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        selectType == 1
                            ? Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            //width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(
                                                top: 0, left: 0),
                                            child: Text(
                                              "Color: ",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w200),
                                            )),
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 0),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.end,
                                        //     children: <Widget>[
                                        //       DropdownButtonHideUnderline(
                                        //         child: DropdownButton(
                                        //           style: TextStyle(
                                        //               fontSize: 15,
                                        //               color: Colors.black87,
                                        //               fontFamily: 'Oswald',
                                        //               fontWeight: FontWeight.w300),
                                        //           value: productColor,
                                        //           items: _dropDownColorItems,
                                        //           onChanged: (String value) {
                                        //             setState(() {
                                        //               productColor = value;
                                        //             });
                                        //             Navigator.of(context).pop();
                                        //             _showFilterDialog();
                                        //           },
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Container(
                                          height: 35,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 5),
                                          child: new ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                //ColorCard(colorDetails.colors[index]),
                                                GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (colors.contains(
                                                      colorDetails
                                                          .colors[index].id)) {
                                                    colors.remove(colorDetails
                                                        .colors[index].id);
                                                    print(colors);
                                                  } else {
                                                    colors.add(colorDetails
                                                        .colors[index].id);
                                                    print(colors);
                                                  }
                                                });
                                                Navigator.of(context).pop();
                                                _showFilterDialog();
                                              },
                                              child: new Container(
                                                margin: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 5,
                                                    bottom: 5),
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  ////// <<<<< Color >>>>> //////
                                                  color: _getColorFromHex(
                                                      "${colorDetails.colors[index].colorCode}"),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Colors.black
                                                          .withOpacity(.5),
                                                    ),
                                                  ],
                                                ),
                                                child: colors.length != 0 &&
                                                        colors.contains(
                                                            colorDetails
                                                                .colors[index]
                                                                .id)
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                        ),
                                                        child: Icon(
                                                          Icons.done,
                                                          color: Colors.white,
                                                          size: 17,
                                                        ))
                                                    : Container(),
                                              ),
                                            ),
                                            itemCount:
                                                colorDetails.colors.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (isSizeOpen == false) {
                                                setState(() {
                                                  isSizeOpen = true;
                                                });
                                              } else {
                                                setState(() {
                                                  isSizeOpen = false;
                                                });
                                              }
                                              Navigator.of(context).pop();
                                              _showFilterDialog();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10,
                                                  top: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: isSizeOpen == false
                                                    ? null
                                                    : Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                      ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      child: Text(
                                                    "Size: ",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  )),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          top: 3),
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down))
                                                ],
                                              ),
                                            ),
                                          ),
                                          isSizeOpen == false
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2, top: 0),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10,
                                                        top: 10),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xs++;
                                                                if (xs % 2 ==
                                                                    0) {
                                                                  sizeList.remove(
                                                                      "isXS");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isXS");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
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
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                s++;
                                                                if (s % 2 ==
                                                                    0) {
                                                                  sizeList
                                                                      .remove(
                                                                          "isS");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isS");
                                                                }
                                                                //print(sizeList);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                              });
                                                            },
                                                            child: Container(
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
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                m++;
                                                                if (m % 2 ==
                                                                    0) {
                                                                  sizeList
                                                                      .remove(
                                                                          "isM");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isM");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
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
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                l++;
                                                                if (l % 2 ==
                                                                    0) {
                                                                  sizeList
                                                                      .remove(
                                                                          "isL");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isL");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
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
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xl++;
                                                                if (xl % 2 ==
                                                                    0) {
                                                                  sizeList.remove(
                                                                      "isXL");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isXL");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: xl % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: xl % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: xl % 2 ==
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
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xxl++;
                                                                if (xxl % 2 ==
                                                                    0) {
                                                                  sizeList.remove(
                                                                      "isXXL");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isXXL");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: xxl % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: xxl % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: xxl % 2 ==
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
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        margin:
                                            EdgeInsets.only(top: 0, left: 0),
                                        child: Text(
                                          "Category: ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w200),
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                            value: productCategory,
                                            items: _dropDownCategoryItems,
                                            onChanged: (String value) {
                                              setState(() {
                                                productCategory = value;
                                              });
                                              Navigator.of(context).pop();
                                              _showFilterDialog();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        Container(
                          //color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  //color: Colors.yellow,
                                  //width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text(
                                    "Price: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w200),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      //////// <<<<< From Textfield start >>>>> //////
                                      Container(
                                          width: 60,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextField(
                                            controller: minPriceController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Oswald',
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "",
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                              //labelStyle: TextStyle(color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.5, 2.5, 2.5, 2.5),
                                              border: InputBorder.none,
                                            ),
                                          )),

                                      //////// <<<<< From Textfield end >>>>> //////

                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            "To",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w200),
                                          )),

                                      //////// <<<<< To Textfield start >>>>> //////
                                      Container(
                                          width: 60,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextField(
                                            controller: maxPriceController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Oswald',
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "",
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                              //labelStyle: TextStyle(color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.5, 2.5, 2.5, 2.5),
                                              border: InputBorder.none,
                                            ),
                                          )),

                                      //////// <<<<< To Textfield end >>>>> //////
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //////// <<<<< Cancel Button start >>>>> //////
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          top: 20,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 17,
                                          fontFamily: 'BebasNeue',
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),

                              //////// <<<<< Cancel Button end >>>>> //////

                              //////// <<<<< Apply Button start >>>>> //////
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      filterProduct();
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 0,
                                          top: 20,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                          color: header,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'BebasNeue',
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                              //////// <<<<< Apply Button end >>>>> //////
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future filterProduct() async {
    setState(() {
      loading = true;
    });
    var data = {
      'maxPrice': minPriceController.text,
      'minPrice': maxPriceController.text,
      'sizes': sizeList,
      'colors': colors,
      'type': typeService == "Product" ? "product" : "service",
    };

    var res = await CallApi().postData(data, 'filter/allData?page=$activePage');
    var body = json.decode(res.body);
    var marketdata = MarketPlaceModel.fromJson(body);

    setState(() {
      // productList = marketdata;
      // lastPage = productList.lastPage;
      // total = total + productList.data.length;
      // print(lastPage);
      // print(total);

      shopProductList = marketdata;
      lastPage = shopProductList.lastPage;
      totalPage = totalPage + shopProductList.data.length;
    });

    print(body);

    setState(() {
      loading = false;
      initLoad = 1;
    });
  }
}
