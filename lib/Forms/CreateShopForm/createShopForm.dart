import 'dart:async';
import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/LinkModel/linkModel.dart';
import 'package:chatapp_new/JSON_Model/check.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class CreateShopForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateShopFormState();
  }
}

class CreateShopFormState extends State<CreateShopForm> {
  var shopLink;
  bool loading = false;

  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopLinkController = TextEditingController();
  final TextEditingController shopLocationController = TextEditingController();
  final TextEditingController shopDescriptionController =
      TextEditingController();
  final TextEditingController shopTagLineController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  String textValue;
  Timer timeHandle;

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

  int count = 0, selectType = 0, userType = 0, userType1 = 0, selectedID = 0;
  SharedPreferences sharedPreferences;
  String theme = "", user = "";
  String typeService = "",
      productBuyer = "",
      productSeller = "",
      productCategory = "",
      typeCategory = "",
      uType = "",
      cat = "";

  List<String> selectedCategory = [];
  var selectedCat;

  List catOpt = ["Product", "Service"];
  List shopCAt = [];
  //List categories;
  var catList;
  bool isLoading = true;
  bool isSubmit = false;
  bool isOpen = false;

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownBuyerItems,
      _dropDownSellerItems,
      _dropDownCategoryItems;

  List<DropdownMenuItem<String>> getDropDownSizeCats() {
    List<DropdownMenuItem<String>> items = new List();
    for (String catsOpt in catOpt) {
      items.add(new DropdownMenuItem(
          value: catsOpt,
          child: new Text(
            catsOpt,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownCategoryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in catList) {
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
    sharedPrefcheck();
    _dropDownCategoryItems = getDropDownSizeCats();
    productCategory = _dropDownCategoryItems[0].value;

    loadCategories();
    loadShopInfo();
    // print("selectedCategory.length");
    // print(selectedCategory.length);
    super.initState();
  }

  Future loadShopInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //localStorage.setString('token', body['token']);
    //localStorage.setString('user', json.encode(body['user']));
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    var userData;
    setState(() {
      userData = user;
    });
    print("${userData['shop_id']}");
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  String _mySelection = "";
  List data;

  Future loadCategories() async {
    await Future.delayed(Duration(seconds: 3));

    var response = await CallApi().getData3('allInterests');
    var content = response.body;
    final collection = json.decode(content);
    var data = Catagory.fromJson(collection);

    setState(() {
      catList = data;
      isLoading = false;
      // print("Listing");
      // print(catList);
    });
    // print("catList.interests.length");
    // print(catList.interests.length);
  }
  // Future<String> loadCategories() async {
  //   var response = await CallApi().getData3('allInterests');
  //   var content = response.body;
  //   final collection = json.decode(content);
  //   var data1 = Catagory.fromJson(collection);

  //   setState(() {
  //     data = data1.interests;
  //     isLoading = false;
  //   });

  //   print(content);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      child: isLoading
          ? Container(
              height: MediaQuery.of(context).size.height - 90,
              child: Center(child: CircularProgressIndicator()),
            )
          : catList == null
              ? Center(
                  child: Text(
                  "No Report has been done yet. Go to 'Start Reporting' page to report a problem",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ))
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 0, left: 20),
                          child: Text(
                            "Create Shop",
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
                                border: Border.all(
                                    width: 0.5, color: Colors.black)),
                          ),
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 12, left: 20),
                          child: Text(
                            "Insert your shop details",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          )),

                      ////// <<<<< Shop Name Field start >>>>> //////
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Shop name *",
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
                                        controller: shopNameController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Shop name *",
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
                      ////// <<<<< Shop Name Field end >>>>> //////

