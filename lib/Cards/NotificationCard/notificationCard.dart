import 'package:chatapp_new/Loader/NotificationLoader/notifyLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class NotificationCard extends StatefulWidget {
  @override
  NotificationCardState createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {
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
          return loading == false
              ? Container(
                  padding: EdgeInsets.only(top: 0, bottom: 0),
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
                  margin: EdgeInsets.only(
                      top: 2.5, bottom: 2.5, left: 10, right: 10),
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ////// <<<<< Picture >>>>> //////
                            Container(
                              margin: EdgeInsets.only(right: 0, top: 0),
                              padding: EdgeInsets.all(1.0),
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: index % 2 == 0
                                    ? AssetImage('assets/images/man.png')
                                    : AssetImage('assets/images/man2.jpg'),
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            ),

                            ////// <<<<< React Icon along with picture >>>>> //////
                            index % 2 == 0

                                ////// <<<<< Even index >>>>> //////
                                ? Container(
                                    margin: EdgeInsets.only(left: 33, top: 35),
                                    padding: EdgeInsets.all(5.0),
                                    decoration: new BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  )

                                ////// <<<<< Odd index >>>>> //////
                                : Container(
                                    margin: EdgeInsets.only(left: 33, top: 35),
                                    padding: EdgeInsets.all(4.0),
                                    decoration: new BoxDecoration(
                                      color: header,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.comment,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      ////// <<<<< Who reacted >>>>> //////
                                      TextSpan(
                                          text: index % 2 == 0
                                              ? "David Ryan"
                                              : "Jason Smith",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400,
                                          )),

                                      ////// <<<<< Reacted for what >>>>> //////
                                      TextSpan(
                                          text: index % 2 == 0
                                              ? " liked a photo that you're tagged in"
                                              : " reacted to your photo",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300,
                                          )),
                                    ],
                                  ),
                                ),

                                ////// <<<<< Time >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    index % 2 == 0 ? "Just now" : "1 day ago",
                                    style: TextStyle(
                                        color: index % 2 == 0
                                            ? header
                                            : Colors.black45,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< More Icon >>>>> //////
                        Container(
                            margin: EdgeInsets.only(left: 12, right: 0),
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.black45,
                            ))
                      ],
                    ),
                  ),
                )

              ////// <<<<< Loader >>>>> //////
              : NotifyLoaderCard();
        }, childCount: 2),
      ),
    );
  }
}
