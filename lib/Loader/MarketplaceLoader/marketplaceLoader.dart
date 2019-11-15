import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class MarketplaceLoaderCard extends StatefulWidget {
  @override
  MarketplaceLoaderCardState createState() => MarketplaceLoaderCardState();
}

class MarketplaceLoaderCardState extends State<MarketplaceLoaderCard> {
  SharedPreferences sharedPreferences;
  String theme = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              ////// <<<<< Title >>>>> //////
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    "Marketplace",
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
                    margin: EdgeInsets.only(top: 10, left: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                        border: Border.all(width: 0.5, color: Colors.black)),
                  ),
                ],
              ),

              ////// <<<<< Number of products >>>>> //////
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 12, left: 20, bottom: 10),
                        child: Text(
                          "Loading products...",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 10, right: 10),

          ////// <<<<< Gridview>>>>> //////
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                  (MediaQuery.of(context).size.height / 2.5),
            ),
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              ////// <<<<< Portrait Card >>>>> //////
              return OrientationBuilder(builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? PortraitLoader()
                    : LandscapeLoader();
              });

              // ////// <<<<< Loader >>>>> //////
              // : GroupLoaderCard();
            }, childCount: 2),
          ),
        )
      ],
    );
  }
}

class PortraitLoader extends StatefulWidget {
  @override
  _PortraitLoaderState createState() => _PortraitLoaderState();
}

class _PortraitLoaderState extends State<PortraitLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
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
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[200],
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  color: Colors.black,
                                ),
                              ),
                            )),
                      ),
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
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.grey[200],
                          child: Container(
                            width: 150,
                            height: 15,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        ),
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
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 0, left: 6, right: 8),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_money,
                                color: Colors.black87,
                                size: 20,
                              ),
                              Expanded(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[400],
                                  highlightColor: Colors.grey[200],
                                  child: Container(
                                    height: 18,
                                    child: Container(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                      Container(
                        margin: EdgeInsets.only(right: 8, top: 0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 13,
                              color: header,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[400],
                                highlightColor: Colors.grey[200],
                                child: Container(
                                  width: 30,
                                  height: 11,
                                  child: Container(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ////// <<<<< Product Arrival Time >>>>> //////
                      Container(
                        margin: EdgeInsets.only(right: 8, top: 0, bottom: 10),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.grey[200],
                          child: Container(
                            width: 50,
                            height: 11,
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
      ),
    );
  }
}

class LandscapeLoader extends StatefulWidget {
  @override
  _LandscapeLoaderState createState() => _LandscapeLoaderState();
}

class _LandscapeLoaderState extends State<LandscapeLoader> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
