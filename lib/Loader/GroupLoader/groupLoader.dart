import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';


class GroupLoaderCard extends StatefulWidget {
  @override
  GroupLoaderCardState createState() => GroupLoaderCardState();
}

class GroupLoaderCardState extends State<GroupLoaderCard> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

  @override
  void initState() {
    sharedPrefcheck();
    timerCheck();
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  void timerCheck() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              loading = false;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
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
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 0),
            padding: EdgeInsets.only(right: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                ////// <<<<< Picture >>>>> //////
                Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.all(1.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[200],
                    child: CircleAvatar(
                      radius: 27.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      ////// <<<<< Name >>>>> //////
                      Shimmer.fromColors(
                        baseColor: Colors.grey[400],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: 80,
                          height: 22,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      ////// <<<<< Member >>>>> //////
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
