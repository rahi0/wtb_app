import 'package:flutter/material.dart';

class MoreOptionCard extends StatefulWidget {
  @override
  _MoreOptionCardState createState() => _MoreOptionCardState();
}

class _MoreOptionCardState extends State<MoreOptionCard> {
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
                blurRadius: 1.0,
                color: Colors.black38,
                //offset: Offset(6.0, 7.0),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 0, right: 0),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Privacy Policy",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black45,
                    size: 17,
                  )),
            ],
          ),
        );
  }
}
