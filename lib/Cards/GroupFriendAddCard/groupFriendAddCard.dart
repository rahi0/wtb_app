import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class GroupFriendAddCard extends StatefulWidget {
  @override
  GroupFriendAddCardState createState() => GroupFriendAddCardState();
}

class GroupFriendAddCardState extends State<GroupFriendAddCard> {
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
    friendname.addAll(name);
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

  // void filterSearchResults(String query) {
  //   List<String> dummySearchList = List<String>();
  //   dummySearchList.addAll(name);
  //   if (query.isNotEmpty) {
  //     List<String> dummyListData = List<String>();
  //     dummySearchList.forEach((item) {
  //       if (item.toLowerCase().contains(query)) {
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       friendname.clear();
  //       friendname.addAll(dummyListData);
  //       //print(friendname);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       friendname.clear();
  //       friendname.addAll(name);
  //       //print(friendname);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverPadding(
        padding: EdgeInsets.only(bottom: 15, top: 5),
        sliver: SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return loading == false
                ? Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      //border: Border.all(width: 0.8, color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                          color: Colors.black38,
                          //offset: Offset(6.0, 7.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 2.5, bottom: 2.5, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            //color: Colors.red,
                            margin:
                                EdgeInsets.only(left: 15, right: 20, top: 0),
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                      padding: EdgeInsets.all(1.0),
                                      child: CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.white,
                                        backgroundImage: index == 0
                                            ? AssetImage(
                                                'assets/images/man.png')
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
                                        color: Colors.grey[300], // border color
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 30),
                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                      padding: EdgeInsets.all(1.0),
                                      child: CircleAvatar(
                                        radius: 5.0,
                                        backgroundColor: Colors.greenAccent,
                                        //backgroundImage: AssetImage('assets/user.png'),
                                      ),
                                      decoration: new BoxDecoration(
                                        color:
                                            Colors.greenAccent, // border color
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        friendname[index],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400),
                                      ),
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
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  //user.add("value $index");
                                  //users = user.toList();
                                  //Navigator.pop(context);
                                });
                              },
                              child: Container(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : LoaderCard();
          }, childCount: friendname.length),
        ),
      ),
    );
  }
}
