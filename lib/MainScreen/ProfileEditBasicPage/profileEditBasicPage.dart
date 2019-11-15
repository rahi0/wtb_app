import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/Forms/ProfileBasicEditForm/profileBasicEditForm.dart';
import 'package:chatapp_new/Forms/RegisterForm/registerForm.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ProfileBasisEditPage extends StatefulWidget {
  final userData;

  ProfileBasisEditPage(this.userData);
  @override
  State<StatefulWidget> createState() {
    return ProfileBasisEditPageState();
  }
}

class ProfileBasisEditPageState extends State<ProfileBasisEditPage> {
  int count = 0, tnc = 0;
  SharedPreferences sharedPreferences;
  String theme = "";

  @override
  void initState() {
    sharedPrefcheck();
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  //color: header,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 5),
                          child: BackButton(color: Colors.grey)),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       bottom: 10, left: 10, top: 20, right: 20),
                      //   width: 180,
                      //   height: 180,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(15),
                      //     image: DecorationImage(
                      //       image: AssetImage("assets/images/login2.png"),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      //   child: null,
                      // ),
                    ],
                  ),
                ),
                BasicEditForm(widget.userData)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
