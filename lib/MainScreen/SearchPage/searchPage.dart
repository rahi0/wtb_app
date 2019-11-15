import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/SearchCard/searchCard.dart';
import 'package:chatapp_new/JSON_Model/ProductsrchModel/productsrchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int _current = 0;
  int _isBack = 0;
  int activePage = 1;
  String result = '';
  bool _isChecked = false;
  SharedPreferences sharedPreferences;
  String theme = "", productCategory = "";
  bool loading = true;
  var searchList;
  TextEditingController src = new TextEditingController();
  List category = ["People", "SUV", "Mercedes", "Audi"];
  List<DropdownMenuItem<String>> _dropDownCategoryService;

  @override
  void initState() {
    //print(user.length);
    //friendname.addAll(name);
    searchData("");
    _dropDownCategoryService = getDropDownCategoryItems();
    productCategory = _dropDownCategoryService[0].value;
    super.initState();
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

  Future searchData(String result) async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    var searchtresponse = await CallApi()
        .getData('filter/title?keyword=$result&page=$activePage');
    var searchcontent = searchtresponse.body;
    final searchs = json.decode(searchcontent);
    var searchdata = ProductSearchModel.fromJson(searchs);

    setState(() {
      searchList = searchdata;
    });
    setState(() {
      loading = false;
    });
    // print("searchList.searchResult.length");
    // print(searchList.searchResult.length);
  }

  Future searchResult(String value) async {
    var data = {
      'str': value,
    };

    print(data);

    var res = await CallApi().postData1(data, 'search');
    var body = json.decode(res.body);

    print(body);
  }

  // void filterSearchResults(String query) {
  //   List<String> dummySearchList = List<String>();
  //   dummySearchList.addAll(name);
  //   if (query.isNotEmpty) {
  //     List<String> dummyListData = List<String>();
  //     dummySearchList.forEach((item) {
  //       if (item.toLowerCase().contains(query)) {
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       friendname.clear();
  //       friendname.addAll(dummyListData);
  //       //print(friendname);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       friendname.clear();
  //       friendname.addAll(name);
  //       //print(friendname);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          title: Container(
            margin: EdgeInsets.only(top: 0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 5), child: BackButton()),
                selectedPage == 2
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(right: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                            value: productCategory,
                            items: _dropDownCategoryService,
                            onChanged: (String value) {
                              setState(() {
                                productCategory = value;
                              });
                            },
                          ),
                        ),
                      ),
                Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 0, right: 10, top: 0),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                //filterSearchResults(value);
                                if (selectedPage == 2) {
                                  result = value;
                                } else {
                                  searchResult(value);
                                }
                              },
                              controller: src,
                              autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Oswald',
                              ),
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                                //labelStyle: TextStyle(color: Colors.white70),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                ////// <<<<< Search button >>>>> //////
                GestureDetector(
                  onTap: () {
                    searchData(result);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: back,
                        border: Border.all(color: Colors.grey[100], width: 0.5),
                        borderRadius: BorderRadius.circular(25)),
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.search,
                      color: header,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        body: selectedPage == 2
            ? Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              "Product searches",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(
                                  top: 10, left: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                            ),
                          ],
                        ),
                      ],
                    )),
                    SliverPadding(
                        padding: EdgeInsets.only(bottom: 15, top: 5),
                        sliver: loading == true
                            ? SliverToBoxAdapter(
                                child: Text(
                                  "Please wait...",
                                  style: TextStyle(
                                      fontFamily: "Oswald",
                                      color: Colors.grey[600]),
                                ),
                              )
                            : searchList.searchResult.length == 0
                                ? SliverPadding(
                                    padding: EdgeInsets.only(left: 20),
                                    sliver: SliverToBoxAdapter(
                                      child: Text(
                                        "No result found",
                                        style: TextStyle(
                                            fontFamily: "Oswald",
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  )
                                : SliverPadding(
                                    padding: EdgeInsets.only(left: 20),
                                    sliver: SliverToBoxAdapter(
                                      child: Text(
                                        result == ""
                                            ? ""
                                            : searchList.searchResult.length ==
                                                    1
                                                ? "${searchList.searchResult.length} result found"
                                                : "${searchList.searchResult.length} results found",
                                        style: TextStyle(
                                            fontFamily: "Oswald",
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  )),
                    result == ""
                        ? SliverToBoxAdapter(
                            child: Container(),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return SearchCard(searchList.searchResult[index]);
                            }, childCount: searchList.searchResult.length),
                          )
                  ],
                ),
              )
            : DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              "Search result",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(
                                  top: 10, left: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      //constraints: BoxConstraints(maxHeight: 150.0),
                      child: new Material(
                        //color: header,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(.2),
                                  //offset: Offset(6.0, 7.0),
                                ),
                              ],
                              //border: Border.all(color: sub_white, width: 0.3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: new TabBar(
                            labelStyle: TextStyle(
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            tabs: [
                              new Tab(
                                text: "Posts",
                              ),
                              new Tab(
                                text: "People",
                              ),
                            ],
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Colors.black45,
                            unselectedLabelStyle: TextStyle(
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300,
                                fontSize: 14),
                            labelColor: header,
                            //labelStyle: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          CustomScrollView(
                            slivers: <Widget>[
                              result == ""
                                  ? SliverToBoxAdapter(
                                      child: Container(),
                                    )
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        return SearchCard(
                                            searchList.searchResult[index]);
                                      },
                                          childCount:
                                              searchList.searchResult.length),
                                    ),
                            ],
                          ),
                          CustomScrollView(
                            slivers: <Widget>[
                              result == ""
                                  ? SliverToBoxAdapter(
                                      child: Container(),
                                    )
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        return SearchCard(
                                            searchList.searchResult[index]);
                                      },
                                          childCount:
                                              searchList.searchResult.length),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }
}
