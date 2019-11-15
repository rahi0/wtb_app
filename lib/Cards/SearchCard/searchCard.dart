import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class SearchCard extends StatefulWidget {
  final searchResult;
  SearchCard(this.searchResult);
  @override
  SearchCardState createState() => SearchCardState();
}

class SearchCardState extends State<SearchCard> {
  int _current = 0;
  int _isBack = 0;
  String result = '', img = "";
  bool _isChecked = false;
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  TextEditingController src = new TextEditingController();

  @override
  void initState() {
    //friendname.addAll(name);
    img = "${widget.searchResult.singleImage.image}";
    if (img.contains("localhost")) {
      img = img.replaceAll("localhost", "http://10.0.2.2");
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsPage(widget.searchResult.id)),
              );
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
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
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                //color: Colors.red,
                margin: EdgeInsets.only(left: 15, right: 20, top: 0),
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 90,
                          height: 80,                        //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          padding: EdgeInsets.all(1.0),
                          child: Image(
                                  image: NetworkImage("$img"),
                                ),
                          // decoration: new BoxDecoration(
                          //   color: Colors.grey[300], // border color
                          //   //shape: BoxShape.circle,
                          // ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.searchResult.productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
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
            GestureDetector(
              onTap: () {
                // setState(() {
                //   friendname.removeAt(widget.index);
                // });
              },
              child: Container(
                child: Icon(Icons.chevron_right,
                    color: Colors.black.withOpacity(0.5), size: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
