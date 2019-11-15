import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/FriendsCard/AllFriendCard/allFriendCard.dart';
import 'package:chatapp_new/Cards/FriendsCard/RequestCard/requestCard.dart';
import 'package:chatapp_new/Cards/FriendsCard/SuggestionCard/suggestionCard.dart';
import 'package:chatapp_new/JSON_Model/FriendReqModel/friendReqModel.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/AllFriendsPage/allFriendsPage.dart';
import 'package:chatapp_new/MainScreen/AllRequestPage/allRequestPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../../../main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendsPage extends StatefulWidget {
  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  //var reqList;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    loadRequests();
    super.initState();
  }

  Future loadRequests() async {
    setState(() {
      loading = true;
    });

    if (page2 == 0) {
      var reqresponse = await CallApi().getData2('get/friend');
      var reqcontent = reqresponse.body;
      final req = json.decode(reqcontent);
      var reqdata = FriendReqModel.fromJson(req);
      //print(reqdata);

      setState(() {
        reqList = reqdata;
        page2 = 1;
      });
    }

    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      loading = false;
    });
    // print("reqList.pending.length");
    // print(reqList.pending.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading == true
          ? FriendListLoader()
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              //header: WaterDropMaterialHeader(),
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  page2 = 0;
                });
                loadRequests();
                _refreshController.refreshCompleted();
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  ////// <<<<< Friend Request option >>>>> //////
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        ////// <<<<< Title >>>>> //////
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 15, left: 20),
                            child: Text(
                              "Requests",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),

                        ////// <<<<< Divider 1 >>>>> //////
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(top: 10, left: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                            ),
                          ],
                        ),

                        ////// <<<<< Request number >>>>> //////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    top: 12, left: 20, bottom: 10),
                                child: Text(
                                  reqList.pending.length == 0
                                      ? "No friend requests"
                                      : reqList.pending.length == 1
                                          ? "${reqList.pending.length} request"
                                          : "${reqList.pending.length} requests",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                )),

                            ////// <<<<< Show all option >>>>> //////
                            reqList.pending.length == 0
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllRequestPage()));
                                    },
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            top: 12, right: 20, bottom: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              "Show all",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: header,
                                                  fontSize: 13,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 3),
                                              child: Icon(Icons.chevron_right,
                                                  color: header, size: 17),
                                            )
                                          ],
                                        )),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Friend Request Card >>>>> //////
                  RequestCard(reqList.pending, 1),

                  ////// <<<<< Suggestion option >>>>> //////
                  // SliverToBoxAdapter(
                  //   child: Column(
                  //     children: <Widget>[
                  //       ////// <<<<< Divider 2 >>>>> //////
                  //       Container(
                  //           width: 50,
                  //           margin: EdgeInsets.only(
                  //               top: 20, left: 25, right: 25, bottom: 0),
                  //           decoration: BoxDecoration(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(15.0)),
                  //               color: header,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   blurRadius: 1.0,
                  //                   color: header,
                  //                   //offset: Offset(6.0, 7.0),
                  //                 ),
                  //               ],
                  //               border: Border.all(width: 0.5, color: header))),

                  //       ////// <<<<< Title >>>>> //////
                  //       Container(
                  //           alignment: Alignment.centerLeft,
                  //           margin: EdgeInsets.only(top: 20, left: 20),
                  //           child: Text(
                  //             "Suggestions",
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 18,
                  //                 fontFamily: 'Oswald',
                  //                 fontWeight: FontWeight.normal),
                  //           )),

                  //       ////// <<<<< Divider 3 >>>>> //////
                  //       Row(
                  //         children: <Widget>[
                  //           Container(
                  //             width: 30,
                  //             margin: EdgeInsets.only(top: 10, left: 20),
                  //             decoration: BoxDecoration(
                  //                 borderRadius:
                  //                     BorderRadius.all(Radius.circular(15.0)),
                  //                 color: Colors.black,
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     blurRadius: 3.0,
                  //                     color: Colors.black,
                  //                     //offset: Offset(6.0, 7.0),
                  //                   ),
                  //                 ],
                  //                 border: Border.all(
                  //                     width: 0.5, color: Colors.black)),
                  //           ),
                  //         ],
                  //       ),

                  //       ////// <<<<< Suggestion number >>>>> //////
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: <Widget>[
                  //           Container(
                  //               alignment: Alignment.centerLeft,
                  //               margin: EdgeInsets.only(
                  //                   top: 12, left: 20, bottom: 10),
                  //               child: Text(
                  //                 "38 suggestions",
                  //                 textAlign: TextAlign.start,
                  //                 style: TextStyle(
                  //                     color: Colors.black54,
                  //                     fontSize: 13,
                  //                     fontFamily: 'Oswald',
                  //                     fontWeight: FontWeight.w400),
                  //               )),

                  //           ////// <<<<< Show all option >>>>> //////
                  //           Container(
                  //               alignment: Alignment.centerLeft,
                  //               margin: EdgeInsets.only(
                  //                   top: 12, right: 20, bottom: 10),
                  //               child: Row(
                  //                 children: <Widget>[
                  //                   Text(
                  //                     "Show all",
                  //                     textAlign: TextAlign.start,
                  //                     style: TextStyle(
                  //                         color: header,
                  //                         fontSize: 13,
                  //                         fontFamily: 'Oswald',
                  //                         fontWeight: FontWeight.w400),
                  //                   ),
                  //                   Container(
                  //                     margin: EdgeInsets.only(top: 3),
                  //                     child: Icon(Icons.chevron_right,
                  //                         color: header, size: 17),
                  //                   )
                  //                 ],
                  //               )),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  ////// <<<<< Suggestion Card >>>>> //////
                  //SuggestionCard(),

                  ////// <<<<< All Friend Option >>>>> //////
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        ////// <<<<< Divider 4 >>>>> //////
                        Container(
                            width: 50,
                            margin: EdgeInsets.only(
                                top: 20, left: 25, right: 25, bottom: 0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: header,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 1.0,
                                    color: header,
                                    //offset: Offset(6.0, 7.0),
                                  ),
                                ],
                                border: Border.all(width: 0.5, color: header))),

                        ////// <<<<< Title >>>>> //////
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Friends",
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
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
                                  margin: EdgeInsets.only(
                                      top: 12, left: 20, bottom: 10),
                                  child: Text(
                                    reqList.friend.length == 0
                                        ? "No friends"
                                        : reqList.friend.length == 1
                                            ? "${reqList.friend.length} friend"
                                            : "${reqList.friend.length} friends",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  )),

                              ////// <<<<< Show all option >>>>> //////
                              reqList.friend.length == 0
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllFriendsPage()));
                                      },
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 12, right: 20, bottom: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Show all",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: header,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 3),
                                                child: Icon(Icons.chevron_right,
                                                    color: header, size: 17),
                                              )
                                            ],
                                          )),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< All Friend Card >>>>> //////
                  AllFriendsCard(reqList.friend, 2),
                ],
              ),
            ),
    );
  }
}
