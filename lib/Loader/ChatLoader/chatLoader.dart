import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(width: 0.8, color: Colors.grey[300]),
        boxShadow: [
            BoxShadow(
              blurRadius: 16.0,
              color: Colors.grey[300],
              //offset: Offset(3.0, 4.0),
            ),
          ],
      ),
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              //color: Colors.red,
              margin: EdgeInsets.only(left: 20, right: 20, top: 0),
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
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
