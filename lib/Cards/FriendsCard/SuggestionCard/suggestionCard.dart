import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../../main.dart';

class SuggestionCard extends StatefulWidget {
  @override
  SuggestionCardState createState() => SuggestionCardState();
}

class SuggestionCardState extends State<SuggestionCard> {
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
      child: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => FriendsProfilePage()));
            },

            ////// <<<<< Main Data >>>>> //////
            child: loading == false
                ? Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1.0, color: Colors.grey[300]),
                    ),
                    margin: EdgeInsets.only(
                        top: 2.5, bottom: 2.5, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ////// <<<<< Profile picture >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(1.0),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: index == 0
                                        ? AssetImage('assets/images/man.png')
                                        : index == 1
                                            ? AssetImage(
                                                'assets/images/man2.jpg')
                                            : index == 2
                                                ? AssetImage(
                                                    'assets/images/man.png')
                                                : index == 3
                                                    ? AssetImage(
                                                        'assets/images/man2.jpg')
                                                    : AssetImage(
                                                        'assets/images/man.png'),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ////// <<<<< User Name >>>>> //////
                                      Text(
                                        index == 0
                                            ? "John Smith"
                                            : index == 1
                                                ? "David Ryan"
                                                : index == 2
                                                    ? "Simon Wright"
                                                    : index == 3
                                                        ? "Mike Johnson"
                                                        : "Daniel Smith",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400),
                                      ),

                                      ////// <<<<< Mutual Friends >>>>> //////
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        child: Text(
                                          index == 0
                                              ? "6 mutual friends"
                                              : index == 1
                                                  ? "16 mutual friends"
                                                  : index == 2
                                                      ? "26 mutual friends"
                                                      : index == 3
                                                          ? "32 mutual friends"
                                                          : "34 mutual friends",
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
                          ),
                        ),

                        ////// <<<<< Add Options >>>>> //////
                        Row(
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )

                ////// <<<<< Loader >>>>> //////
                : LoaderCard(),
          );
        }, childCount: 5),
      ),
    );
  }
}
