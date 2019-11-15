import 'package:chatapp_new/Loader/GroupLoader/groupLoader.dart';
import 'package:chatapp_new/MainScreen/GroupDetailsPage/groupDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class GroupCard extends StatefulWidget {
  @override
  GroupCardState createState() => GroupCardState();
}

class GroupCardState extends State<GroupCard> {
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
      child: SliverPadding(
        padding: EdgeInsets.only(left: 10, right: 10),

        ////// <<<<< Gridview >>>>> //////
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 190.0,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
            childAspectRatio: 0.85,
          ),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return loading == false
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupDetailsPage()));
                    },
                    child: Container(
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
                      margin:
                          EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            padding: EdgeInsets.only(right: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ////// <<<<< Profile Picture >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  padding: EdgeInsets.all(1.0),
                                  child: CircleAvatar(
                                    radius: 27.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: index == 0
                                        ? AssetImage('assets/images/f4.jpg')
                                        : index == 1
                                            ? AssetImage('assets/images/f.jpg')
                                            : index == 2
                                                ? AssetImage(
                                                    'assets/images/f6.jpg')
                                                : index == 3
                                                    ? AssetImage(
                                                        'assets/images/f5.jpg')
                                                    : AssetImage(
                                                        'assets/images/f2.jpg'),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                ////// <<<<< Group Name >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    index == 0
                                        ? "Group 1"
                                        : index == 1
                                            ? "Group 2"
                                            : index == 2
                                                ? "Group 3"
                                                : index == 3
                                                    ? "Group 4"
                                                    : "Group 5",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),

                                ////// <<<<< Number of members >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Text(
                                    index == 0
                                        ? "6 members"
                                        : index == 1
                                            ? "16 members"
                                            : index == 2
                                                ? "26 members"
                                                : index == 3
                                                    ? "32 members"
                                                    : "34 members",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                        color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )) ////// <<<<< Loader >>>>> //////
                : GroupLoaderCard();
          }, childCount: 5),
        ),
      ),
    );
  }
}
