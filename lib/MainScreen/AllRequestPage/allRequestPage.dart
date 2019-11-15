import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/FriendsCard/AllFriendCard/allFriendCard.dart';
import 'package:chatapp_new/Cards/FriendsCard/RequestCard/requestCard.dart';
import 'package:chatapp_new/Cards/FriendsCard/SuggestionCard/suggestionCard.dart';
import 'package:chatapp_new/JSON_Model/AllRequestModel/allRequestModel.dart';
import 'package:chatapp_new/JSON_Model/FriendReqModel/friendReqModel.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/AllFriendsPage/allFriendsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../main.dart';

class AllRequestPage extends StatefulWidget {
  @override
  AllRequestPageState createState() => AllRequestPageState();
}

class AllRequestPageState extends State<AllRequestPage> {
  SharedPreferences sharedPreferences;
  String theme = "";
  bool loading = true;
  var allreqList;
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

    var reqresponse = await CallApi().getData2('get/pendingFriend');
    var reqcontent = reqresponse.body;
    final req = json.decode(reqcontent);
    var reqdata = FriendReqModel.fromJson(req);
    //print(reqdata);

    setState(() {
      allreqList = reqdata;
    });
    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      loading = false;
    });
    print("allreqList.pending.length");
    print(allreqList.pending.length);
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
                        "Friend requests",
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
      body: loading == true
          ? FriendListLoader()
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              //header: WaterDropMaterialHeader(),
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
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
                                  allreqList.pending.length == 0
                                      ? "No friend requests"
                                      : allreqList.pending.length == 1
                                          ? "${allreqList.pending.length} request"
                                          : "${allreqList.pending.length} requests",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Friend Request Card >>>>> //////
                  RequestCard(allreqList.pending, 1),
                ],
              ),
            ),
    );
  }
}
