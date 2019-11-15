
import 'package:chatapp_new/Forms/CreateShopForm/createShopForm.dart';
import 'package:chatapp_new/Forms/EditShopForm/editShopForm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class EditShopPage extends StatefulWidget {
  final shopId;

  EditShopPage(this.shopId);
  @override
  State<StatefulWidget> createState() {
    return EditShopPageState();
  }
}

class EditShopPageState extends State<EditShopPage> {
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
                EditShopForm(widget.shopId)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
