import 'package:chatapp_new/Cards/GroupFriendAddCard/groupFriendAddCard.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../../../main.dart';


class GroupAddPage extends StatefulWidget {
  @override
  _GroupAddPageState createState() => new _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  int _current = 0;
  int _isBack = 0;
  String result = '';
  bool _isChecked = false;

  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  TextEditingController src = new TextEditingController();

  @override
  void initState() {
    print(user.length);
    sharedPrefcheck();
    timerCheck();
    //friendname.addAll(name);
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

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(name);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        friendname.clear();
        friendname.addAll(dummyListData);
        //print(friendname);
      });
      return;
    } else {
      setState(() {
        friendname.clear();
        friendname.addAll(name);
        //print(friendname);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          //automaticallyImplyLeading: false,
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
                          "Create Group",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: header,
                          fontSize: 15,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.normal),
                    )),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Container(
                      //color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              //color: Colors.red,
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(right: 0),
                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                  padding: EdgeInsets.all(0.5),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                        'assets/images/add_image.jpg'),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300], // border color
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                //color: Colors.white,
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  //color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  //border: Border.all(width: 0.5, color: Colors.grey[400]),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(bottom: 10, top: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    border: Border.all(
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25))),
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: TextField(
                                                        //controller: phoneController,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Oswald',
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Group Name",
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                          //labelStyle: TextStyle(color: Colors.white70),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      1,
                                                                      20.0,
                                                                      1),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: 50,
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 5),
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
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Icon(Icons.search,
                                          color: Colors.black45, size: 20)),
                                  Flexible(
                                    child: TextField(
                                      onChanged: (value) {
                                        filterSearchResults(value);
                                      },
                                      controller: src,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Oswald',
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Search friend",
                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                        //labelStyle: TextStyle(color: Colors.white70),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            10.0, 2.5, 20.0, 2.5),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              "Friends",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(
                                  top: 10, left: 20, bottom: 10),
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
                      ],
                    ),
                    user.length != 0
                        ? Container(
                            margin: EdgeInsets.only(
                                left: 0, right: 0, top: 5, bottom: 15),
                            //color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            //padding: EdgeInsets.only(left: 15),
                            height: 60,
                            child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) =>
                                  new Container(
                                //color: Colors.white,
                                margin:
                                    EdgeInsets.only(left: 20, right: 0, top: 5),
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  //color: Colors.white,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      users.removeAt(index);
                                      user = users;
                                      //print(images.length);
                                    });
                                  },
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 0),
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage(
                                                'assets/images/man2.jpg'),
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors.white, // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              itemCount: user.length,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              GroupFriendAddCard(),
            ],
          ),
        ));
  }
}
