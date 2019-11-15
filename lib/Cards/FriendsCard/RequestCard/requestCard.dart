import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../../main.dart';

class RequestCard extends StatefulWidget {
  final pending;
  final no;
  RequestCard(this.pending, this.no);

  @override
  RequestCardState createState() => RequestCardState();
}

class RequestCardState extends State<RequestCard> {
  SharedPreferences sharedPreferences;
  String theme = "", pic = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

  @override
  void initState() {
    for (int i = 0; i < widget.pending.length; i++) {
      pic = widget.pending[i].follower.profilePic;
      if (pic.contains("uploads")) {
        pic = "http://10.0.2.2:3010" + pic;
      }
      //print(pic);
    }
    //print(pic);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendsProfilePage(
                          widget.pending[index].follower.userName, widget.no)));
            },
            ////// <<<<< Main Data >>>>> //////
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 10)
                  ]),
              margin:
                  EdgeInsets.only(top: 2.5, bottom: 2.5, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
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
                              backgroundImage:
                                  widget.pending[index].follower.profilePic ==
                                              "" ||
                                          widget.pending[index].follower
                                                  .profilePic ==
                                              null
                                      ? AssetImage('assets/images/man.png')
                                      : NetworkImage(pic),
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.grey[300], // border color
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ////// <<<<< User Name >>>>> //////
                                Text(
                                  "${widget.pending[index].follower.firstName} ${widget.pending[index].follower.lastName}",
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
                                    "${widget.pending[index].follower.jobTitle}",
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

                  ////// <<<<< Req accept/cancel option >>>>> //////
                  Container(
                    child: Row(
                      children: <Widget>[
                        ////// <<<<< Req accept >>>>> //////
                        GestureDetector(
                          onTap: () {
                            acceptReq(widget.pending[index].id);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: header,
                                  borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 15,
                              )),
                        ),

                        ////// <<<<< Req cancel >>>>> //////
                        GestureDetector(
                          onTap: () {
                            deleteReq(widget.pending[index].id);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.close,
                                color: Colors.black54,
                                size: 15,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )

            ////// <<<<< Loader >>>>> //////
            ,
          );
        }, childCount: widget.pending.length),
      ),
    );
  }

  Future acceptReq(id) async {
    var data = {
      'status': 2,
      'id': id,
    };

    print(data);

    var res = await CallApi().postData1(data, 'accept/friend');
    var body = json.decode(res.body);

    print(body);

    if (body == 1) {
      setState(() {
        page2 = 0;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage(1)));
    }
  }

  Future deleteReq(id) async {
    var data = {
      'op': 1,
      'id': id,
    };

    print(data);

    var res = await CallApi().postData1(data, 'remove/friend');
    var body = json.decode(res.body);

    print(body);

    if (body == 1) {
      setState(() {
        page2 = 0;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage(1)));
    }
  }
}
