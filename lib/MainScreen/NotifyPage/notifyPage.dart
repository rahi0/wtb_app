import 'package:chatapp_new/Cards/NotificationCard/notificationCard.dart';
import 'package:chatapp_new/Loader/NotificationLoader/notifyLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../../main.dart';

class NotifyPage extends StatefulWidget {
  @override
  NotifyPageState createState() => NotifyPageState();
}

class NotifyPageState extends State<NotifyPage> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ////// <<<<< Background color >>>>> //////
      backgroundColor: Colors.white,

      ////// <<<<< AppBar >>>>> //////
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ////// <<<<< Title >>>>> //////
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Notification",
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
      ),

      ////// <<<<< Body >>>>> //////
      body: Container(
        margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        child: CustomScrollView(
          slivers: <Widget>[
            ////// <<<<< For margin in top of the list >>>>> //////
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                  )
                ],
              ),
            ),

            ////// <<<<< Notification Card >>>>> //////
            NotificationCard(),
          ],
        ),
      ),
    );
  }
}
