import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FriendListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
                margin: EdgeInsets.only(top: 10, left: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black,
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
          LoaderCard(),
          LoaderCard(),

          ////// <<<<< Title >>>>> //////
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 15, left: 20),
              child: Text(
                "Friends",
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
                margin: EdgeInsets.only(top: 10, left: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black,
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
          LoaderCard(),
          LoaderCard(),
          LoaderCard(),
        ],
      ),
    );
  }
}

//LoaderCard

class LoaderCard extends StatefulWidget {
  @override
  LoaderCardState createState() => LoaderCardState();
}

class LoaderCardState extends State<LoaderCard> {
  String theme = "";
  int _start = 3;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 20, right: 20),
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
                  ////// <<<<< Picture >>>>> //////
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(1.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[400],
                      highlightColor: Colors.grey[200],
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ////// <<<<< User Name >>>>> //////
                        Shimmer.fromColors(
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.grey[200],
                          child: Container(
                            width: 150,
                            height: 22,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        ),

                        ////// <<<<< Friend >>>>> //////
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[200],
                            child: Container(
                              width: 90,
                              height: 12,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
