import 'dart:convert';

import 'package:chatapp_new/Cards/MoreOptionsCard/moreCard.dart';
import 'package:chatapp_new/Cards/ProfileCard/profileCard.dart';
import 'package:chatapp_new/Forms/CreateShopForm/createShopForm.dart';
import 'package:chatapp_new/MainScreen/CreateShop_Page/create_shopPage.dart';
import 'package:chatapp_new/MainScreen/GroupPage/groupPage.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:chatapp_new/MainScreen/ProfileEditBasicPage/profileEditBasicPage.dart';
import 'package:chatapp_new/MainScreen/ProfileEditInterestPage/profileEditInterestPage.dart';
import 'package:chatapp_new/MainScreen/SettingsPage/settingsPage.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  var userData;
  bool _isLoaded = false;
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      //_isLoaded = true;
    });

    //print("${userData['shop_id']}");
  }

  Container profileContainer(Icon icon, String text) {
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(width: 0.8, color: Colors.grey[300]),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[300],
            //offset: Offset(3.0, 4.0),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 0, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //color: Colors.red,
            margin: EdgeInsets.only(left: 20, right: 20, top: 0),
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10), child: icon),
                Container(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.chevron_right,
                color: Colors.black45,
                size: 22,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: userData == null
          ? CircularProgressIndicator()
          : CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ////// <<<<< Profile Card >>>>> //////
                      ProfileCard(userData),

                      ////// <<<<< Shop Cards >>>>> //////
                      userData['shop_id'] == 0 ||
                              userData['shop_id'] == null ||
                              userData['shop_id'] == "" ||
                              userData['shop_id'] == "0"
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopPage(userData['shop_id'])));
                              },
                              child: profileContainer(
                                  Icon(
                                    Icons.shop,
                                    color: Colors.black45,
                                    size: 20,
                                  ),
                                  "Shop"),
                            ),

                      ////// <<<<< Create Shop Cards >>>>> //////

                      userData['shop_id'] == 0 ||
                              userData['shop_id'] == null ||
                              userData['shop_id'] == "" ||
                              userData['shop_id'] == "0"
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateShopPage()));
                              },
                              child: profileContainer(
                                  Icon(
                                    Icons.shop_two,
                                    color: Colors.black45,
                                    size: 20,
                                  ),
                                  "Create Shop"),
                            )
                          : Container(),

                      ////// <<<<< Group Cards >>>>> //////
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => GroupPage()));
                      //   },
                      //   child: profileContainer(
                      //       Icon(
                      //         Icons.group,
                      //         color: Colors.black45,
                      //         size: 20,
                      //       ),
                      //       "Group"),
                      // ),

                      ////// <<<<< Basic Information Edit Cards >>>>> //////
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileBasisEditPage(userData)));
                        },
                        child: profileContainer(
                            Icon(
                              Icons.account_circle,
                              color: Colors.black45,
                              size: 20,
                            ),
                            "Basic Information Edit"),
                      ),

                      ////// <<<<< Interests Edit Cards >>>>> //////
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileInterestEditPage(userData)));
                        },
                        child: profileContainer(
                            Icon(
                              Icons.label_important,
                              color: Colors.black45,
                              size: 20,
                            ),
                            "Interests Edit"),
                      ),

                      ////// <<<<< Settings Cards >>>>> //////
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()));
                        },
                        child: profileContainer(
                            Icon(
                              Icons.settings,
                              color: Colors.black45,
                              size: 20,
                            ),
                            "Settings"),
                      ),

                      ////// <<<<< Logout Cards >>>>> //////
                      GestureDetector(
                        onTap: () {
                          _showLogoutDialog();
                        },
                        child: profileContainer(
                            Icon(
                              Icons.power_settings_new,
                              color: Colors.black45,
                              size: 20,
                            ),
                            "Logout"),
                      ),
                    ],
                  ),
                ),
              )
            ]),
    );
  }

  Future<Null> _showLogoutDialog() async {
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
                        margin: EdgeInsets.only(top: 0),
                        child: Text(
                          "Do you want to logout?",
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
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 5, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: logout,
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
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

  Future logout() async {
    Navigator.of(context).pop();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    localStorage.remove('user');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    page1 = 0;
    page2 = 0;
    page3 = 0;
  }
}
