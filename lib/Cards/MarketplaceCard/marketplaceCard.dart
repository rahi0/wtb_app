import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class MarketplaceCard extends StatefulWidget {
  var productList;
  MarketplaceCard(this.productList);
  @override
  _MarketplaceCardState createState() => _MarketplaceCardState();
}

class _MarketplaceCardState extends State<MarketplaceCard> {
  String img = "";

  @override
  void initState() {
    img = "${widget.productList.singleImage.image}";
    if (img.contains("localhost")) {
      img = img.replaceAll("localhost", "http://10.0.2.2");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsPage(widget.productList.id)),
              );
            },
                  child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 5, left: 2.5, right: 2.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                        BoxShadow(
                          blurRadius: 16.0,
                          color: Colors.grey[300],
                          //offset: Offset(3.0, 4.0),
                        ),
                      ],
            ),
            child: Container(
              padding: EdgeInsets.only(bottom: 0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(children: <Widget>[
                        ////// <<<<< Product Image >>>>> //////
                        Center(
                          child: Container(
                              padding: const EdgeInsets.all(5.0),
                              margin: EdgeInsets.only(top: 5),
                              child: Image(
                                image: NetworkImage("${widget.productList.singleImage.image}"),
                              )),
                        ),

                        ////// <<<<< Product Tag >>>>> //////
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(5),
                                  color: header,
                                  child: Text(
                                    "New",
                                    style: TextStyle(
                                        fontFamily: "Oswald",
                                        color: Colors.white,
                                        fontSize: 12),
                                  )),
                            ],
                          ),
                        )
                      ]),
                    )),
                  ),

                  ////// <<<<< Divider 1 >>>>> //////
                  Divider(
                    color: Colors.grey[300],
                  ),

                  ////// <<<<< Product Name >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                              widget.productList.productName != null
                                  ? "${widget.productList.productName}"
                                  : "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: "Oswald",
                                  fontSize: 13,
                                  color: Colors.black87)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  ////// <<<<< Product Price >>>>> //////
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 6),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_money,
                                color: Colors.black87,
                                size: 20,
                              ),
                              Text(
                                widget.productList.lowerPrice != null &&
                                        widget.productList.upperPrice != null
                                    ? "${widget.productList.lowerPrice}" +
                                        "-" +
                                        "${widget.productList.upperPrice}"
                                    : "",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Oswald",
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Product Location >>>>> //////
                  Container(
                    margin: EdgeInsets.only(top: 8, left: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.only(right: 8, top: 0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  size: 13,
                                  color: header,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: Text("5.0",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontFamily: "Oswald",
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< Product Arrival Time >>>>> //////
                        Container(
                          margin: EdgeInsets.only(right: 8, top: 0, bottom: 10),
                          child: Row(
                            children: <Widget>[
                              Text("2 days ago",
                                  style: TextStyle(
                                      fontFamily: "Oswald",
                                      color: Colors.grey,
                                      fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
