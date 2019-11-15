import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../main.dart';

class ProfileCard extends StatefulWidget {
  final userData;
  ProfileCard(this.userData);
  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

  @override
  void initState() {
    // sharedPrefcheck();
    // timerCheck();
    print(widget.userData);
    // if (widget.userData['profilePic'].contains("localhost")) {
    //   widget.userData['profilePic'] =
    //       widget.userData['profilePic'].replaceAll("localhost", "http://10.0.2.2");
    // }else {
    //   widget.userData['profilePic'] = "http://10.0.2.2:3010" + widget.userData['profilePic'];
    // }
    super.initState();
  }

  // void sharedPrefcheck() async {
  //   sharedPreferences = await SharedPreferences.getInstance();

  //   setState(() {
  //     theme = sharedPreferences.getString("theme");
  //   });
  //   //print(theme);
  // }

  // void timerCheck() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) => setState(
  //       () {
  //         if (_start < 1) {
  //           timer.cancel();
  //           setState(() {
  //             loading = false;
  //           });
  //         } else {
  //           _start = _start - 1;
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyProfilePage(widget.userData)));
        },

        ////// <<<<< Main Data >>>>> //////
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
                        BoxShadow(
                          blurRadius: 5.0,
                          color: Colors.grey[300],
                          //offset: Offset(3.0, 4.0),
                        ),
                      ],
            //border: Border.all(width: 1.0, color: Colors.grey[300]),
          ),
          margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 0, right: 0),
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
                      Stack(
                        children: <Widget>[
                          ////// <<<<< Picture >>>>> //////
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage("${widget.userData['profilePic']}")
                                //AssetImage('assets/images/man.png'),
                                ),
                            decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),

                          ////// <<<<< Online Green Dot >>>>> //////
                          Container(
                            margin: EdgeInsets.only(left: 40, top: 5),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 5.0,
                              backgroundColor: Colors.greenAccent,
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.greenAccent, // border color
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      ////// <<<<< User Name >>>>> //////
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.userData['firstName'] != null &&
                                      widget.userData['lastName'] != null
                                  ? '${widget.userData['firstName']} ' +
                                      '${widget.userData['lastName']}'
                                  : '',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w400),
                            ),

                            ////// <<<<< View Profile Option >>>>> //////
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "View and edit profile",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
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

              ////// <<<<< Arrow >>>>> //////
              Container(
                  margin: EdgeInsets.only(right: 15),
                  padding:
                      EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
