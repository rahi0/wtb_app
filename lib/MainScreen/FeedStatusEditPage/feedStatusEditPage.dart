import 'package:chatapp_new/Forms/CreatePostForm/createPostForm.dart';
import 'package:chatapp_new/Forms/EditPostForm/editPostForm.dart';
import 'package:chatapp_new/Forms/FeedStatusEditForm/feedStatusEditForm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../main.dart';
import 'dart:async';

class FeedStatusEditPost extends StatefulWidget {
  final feed;
  final userData;
  final index;

  FeedStatusEditPost(this.feed, this.userData, this.index);
  @override
  FeedStatusEditPostState createState() => FeedStatusEditPostState();
}

class FeedStatusEditPostState extends State<FeedStatusEditPost> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer, _postTimer;
  int _start = 3, line = 1, _postStart = 2;
  bool loading = true;
  String post = '', chk = "";

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

  void postTimerCheck() {
    const oneSec = const Duration(seconds: 1);
    _postTimer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_postStart < 1) {
            timer.cancel();
            setState(() {
              chk = "";
            });
          } else {
            _postStart = _postStart - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        "Edit Post",
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FeedStatusEditForm(widget.feed, widget.userData, widget.index),
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
