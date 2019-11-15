import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/JSON_Model/check.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class BasicEditForm extends StatefulWidget {
  final userData;

  BasicEditForm(this.userData);
  @override
  State<StatefulWidget> createState() {
    return BasicEditFormState();
  }
}

class BasicEditFormState extends State<BasicEditForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

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

  int count = 0, gen = 1, gen1 = 0, selectType = 0, userType = 0, userType1 = 0;
  SharedPreferences sharedPreferences;
  String theme = "", gender = "female", user = "";
  String typeService = "",
      productBuyer = "",
      productSeller = "",
      productCategory = "",
      typeCategory = "",
      uType = "", user_id = "";

  List<String> selectedCategory = [];
  var selectedCat;

  List type = ["Seller", "Buyer"];
  List sellerOpt = [
    "Product Seller",
    "Freelancer",
    "Trade Financier",
    "Inspection & Logistics Provider",
    "Drop Shipper",
    "Fulfilment Service Provider",
    "General Business Worker"
  ];
  List buyerOpt = ["Business Buyer"];
  //List categories;
  var catList, conList;
  bool isLoading = true;
  bool isSubmit = false;
  bool isOpen = false;

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownBuyerItems,
      _dropDownSellerItems;

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
    for (String sellersOpt in sellerOpt) {
      items.add(new DropdownMenuItem(
          value: sellersOpt,
          child: new Text(
            sellersOpt,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownSizeItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String buyersOpt in buyerOpt) {
      items.add(new DropdownMenuItem(
          value: buyersOpt,
          child: new Text(
            buyersOpt,
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
    _dropDowntypeService = getDropDowntypeService();
    typeService = _dropDowntypeService[0].value;

    _dropDownBuyerItems = getDropDownSizeItems();
    productBuyer = _dropDownBuyerItems[0].value;

    _dropDownSellerItems = getDropDownColorItems();
    productSeller = _dropDownSellerItems[0].value;

    loadConnection();

    firstNameController.text = "${widget.userData['firstName']}";
    lastNameController.text = "${widget.userData['lastName']}";
    jobTitleController.text = "${widget.userData['jobTitle']}";
    gender = "${widget.userData['gender']}";
    user = "${widget.userData['userType']}";
    user_id = "${widget.userData['id']}";
    String userDropdown = "${widget.userData['dayJob']}";

    if (user == "Seller") {
      for (int i = 0; i < sellerOpt.length; i++) {
        //print(sellerOpt[i]);
        if (sellerOpt[i] == userDropdown) {
          setState(() {
            productSeller = sellerOpt[i];
            uType = productSeller;
          });
        }
      }
    }

    super.initState();
  }

  Future loadConnection() async {
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=connection');
    var content = response.body;
    final collection = json.decode(content);
    var data = Connection.fromJson(collection);

    setState(() {
      conList = data;
      countryController.text = "${conList.user.country}";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      child: isLoading
          ? Container(
            height: MediaQuery.of(context).size.height - 90,
            child: Center(
            child: CircularProgressIndicator()
            ),
          )
          : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 0, left: 20),
                          child: Text(
                            "Edit Profile",
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
                            "Update your basic profile information",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          )),

                      ////// <<<<< First Name Field start >>>>> //////
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: TextField(
                                  controller: firstNameController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "First name *",
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
                      ////// <<<<< First Name Field end >>>>> //////

                      ////// <<<<< Last Name Field >>>>> //////
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: TextField(
                                  controller: lastNameController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Last name *",
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
                      ////// <<<<< Last Name Field end >>>>> //////

                      ////// <<<<< Profile Headline Field >>>>> //////
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: TextField(
                                  controller: jobTitleController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        "Profile Headline e. g. App Developer*",
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
                      ////// <<<<< Profile Headline Field end >>>>> //////
                      

                      ///////// <<<<< Country Field >>>>> //////
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: TextField(
                                  controller: countryController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        "Country*",
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
                      ////// <<<<< Country end >>>>> //////

                      ////// <<<<< Gender Selection >>>>> //////
                      Container(
                        margin: EdgeInsets.only(left: 25, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Gender * : ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w300),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  gender = "female";
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: gender == "female"
                                              ? header
                                              : Colors.white,
                                          border: Border.all(
                                              color: gender == "female"
                                                  ? header
                                                  : Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Icon(
                                        Icons.done,
                                        size: 12,
                                        color: gender == "female"
                                            ? Colors.white
                                            : Colors.black38,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: 20, left: 5, top: 0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Female",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  gender = "male";
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: gender == "male"
                                              ? header
                                              : Colors.white,
                                          border: Border.all(
                                              color: gender == "male"
                                                  ? header
                                                  : Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Icon(
                                        Icons.done,
                                        size: 12,
                                        color: gender == "male"
                                            ? Colors.white
                                            : Colors.black38,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: 20, left: 5, top: 0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Male",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ////// <<<<< Buyer/Seller Selection >>>>> //////
                      Container(
                        margin: EdgeInsets.only(left: 25, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "User Type * : ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w300),
                            ),

                            ////// <<<<< Seller Section >>>>> //////
                            user == "Buyer"
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        user = "Seller";
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 0),
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: user == "Seller"
                                                    ? header
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: user == "Seller"
                                                        ? header
                                                        : Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.done,
                                              size: 12,
                                              color: user == "Seller"
                                                  ? Colors.white
                                                  : Colors.black38,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right: 20, left: 5, top: 0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Seller",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),

                            ////// <<<<< Buyer Section >>>>> //////
                            user == "Seller"
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        user = "Buyer";
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(top: 0),
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: user == "Buyer"
                                                    ? header
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: user == "Buyer"
                                                        ? header
                                                        : Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.done,
                                              size: 12,
                                              color: user == "Buyer"
                                                  ? Colors.white
                                                  : Colors.black38,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right: 20, left: 5, top: 0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Buyer",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      ////// <<<<< Buyer Dropdown >>>>> //////
                      user == "Buyer"
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              margin:
                                  EdgeInsets.only(left: 25, right: 25, top: 10),
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: Row(
                                            children: <Widget>[
                                              DropdownButtonHideUnderline(
                                                child: Expanded(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: DropdownButton(
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w100),
                                                      value: productBuyer,
                                                      items:
                                                          _dropDownBuyerItems,
                                                      onChanged:
                                                          (String value) {
                                                        setState(() {
                                                          productBuyer = value;
                                                          uType = productBuyer;
                                                          //productSeller = "";
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
                                ],
                              ),
                            )

                          ////// <<<<< Seller Dropdown >>>>> //////
                          : user == "Seller"
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        margin: EdgeInsets.only(
                                            top: 10, right: 25, left: 25),
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
                                                        color: Colors.black87,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w100),
                                                    value: productSeller,
                                                    items: _dropDownSellerItems,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        productSeller = value;
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
                                )
                              : Container(),

                      ////// <<<<< Sign up button >>>>> //////
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
                                    isSubmit
                                        ? "Please wait..."
                                        : "Edit Information",
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

  void signUpButton() async {
    if (firstNameController.text.isEmpty) {
      return _showMsg("First name is empty");
    } else if (lastNameController.text.isEmpty) {
      return _showMsg("Last name is empty");
    } else if (jobTitleController.text.isEmpty) {
      return _showMsg("Profile Headline is empty");
    } else if (countryController.text.isEmpty) {
      return _showMsg("Country is empty");
    } else if (uType == "") {
      return _showMsg("Please select an user category");
    }

    setState(() {
      isSubmit = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data = {
      'id': user_id,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'jobTitle': jobTitleController.text,
      'gender': gender,
      'country': countryController.text,
      'dayJob': uType,
    };

    print(data);

    var res = await CallApi().postData1(data, 'update-user-basicinfo');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['user']));

      _showCompleteDialog();
    } else if (body['success'] == false) {
      _showMsg(body['message']);
    }

    setState(() {
      isSubmit = false;
    });
  }

  Future<Null> _showCompleteDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
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
                          "Basic Information has been edited successfully.",
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
                                        builder: (context) => MyHomePage(3)));
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
