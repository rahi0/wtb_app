import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class PostLoaderCard extends StatefulWidget {
  @override
  LoaderCardState createState() => LoaderCardState();
}

class LoaderCardState extends State<PostLoaderCard> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ////// <<<<< Status/Photo post >>>>> //////
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.only(top: 0, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Row(
              children: <Widget>[
                ////// <<<<< Profile >>>>> //////
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 0, left: 15),
                        padding: EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          radius: 21.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/man.png'),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 45),
                        padding: EdgeInsets.all(1.0),
                        child: CircleAvatar(
                          radius: 5.0,
                          backgroundColor: Colors.greenAccent,
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                ////// <<<<< Status/Photo field >>>>> //////
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(
                                    color: Colors.grey[200], width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: TextField(
                              enabled: false,
                              //controller: phoneController,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Oswald',
                              ),
                              decoration: InputDecoration(
                                hintText: "What's in your mind?",
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                                //labelStyle: TextStyle(color: Colors.white70),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 1, 20.0, 1),
                                border: InputBorder.none,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                ////// <<<<< Photo post >>>>> //////
                Container(
                  decoration: BoxDecoration(
                      color: back,
                      border: Border.all(color: Colors.grey[100], width: 0.5),
                      borderRadius: BorderRadius.circular(25)),
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(11),
                  child: Icon(
                    Icons.photo,
                    color: header,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),

          ////// <<<<< Divider 1 >>>>> //////
          Container(
              width: 50,
              margin:
                  EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: header,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.0,
                      color: header,
                      //offset: Offset(6.0, 7.0),
                    ),
                  ],
                  border: Border.all(width: 0.5, color: header))),

          PostLoader(),
          PostLoader(),
          PostLoader(),
        ],
      ),
    );
  }
}

class PostLoader extends StatefulWidget {
  @override
  _PostLoaderState createState() => _PostLoaderState();
}

class _PostLoaderState extends State<PostLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 1.0,
            color: Colors.black38,
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ////// <<<<< Picture >>>>> //////
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(1.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[400],
                        highlightColor: Colors.grey[200],
                        child: CircleAvatar(
                          radius: 20.0,
                          //backgroundColor: Colors.white,
                        ),
                      ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ////// <<<<< User Name >>>>> //////
                        Shimmer.fromColors(
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.grey[200],
                          child: Container(
                            width: 100,
                            height: 22,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        ),

                        ////// <<<<< Time >>>>> //////
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[200],
                            child: Container(
                              width: 50,
                              height: 12,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          ////// <<<<< Status >>>>> //////
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ////// <<<<< Line 1 >>>>> //////
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  )),

              ////// <<<<< Line 2 >>>>> //////
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 5),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 10,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