                      ////// <<<<< Shop Link Name Field >>>>> //////
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Shop link name *",
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
                                        controller: shopLinkController,
                                        keyboardType: TextInputType.text,
                                        onChanged: textChanged,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Shop link name *",
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
                      ////// <<<<< Shop Link Name Field end >>>>> //////
                      shopLink == null
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(bottom: 0, top: 0),
                              child: loading
                                  ? Container(
                                      margin: EdgeInsets.only(top: 5),
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ))
                                  : Text(
                                      shopLinkController.text != ""
                                          ? shopLink.message.contains(
                                                  'Link Name is unique')
                                              ? "ex: $textValue.worldtradebuddy.com "
                                              : "Link name already taken"
                                          : "Enter a valid link",
                                      style: TextStyle(
                                          color: shopLinkController.text != ""
                                              ? shopLink.message.contains(
                                                      'Link Name is unique')
                                                  ? Colors.green[400]
                                                  : Colors.red
                                              : Colors.red,
                                          fontSize: 12,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.normal),
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
                                "Shop location*",
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
                                        controller: shopLocationController,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Shop location *",
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
                                "Product type*",
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
                                          left: 20,
                                          right: 20,
                                          bottom: 5,
                                          top: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Row(
                                        children: <Widget>[
                                          DropdownButtonHideUnderline(
                                            child: Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: DropdownButton(
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black38,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w100),
                                                  value: productCategory,
                                                  items: _dropDownCategoryItems,
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      productCategory = value;
                                                      uType = productSeller;
                                                      //productBuyer = "";
                                                    });
                                                  },
                                                ),
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
                          ],
                        ),
                      ),
                      ////// <<<<< service or product Field end >>>>> /////

                      ////// <<<<< Cetagory Field start >>>>> /////
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Shop Category*",
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
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isOpen == false) {
                                          isOpen = true;
                                        } else {
                                          isOpen = false;
                                        }
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            cat == ""
                                                ? "Select category"
                                                : cat,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black54,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),

                                  ////// <<<<< Hidden Section start >>>>> //////
                                  isOpen == true
                                      ? Container(
                                          child: Column(
                                            children: <Widget>[
                                              ///// <<<<< Selected Interest end >>>>> //////
                                              selectedCategory.length != 0
                                                  ? Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5),
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5),
                                                          )),
                                                      margin: EdgeInsets.only(
                                                          top: 10, bottom: 15),
                                                      child: ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            selectedCategory
                                                                .length,
                                                        //separatorBuilder: (context, index) => Divider(),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        100],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "${selectedCat[index]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedCategory
                                                                              .removeAt(index);
                                                                          selectedCat =
                                                                              selectedCategory;
                                                                          selectedID =
                                                                              0;
                                                                          cat =
                                                                              "";
                                                                          // print(
                                                                          //     "selectedCat");
                                                                          // print(
                                                                          //     selectedCat);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child: Icon(
                                                                            Icons.clear),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Container(),

                                              ////// <<<<< Selected Interest end >>>>> //////

                                              ///// <<<<<  Interest start >>>>> //////
                                              Container(
                                                height: 180,
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: ListView.builder(
                                                  itemCount:
                                                      catList.interests.length,
                                                  //separatorBuilder: (context, index) => Divider(),
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      child: GestureDetector(
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: selectedCategory.contains(catList
                                                                        .interests[
                                                                            index]
                                                                        .name)
                                                                    ? back
                                                                    : Colors.grey[
                                                                        100],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5,
                                                                    top: 3),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 6,
                                                                    top: 6,
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Text(
                                                              "${catList.interests[index].name}",
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            )),
                                                        onTap: () {
                                                          setState(() {
                                                            if (selectedCategory
                                                                    .length ==
                                                                0) {
                                                              selectedCategory.add(
                                                                  "${catList.interests[index].name}");
                                                              selectedCat =
                                                                  selectedCategory
                                                                      .toList();
                                                              isOpen = false;
                                                              selectedID =
                                                                  catList
                                                                      .interests[
                                                                          index]
                                                                      .id;
                                                              cat = catList
                                                                  .interests[
                                                                      index]
                                                                  .name;
                                                            } else {
                                                              if (selectedCategory
                                                                  .contains(catList
                                                                      .interests[
                                                                          index]
                                                                      .name)) {
                                                                selectedCategory
                                                                    .removeAt(
                                                                        index);
                                                                selectedCat =
                                                                    selectedCategory;
                                                                selectedID = 0;
                                                                cat = "";
                                                              }
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )

                                              ///// <<<<<  Interest end >>>>> //////
                                            ],
                                          ),
                                        )
                                      : Container()

                                  ////// <<<<< Hidden Section end >>>>> //////
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      ////// <<<<< Category dropdown end >>>>> //////

////////
                      ////// <<<<< Tag Line Field >>>>> //////
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Shop Tag Line*",
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
                                        controller: shopTagLineController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Shop Tag Line*",
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
                      ////// <<<<< Tag Line Field end >>>>> //////

                      // ////// <<<<< Category dropdown >>>>> //////

                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   alignment: Alignment.centerLeft,
                      //   decoration: BoxDecoration(
                      //       color: Colors.white.withOpacity(0.7),
                      //       border: Border.all(color: Colors.grey, width: 0.5),
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(15))),
                      //   margin: EdgeInsets.only(
                      //       left: 20, right: 20, top: 15, bottom: 10),
                      //   padding: EdgeInsets.only(
                      //       left: 15, right: 15, top: 10, bottom: 10),
                      //   child: Column(
                      //     children: <Widget>[
                      //       GestureDetector(
                      //         onTap: () {
                      //           setState(() {
                      //             if (isOpen == false) {
                      //               isOpen = true;
                      //             } else {
                      //               isOpen = false;
                      //             }
                      //           });
                      //         },
                      //         child: Container(
                      //           color: Colors.white,
                      //           child: Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: <Widget>[
                      //               Text(
                      //                 "Select Interests",
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(
                      //                     color: Colors.black54,
                      //                     fontSize: 15,
                      //                     fontFamily: 'Oswald',
                      //                     fontWeight: FontWeight.w300),
                      //               ),
                      //               Container(
                      //                   padding: EdgeInsets.only(top: 5),
                      //                   child: Icon(
                      //                     Icons.keyboard_arrow_down,
                      //                     color: Colors.black54,
                      //                   ))
                      //             ],
                      //           ),
                      //         ),
                      //       ),

                      //       ////// <<<<< Hidden Section start >>>>> //////
                      //       isOpen == true
                      //           ? Container(
                      //               child: Column(
                      //                 children: <Widget>[
                      //                   ///// <<<<< Selected Interest end >>>>> //////
                      //                   selectedCategory.length != 0
                      //                       ? Container(
                      //                           height: 50,
                      //                           decoration: BoxDecoration(
                      //                               color: Colors.white,
                      //                               border: Border(
                      //                                 bottom: BorderSide(
                      //                                     color: Colors.black,
                      //                                     width: 0.5),
                      //                                 top: BorderSide(
                      //                                     color: Colors.black,
                      //                                     width: 0.5),
                      //                               )),
                      //                           margin: EdgeInsets.only(
                      //                               top: 10, bottom: 15),
                      //                           child: ListView.builder(
                      //                             physics:
                      //                                 BouncingScrollPhysics(),
                      //                             scrollDirection:
                      //                                 Axis.horizontal,
                      //                             itemCount:
                      //                                 selectedCategory.length,
                      //                             //separatorBuilder: (context, index) => Divider(),
                      //                             itemBuilder:
                      //                                 (BuildContext context,
                      //                                     int index) {
                      //                               return Container(
                      //                                 child: Container(
                      //                                     alignment:
                      //                                         Alignment.center,
                      //                                     decoration: BoxDecoration(
                      //                                         color: Colors
                      //                                             .grey[300],
                      //                                         borderRadius:
                      //                                             BorderRadius
                      //                                                 .circular(
                      //                                                     10)),
                      //                                     margin:
                      //                                         EdgeInsets.only(
                      //                                             left: 5,
                      //                                             right: 5,
                      //                                             top: 8,
                      //                                             bottom: 8),
                      //                                     padding:
                      //                                         EdgeInsets.only(
                      //                                             left: 10,
                      //                                             right: 10),
                      //                                     child: Row(
                      //                                       children: <Widget>[
                      //                                         Text(
                      //                                           "${selectedCat[index]}",
                      //                                           style: TextStyle(
                      //                                               fontSize:
                      //                                                   15),
                      //                                         ),
                      //                                         GestureDetector(
                      //                                           onTap: () {
                      //                                             setState(() {
                      //                                               selectedCategory
                      //                                                   .removeAt(
                      //                                                       index);
                      //                                               selectedCat =
                      //                                                   selectedCategory;
                      //                                               // print(
                      //                                               //     "selectedCat");
                      //                                               // print(
                      //                                               //     selectedCat);
                      //                                             });
                      //                                           },
                      //                                           child:
                      //                                               Container(
                      //                                             margin: EdgeInsets
                      //                                                 .only(
                      //                                                     left:
                      //                                                         5),
                      //                                             child: Icon(
                      //                                                 Icons
                      //                                                     .clear),
                      //                                           ),
                      //                                         )
                      //                                       ],
                      //                                     )),
                      //                               );
                      //                             },
                      //                           ),
                      //                         )
                      //                       : Container(),

                      //                   ////// <<<<< Selected Interest end >>>>> //////

                      //                   ///// <<<<<  Interest start >>>>> //////
                      //                   Container(
                      //                     height: 180,
                      //                     margin: EdgeInsets.only(top: 10),
                      //                     child: ListView.builder(
                      //                       itemCount: catList.interests.length,
                      //                       //separatorBuilder: (context, index) => Divider(),
                      //                       physics: BouncingScrollPhysics(),
                      //                       itemBuilder: (BuildContext context,
                      //                           int index) {
                      //                         return Container(
                      //                           child: GestureDetector(
                      //                             child: Container(
                      //                                 decoration: BoxDecoration(
                      //                                     color:
                      //                                         Colors.grey[300],
                      //                                     borderRadius:
                      //                                         BorderRadius
                      //                                             .circular(
                      //                                                 10)),
                      //                                 margin: EdgeInsets.only(
                      //                                     bottom: 5, top: 3),
                      //                                 padding: EdgeInsets.only(
                      //                                     bottom: 6,
                      //                                     top: 6,
                      //                                     left: 10,
                      //                                     right: 10),
                      //                                 child: Text(
                      //                                   "${catList.interests[index].name}",
                      //                                   style: TextStyle(
                      //                                       fontSize: 15),
                      //                                 )),
                      //                             onTap: () {
                      //                               setState(() {
                      //                                 print(
                      //                                     "selectedCategory.length");
                      //                                 print(selectedCategory
                      //                                     .length);
                      //                                 if (selectedCategory
                      //                                         .length <=
                      //                                     0) {
                      //                                   selectedCategory.add(
                      //                                       "${catList.interests[index].name}");
                      //                                   selectedCat =
                      //                                       selectedCategory
                      //                                           .toList();
                      //                                   isOpen = true;
                      //                                   // print("selectedCat");
                      //                                   // print(selectedCat);
                      //                                 }
                      //                               });
                      //                             },
                      //                           ),
                      //                         );
                      //                       },
                      //                     ),
                      //                   )

                      //                   ///// <<<<<  Interest end >>>>> //////
                      //                 ],
                      //               ),
                      //             )
                      //           : Container()

                      //       ////// <<<<< Hidden Section end >>>>> //////
                      //     ],
                      //   ),
                      // ),

                      // ////// <<<<< Category dropdown end >>>>> //////

                      ////// <<<<< Shop Description Field >>>>> //////
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Shop Description*",
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
                                        controller: shopDescriptionController,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Text(
                                    isSubmit ? "Please wait..." : "Create Shop",
                                    style: TextStyle(
                                      color: isSubmit
                                          ? Colors.black
                                          : Colors.white,
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

  Future textChanged(String val) async {
    setState(() {
      loading = true;
    });

    textValue = val;
    var linkesponse = await CallApi().getData('checkshopLink?link=$textValue');
    var link = linkesponse.body;
    final links = json.decode(link);
    var linkdata = LinkModel.fromJson(links);

    setState(() {
      shopLink = linkdata;
      //loading = false;
    });

    print(shopLink.message);

    timeHandle = Timer(Duration(seconds: 1), () {
      print("Calling now the API: $textValue");
      setState(() {
        loading = false;
      });
    });
  }

  void signUpButton() async {
    if (shopNameController.text.isEmpty) {
      return _showMsg("Shop name is empty");
    } else if (shopLinkController.text.isEmpty) {
      return _showMsg("Shop link name is empty");
    } else if (shopLocationController.text.isEmpty) {
      return _showMsg("Shop location is empty");
    } else if (shopDescriptionController.text.isEmpty) {
      return _showMsg("Description is empty");
    } else if (shopTagLineController.text.isEmpty) {
      return _showMsg("Shop Tag Line is empty");
    } else if (productCategory == "") {
      return _showMsg("Product Type is not selected");
    } else if (selectedID == 0) {
      return _showMsg("Category is not selected");
    }

    setState(() {
      isSubmit = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data2 = {
      'shopName': shopNameController.text,
      'shopcategory_id': selectedID,
      'shopType': productCategory.toLowerCase(),
      'shopTagLine': shopTagLineController.text,
      'shopLink': shopLinkController.text,
      'location': shopLocationController.text,
      'about': shopDescriptionController.text,
    };

    print(data2);

    //print(CallApi().postData(data2, 'createShop'));
    var res = await CallApi().postData1(data2, 'createShop');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      //localStorage.setString('user', json.encode(body['user']));
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['user']));
      print(body['user']);
      _showCompleteDialog();
    } else if (body['success'] == false) {
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
                          "Shop has been created successfully!",
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LoginPage()));
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
}
