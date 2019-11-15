import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/Forms/LoginForm/ForgotPassForm/forgotPassForm.dart';
import 'package:chatapp_new/MainScreen/LoginPage/VerifyPage/verifyPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ForgotPassPageState();
  }
}

class ForgotPassPageState extends State<ForgotPassPage> {
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
      //backgroundColor: back_new,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
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
                        ],
                      ),
                    ),
                    ForgotPassForm()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
