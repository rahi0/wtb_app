import 'dart:async';
import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/MarketplaceCard/marketplaceCard.dart';
import 'package:chatapp_new/Cards/MarketplaceCard/marketplacelandscapeCard.dart';
import 'package:chatapp_new/JSON_Model/Color_Model/color_Model.dart';
import 'package:chatapp_new/JSON_Model/MarketPlace_Model/marketPlace_model.dart';
import 'package:chatapp_new/JSON_Model/ProductFilterModel/productFilterModel.dart';
import 'package:chatapp_new/Loader/GroupLoader/groupLoader.dart';
import 'package:chatapp_new/Loader/MarketplaceLoader/marketplaceLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

int total = 0, lastPage = 0;
List colors = [];
bool colorClicked = false;

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  //var productList;
  SharedPreferences sharedPreferences;
  String theme = "",
      typeService = "",
      productColor = "",
      productSize = "",
      productCategory = "";
  int selectType = 1,
      currentPage = 1,
      totalPage = 3,
      pageCheck = 0,
      initLoad = 0;
  int xs = 0, s = 0, m = 0, l = 0, xl = 0, xxl = 0;
  var colorDetails;
  bool loading = false;
  bool isSizeOpen = false;
  final RefreshController _refreshController = RefreshController();
  TextEditingController minPriceController = new TextEditingController();
  TextEditingController maxPriceController = new TextEditingController();

  List type = ["Product", "Service"];
  List color = ["Red", "Green", "Blue", "Orange", "Pink", "Violet", "Yellow"];
  List size = ["XS", "S", "M", "L", "XL", "XXL"];
  List category = [
    "Management",
    "App Development",
    "Web Development",
    "UI/UX",
    "SEO"
  ];
  List selectedColorList = [];
  List sizeList = [];

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownColorItems,
      _dropDownSizeItems,
      _dropDownCategoryItems;

  List<DropdownMenuItem<String>> getDropDowntypeService() {
    List<DropdownMenuItem<String>> items = new List();
    for (String typeServe in type) {
      items.add(new DropdownMenuItem(
          value: typeServe,
          child: new Text(
            typeServe,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownColorItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String colors in color) {
      items.add(new DropdownMenuItem(
          value: colors,
          child: new Text(
            colors,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownSizeItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sizes in size) {
      items.add(new DropdownMenuItem(
          value: sizes,
          child: new Text(
            sizes,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownCategoryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in category) {
      items.add(new DropdownMenuItem(
          value: cat,
          child: new Text(
            cat,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  @override
  void initState() {
    //sharedPrefcheck();
    //timerCheck();
    loadData(1);
    _dropDowntypeService = getDropDowntypeService();
    typeService = _dropDowntypeService[0].value;

    _dropDownColorItems = getDropDownColorItems();
    productColor = _dropDownColorItems[0].value;

    _dropDownSizeItems = getDropDownSizeItems();
    productSize = _dropDownSizeItems[0].value;

    _dropDownCategoryItems = getDropDownCategoryItems();
    productCategory = _dropDownCategoryItems[0].value;
    super.initState();
  }

  Future loadData(int page) async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    if (page3 == 0) {
      var postresponse =
          await CallApi().getData('getAllProducts?page=$activePage');
      var postcontent = postresponse.body;
      final posts = json.decode(postcontent);
      var marketdata = MarketPlaceModel.fromJson(posts);

      setState(() {
        productList = marketdata;
        page3 = 1;
        lastPage = productList.lastPage;
        total = total + productList.data.length;
      });
    }

    setState(() {
      loading = false;
    });
    // print("productList.data.length");
    // print(productList.data.length);
  }

  Future loadColor() async {
    setState(() {
      loading = true;
    });

    var colorresponse = await CallApi().getData3('getAllProductColor');
    var colorcontent = colorresponse.body;
    final color = json.decode(colorcontent);
    var colordata = ColorModel.fromJson(color);

    setState(() {
      colorDetails = colordata;
      Navigator.of(context).pop();
      _showFilterDialog();
    });

    setState(() {
      loading = false;
    });
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse('0xFF' + hexColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        //header: WaterDropMaterialHeader(),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            page3 = 0;
          });
          loadData(activePage);
          _refreshController.refreshCompleted();
        },
        child: loading == true
            ? MarketplaceLoaderCard()
            : CustomScrollView(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
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
                                  margin: EdgeInsets.only(
                                      top: 12, left: 20, bottom: 10),
                                  child: Text(
                                    productList.data.length == 0
                                        ? "No products"
                                        : "${productList.total} products",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  )),

                              ////// <<<<< Show all option >>>>> //////
                              // productList.data.length == 0
                              //     ? Container()
                              //     : GestureDetector(
                              //         onTap: () {
                              //           loadColor();
                              //           _showFilterDialog();
                              //         },
                              //         child: Container(
                              //             alignment: Alignment.centerLeft,
                              //             padding: EdgeInsets.only(
                              //                 left: 8,
                              //                 right: 8,
                              //                 top: 5,
                              //                 bottom: 5),
                              //             margin: EdgeInsets.only(right: 20),
                              //             decoration: BoxDecoration(
                              //                 color: Colors.white,
                              //                 borderRadius:
                              //                     BorderRadius.circular(8),
                              //                 boxShadow: [
                              //                   BoxShadow(
                              //                     blurRadius: 2.0,
                              //                     color: Colors.grey,
                              //                   )
                              //                 ]),
                              //             child: Row(
                              //               children: <Widget>[
                              //                 Container(
                              //                   child: Text(
                              //                     "Filter",
                              //                     textAlign: TextAlign.start,
                              //                     style: TextStyle(
                              //                         color: header,
                              //                         fontSize: 14,
                              //                         fontFamily: 'Oswald',
                              //                         fontWeight:
                              //                             FontWeight.w400),
                              //                   ),
                              //                 ),
                              //                 Container(
                              //                   margin: EdgeInsets.only(
                              //                       top: 3, left: 3),
                              //                   child: Icon(Icons.filter_list,
                              //                       color: header, size: 15),
                              //                 )
                              //               ],
                              //             )),
                              //       ),
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
                      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      //   maxCrossAxisExtent: 300.0,
                      //   mainAxisSpacing: 0.0,
                      //   crossAxisSpacing: 0.0,
                      //   childAspectRatio: 1.0,
                      // ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / 2) /
                                (MediaQuery.of(context).size.height / 2.5),
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        ////// <<<<< Portrait Card >>>>> //////
                        return OrientationBuilder(
                            builder: (context, orientation) {
                          return orientation == Orientation.portrait
                              ? MarketplaceCard(productList.data[index])
                              : MarketplaceLandCard(productList.data[index]);
                        });

                        // ////// <<<<< Loader >>>>> //////
                        // : GroupLoaderCard();
                      }, childCount: productList.data.length),
                    ),
                  ),
                  productList.data.length == 0
                      ? SliverToBoxAdapter()
                      : SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activePage--;
                                      //page3 = 0;
                                      if (activePage <= 1) {
                                        activePage = 1;
                                      }
                                      if (activePage % totalPage == 0) {
                                        currentPage = activePage - 2;
                                      }
                                      if (activePage == productList.page) {
                                        setState(() {
                                          page3 = 1;
                                        });
                                      } else {
                                        setState(() {
                                          page3 = 0;
                                        });
                                      }
                                    });
                                    // print(productList.lastPage);
                                    // print(productList.page);
                                    initLoad == 0
                                        ? loadData(activePage)
                                        : filterProduct();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin:
                                          EdgeInsets.only(right: 0, left: 20),
                                      decoration: BoxDecoration(
                                          color: activePage == 1
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey,
                                            )
                                          ]),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 3, left: 0),
                                        child: Icon(Icons.chevron_left,
                                            color: activePage == 1
                                                ? Colors.grey[400]
                                                : header,
                                            size: 18),
                                      )),
                                ),
                                currentPage > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage;
                                            pageCheck++;
                                            page3 = 0;
                                          });
                                          initLoad == 0
                                              ? loadData(activePage)
                                              : filterProduct();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right: 5, left: 10),
                                            decoration: BoxDecoration(
                                                color: activePage == currentPage
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "$currentPage",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                currentPage + 1 > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage + 1;
                                            pageCheck++;
                                            page3 = 0;
                                          });
                                          initLoad == 0
                                              ? loadData(activePage)
                                              : filterProduct();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right:
                                                    currentPage + 1 > lastPage
                                                        ? 5
                                                        : 10,
                                                left: 5),
                                            decoration: BoxDecoration(
                                                color: activePage ==
                                                        currentPage + 1
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "${currentPage + 1}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage + 1
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                currentPage + 2 > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage + 2;
                                            pageCheck++;
                                            page3 = 0;
                                          });
                                          initLoad == 0
                                              ? loadData(activePage)
                                              : filterProduct();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right: 10, left: 5),
                                            decoration: BoxDecoration(
                                                color: activePage ==
                                                        currentPage + 2
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "${currentPage + 2}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage + 2
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activePage++;
                                      //page3 = 0;
                                      if (activePage >= lastPage) {
                                        activePage = lastPage;
                                        page3 = 1;
                                      }
                                      if (activePage > currentPage + 2) {
                                        currentPage = activePage;
                                      }
                                      if (productList.lastPage ==
                                          productList.page) {
                                        setState(() {
                                          page3 = 1;
                                        });
                                      } else {
                                        setState(() {
                                          page3 = 0;
                                        });
                                      }
                                    });
                                    // print(productList.lastPage);
                                    // print(productList.page);
                                    initLoad == 0
                                        ? loadData(activePage)
                                        : filterProduct();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin:
                                          EdgeInsets.only(right: 20, left: 0),
                                      decoration: BoxDecoration(
                                          color: activePage == lastPage
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey,
                                            )
                                          ]),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 3, left: 0),
                                        child: Icon(Icons.chevron_right,
                                            color: activePage == lastPage
                                                ? Colors.grey[400]
                                                : header,
                                            size: 18),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
      ),
    );
  }

  Future<Null> _showFilterDialog() async {
    if (typeService == "Product") {
      selectType = 1;
    } else {
      selectType = 2;
    }
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: colorDetails == null
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text(
                                    "Type: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w200),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      value: typeService,
                                      items: _dropDowntypeService,
                                      onChanged: (String value) {
                                        setState(() {
                                          typeService = value;
                                          print(typeService);
                                        });
                                        Navigator.of(context).pop();
                                        _showFilterDialog();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        selectType == 1
                            ? Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            //width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(
                                                top: 0, left: 0),
                                            child: Text(
                                              "Color: ",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w200),
                                            )),
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 0),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.end,
                                        //     children: <Widget>[
                                        //       DropdownButtonHideUnderline(
                                        //         child: DropdownButton(
                                        //           style: TextStyle(
                                        //               fontSize: 15,
                                        //               color: Colors.black87,
                                        //               fontFamily: 'Oswald',
                                        //               fontWeight: FontWeight.w300),
                                        //           value: productColor,
                                        //           items: _dropDownColorItems,
                                        //           onChanged: (String value) {
                                        //             setState(() {
                                        //               productColor = value;
                                        //             });
                                        //             Navigator.of(context).pop();
                                        //             _showFilterDialog();
                                        //           },
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Container(
                                          height: 35,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 5),
                                          child: new ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                //ColorCard(colorDetails.colors[index]),
                                                GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (colors.contains(
                                                      colorDetails
                                                          .colors[index].id)) {
                                                    colors.remove(colorDetails
                                                        .colors[index].id);
                                                    print(colors);
                                                  } else {
                                                    colors.add(colorDetails
                                                        .colors[index].id);
                                                    print(colors);
                                                  }
                                                });
                                                Navigator.of(context).pop();
                                                _showFilterDialog();
                                              },
                                              child: new Container(
                                                margin: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 5,
                                                    bottom: 5),
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  ////// <<<<< Color >>>>> //////
                                                  color: _getColorFromHex(
                                                      "${colorDetails.colors[index].colorCode}"),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Colors.black
                                                          .withOpacity(.5),
                                                    ),
                                                  ],
                                                ),
                                                child: colors.length != 0 &&
                                                        colors.contains(
                                                            colorDetails
                                                                .colors[index]
                                                                .id)
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                        ),
                                                        child: Icon(
                                                          Icons.done,
                                                          color: Colors.white,
                                                          size: 17,
                                                        ))
                                                    : Container(),
                                              ),
                                            ),
                                            itemCount:
                                                colorDetails.colors.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (isSizeOpen == false) {
                                                setState(() {
                                                  isSizeOpen = true;
                                                });
                                              } else {
                                                setState(() {
                                                  isSizeOpen = false;
                                                });
                                              }
                                              Navigator.of(context).pop();
                                              _showFilterDialog();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10,
                                                  top: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: isSizeOpen == false
                                                    ? null
                                                    : Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                      ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      child: Text(
                                                    "Size: ",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  )),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          top: 3),
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down))
                                                ],
                                              ),
                                            ),
                                          ),
                                          isSizeOpen == false
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2, top: 0),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10,
                                                        top: 10),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xs++;
                                                                if (xs % 2 ==
                                                                    0) {
                                                                  sizeList.remove(
                                                                      "isXS");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isXS");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: xs % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: xs % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: xs % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "XS",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                s++;
                                                                if (s % 2 ==
                                                                    0) {
                                                                  sizeList
                                                                      .remove(
                                                                          "isS");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isS");
                                                                }
                                                                //print(sizeList);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: s % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: s % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: s % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "S",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                m++;
                                                                if (m % 2 ==
                                                                    0) {
                                                                  sizeList
                                                                      .remove(
                                                                          "isM");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isM");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: m % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: m % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: m % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "M",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                l++;
                                                                if (l % 2 ==
                                                                    0) {
                                                                  sizeList
                                                                      .remove(
                                                                          "isL");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isL");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: l % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: l % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: l % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "L",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xl++;
                                                                if (xl % 2 ==
                                                                    0) {
                                                                  sizeList.remove(
                                                                      "isXL");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isXL");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: xl % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: xl % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: xl % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "XL",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                xxl++;
                                                                if (xxl % 2 ==
                                                                    0) {
                                                                  sizeList.remove(
                                                                      "isXXL");
                                                                } else {
                                                                  sizeList.add(
                                                                      "isXXL");
                                                                }
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                _showFilterDialog();
                                                                //print(sizeList);
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              1),
                                                                      decoration: BoxDecoration(
                                                                          color: xxl % 2 == 0
                                                                              ? Colors
                                                                                  .white
                                                                              : header.withOpacity(
                                                                                  0.7),
                                                                          border: Border.all(
                                                                              color: xxl % 2 == 0 ? Colors.grey : header.withOpacity(0.7),
                                                                              width: 0.3),
                                                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                      child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: xxl % 2 ==
                                                                                0
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                        size:
                                                                            14,
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "XXL",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: Colors.black.withOpacity(
                                                                              0.6),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        //width: MediaQuery.of(context).size.width,
                                        margin:
                                            EdgeInsets.only(top: 0, left: 0),
                                        child: Text(
                                          "Category: ",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w200),
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                            value: productCategory,
                                            items: _dropDownCategoryItems,
                                            onChanged: (String value) {
                                              setState(() {
                                                productCategory = value;
                                              });
                                              Navigator.of(context).pop();
                                              _showFilterDialog();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        Container(
                          //color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  //color: Colors.yellow,
                                  //width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text(
                                    "Price: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w200),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      //////// <<<<< From Textfield start >>>>> //////
                                      Container(
                                          width: 60,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextField(
                                            controller: minPriceController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Oswald',
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "",
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                              //labelStyle: TextStyle(color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.5, 2.5, 2.5, 2.5),
                                              border: InputBorder.none,
                                            ),
                                          )),

                                      //////// <<<<< From Textfield end >>>>> //////

                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            "To",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w200),
                                          )),

                                      //////// <<<<< To Textfield start >>>>> //////
                                      Container(
                                          width: 60,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextField(
                                            controller: maxPriceController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Oswald',
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "",
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                              //labelStyle: TextStyle(color: Colors.white70),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.5, 2.5, 2.5, 2.5),
                                              border: InputBorder.none,
                                            ),
                                          )),

                                      //////// <<<<< To Textfield end >>>>> //////
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //////// <<<<< Cancel Button start >>>>> //////
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          right: 10,
                                          top: 20,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 17,
                                          fontFamily: 'BebasNeue',
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),

                              //////// <<<<< Cancel Button end >>>>> //////

                              //////// <<<<< Apply Button start >>>>> //////
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      page3 = 0;
                                      filterProduct();
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 0,
                                          top: 20,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                          color: header,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'BebasNeue',
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                              //////// <<<<< Apply Button end >>>>> //////
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future filterProduct() async {
    setState(() {
      loading = true;
    });
    var data = {
      'maxPrice': minPriceController.text,
      'minPrice': maxPriceController.text,
      'sizes': sizeList,
      'colors': colors,
      'type': typeService == "Product" ? "product" : "service",
    };

    var res = await CallApi().postData(data, 'filter/allData?page=$activePage');
    var body = json.decode(res.body);
    var marketdata = MarketPlaceModel.fromJson(body);

    setState(() {
      productList = marketdata;
      page3 = 1;
      lastPage = productList.lastPage;
      total = total + productList.data.length;
      print(lastPage);
      print(total);
    });

    print(body);

    setState(() {
      loading = false;
      initLoad = 1;
    });
  }
}
