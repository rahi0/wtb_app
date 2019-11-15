import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/Loader/InviteFriendLoader/inviteFriendLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class AllFriendInviteCard extends StatefulWidget {
  @override
  AllFriendInviteCardState createState() => AllFriendInviteCardState();
}

class AllFriendInviteCardState extends State<AllFriendInviteCard> {
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
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                          color: Colors.black38,
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
                                
                                ////// <<<<< Profile Picture >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(1.0),
                                  child: CircleAvatar(
                                    radius: 15.0,
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
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                ////// <<<<< User Name >>>>> //////
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
                                            color: Colors.black54,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400),
                                      ),
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
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: header, width: 0.5)),
                              child: Text("Invite",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 12))),
                      ],
                    ),
                  )
                : InviteFriendsLoaderCard();
          }, childCount: friendname.length),
        ),
      ),
    );
  }
}
