import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../../main.dart';

class AllFriendsCard extends StatefulWidget {
  final friend;
  final no;
  AllFriendsCard(this.friend, this.no);
  @override
  AllFriendsCardState createState() => AllFriendsCardState();
}

class AllFriendsCardState extends State<AllFriendsCard> {
  SharedPreferences sharedPreferences;
  String theme = "", pic = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

  @override
  void initState() {
    for (int i = 0; i < widget.friend.length; i++) {
      pic = widget.friend[i].profilePic;
      if (pic.contains("uploads")) {
        pic = "http://10.0.2.2:3010" + pic;
      }
      //print(pic);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverPadding(
        padding: EdgeInsets.only(bottom: 25),
        sliver: SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendsProfilePage(widget.friend[index].userName, widget.no)));
              },

              ////// <<<<< Main Data >>>>> //////
              child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 10
                          )
                        ]
                        //border: Border.all(width: 1.0, color: Colors.grey[300]),
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
                                  Stack(
                                    children: <Widget>[
                                      ////// <<<<< Picture >>>>> //////
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(1.0),
                                        child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              widget.friend[index].profilePic ==
                                                          "" ||
                                                      widget.friend[index]
                                                              .profilePic ==
                                                          null
                                                  ? AssetImage(
                                                      'assets/images/man.png')
                                                  : NetworkImage(pic),
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                      ),

                                      ////// <<<<< Online Green Dot >>>>> //////
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        padding: EdgeInsets.all(1.0),
                                        child: CircleAvatar(
                                          radius: 5.0,
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors
                                              .greenAccent, // border color
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),

                                  ////// <<<<< User Name >>>>> //////
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${widget.friend[index].firstName} ${widget.friend[index].lastName}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w400),
                                        ),

                                        ////// <<<<< Mutual Friends >>>>> //////
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 3),
                                        //   child: Text("34 mutual friends",
                                        //     maxLines: 1,
                                        //     overflow: TextOverflow.ellipsis,
                                        //     style: TextStyle(
                                        //         fontFamily: 'Oswald',
                                        //         fontWeight: FontWeight.w400,
                                        //         fontSize: 11,
                                        //         color: Colors.black54),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ////// <<<<< Message Button >>>>> //////
                          // Container(
                          //     margin: EdgeInsets.only(right: 15),
                          //     padding: EdgeInsets.only(
                          //         left: 10, right: 10, top: 5, bottom: 5),
                          //     decoration: BoxDecoration(
                          //         color: header.withOpacity(0.7),
                          //         borderRadius: BorderRadius.circular(15),
                          //         border:
                          //             Border.all(color: header, width: 0.5)),
                          //     child: Text("Message",
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //             fontFamily: 'Oswald',
                          //             fontWeight: FontWeight.w400,
                          //             color: Colors.white,
                          //             fontSize: 12))),
                        ],
                      ),
                    )

                  ////// <<<<< Loader >>>>> //////
                  ,
            );
          }, childCount: widget.friend.length),
        ),
      ),
    );
  }
}
