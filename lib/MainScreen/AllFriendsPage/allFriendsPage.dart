import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/FriendsCard/AllFriendCard/allFriendCard.dart';
import 'package:chatapp_new/JSON_Model/FriendModel/friendModel.dart';
import 'package:chatapp_new/JSON_Model/FriendReqModel/friendReqModel.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class AllFriendsPage extends StatefulWidget {
  @override
  _AllFriendsPageState createState() => _AllFriendsPageState();
}

class _AllFriendsPageState extends State<AllFriendsPage> {
  var reqList, reqData, req;
  List frndList = [];
  bool loading = false;

  @override
  void initState() {
    loadRequests();
    super.initState();
  }

  Future loadRequests() async {
    setState(() {
      loading = true;
    });

    var reqresponse = await CallApi().getData2('friendlists/all');
    var reqcontent = reqresponse.body;
    req = json.decode(reqcontent);
    print(req);
    //print(req.length);
    // for (int i = 0; i < req.length; i++) {
    //   reqData = Friend.fromJson(req[i]);
    //   //print(reqData.id);
    // }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Friend list",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          ////// <<<<< All Friend Option >>>>> //////
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                ////// <<<<< Title >>>>> //////
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      "All friends",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.normal),
                    )),

                ////// <<<<< Divider 5 >>>>> //////
                Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      margin: EdgeInsets.only(top: 10, left: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.black,
                              //offset: Offset(6.0, 7.0),
                            ),
                          ],
                          border: Border.all(width: 0.5, color: Colors.black)),
                    ),
                  ],
                ),

                ////// <<<<< Friend Number >>>>> //////
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          margin:
                              EdgeInsets.only(top: 12, left: 20, bottom: 10),
                          child: Text(
                            req.length == 0
                                ? "No friends"
                                : req.length == 1
                                    ? "${req.length} friend"
                                    : "${req.length} friends",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w400),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ////// <<<<< All Friend Card >>>>> //////
          FriendsCard(req),
        ],
      ),
    );
  }
}


class FriendsCard extends StatefulWidget {
  final req;
  FriendsCard(this.req);
  @override
  FriendsCardState createState() => FriendsCardState();
}

class FriendsCardState extends State<FriendsCard> {
  String theme = "", pic = "";
  bool loading = true;

  @override
  void initState() {
    //print(widget.req.length);
    for (int i = 0; i < widget.req.length; i++) {
      print(widget.req[i]);
      pic = widget.req[i]['profilePic'];
      if (pic.contains("uploads")) {
        pic = "http://10.0.2.2:3010" + pic;
      }
      print(pic);
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
                        builder: (context) => FriendsProfilePage(widget.req[index]['userName'], 2)));
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
                                              widget.req[index]['profilePic'] ==
                                                          "" ||
                                                      widget.req[index]['profilePic'] ==
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
                                          "${widget.req[index]['firstName']} ${widget.req[index]['lastName']}",
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
                          Container(
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  color: header.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: header, width: 0.5)),
                              child: Text("Message",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 12))),
                        ],
                      ),
                    )

                  ////// <<<<< Loader >>>>> //////
                  ,
            );
          }, childCount: widget.req.length),
        ),
      ),
    );
  }
}