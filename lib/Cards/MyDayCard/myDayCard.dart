import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class MydayCard extends StatefulWidget {
  @override
  MydayCardState createState() => MydayCardState();
}

class MydayCardState extends State<MydayCard> {
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
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 10),
      //color: sub_white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 0),
      height: 110,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => new Container(
          margin: EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
          padding: EdgeInsets.only(left: 0),
          height: 100,
          width: 90,
          decoration: BoxDecoration(

            ////// <<<<< Picture >>>>> //////
            image: DecorationImage(
              image: index == 0
                  ? AssetImage("assets/images/man.png")
                  : index == 1
                      ? AssetImage("assets/images/man2.jpg")
                      : index == 2
                          ? AssetImage("assets/images/man.png")
                          : index == 3
                              ? AssetImage("assets/images/man2.jpg")
                              : index == 4
                                  ? AssetImage("assets/images/man.png")
                                  : AssetImage("assets/images/man2.jpg"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Colors.black.withOpacity(.5),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 0),
                  padding: EdgeInsets.only(left: 0),
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  )),

              ////// <<<<< Add to story for index 0 >>>>> //////
              index == 0
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 26,
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 0, left: 10, bottom: 5),
                            child: Text(
                              "Add to story",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    )


                    ////// <<<<< User Name for other indexes >>>>> //////
                  : Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 10, left: 10, bottom: 5),
                      child: Text(
                        index == 1
                            ? "John Smith"
                            : index == 2
                                ? "David Ryan"
                                : index == 3
                                    ? "Simon Wright"
                                    : index == 4
                                        ? "Mike Johnson"
                                        : "Daniel Smith",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      )),
            ],
          ),
        ),

        ////// <<<<< 1 when loading : total 6 cards after loading >>>>> //////
        itemCount: loading ? 1 : 6,
      ),
    );
  }
}
