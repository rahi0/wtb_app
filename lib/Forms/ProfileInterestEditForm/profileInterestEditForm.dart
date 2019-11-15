import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class InterestEditForm extends StatefulWidget {
  final userData;

  InterestEditForm(this.userData);
  @override
  _InterestEditState createState() => _InterestEditState();
}

class _InterestEditState extends State<InterestEditForm> {
  ScaffoldState scaffoldState;
  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  List<String> selectedCategory = [];
  var selectedCat;
  var catList;
  var userData;
  int user_id;
  bool isLoading = true;
  bool isSubmit = false;

  @override
  void initState() {
    _getUserInfo();
    loadCategories();
    user_id = widget.userData['id'];
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var tagJson = localStorage.getStringList('tags');
    var user = json.decode(userJson);
    List<String> tags = tagJson;
    setState(() {
      userData = user;
    });
    // print(tagJson);
    // print(tags);
    for (int i = 0; i < tags.length; i++) {
      selectedCategory.add("${tags[i]}");
      selectedCat = selectedCategory.toList();
    }

    //print("${userData['shop_id']}");
  }

  Future loadCategories() async {
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi().getData3('allInterests');
    var content = response.body;
    final collection = json.decode(content);
    var data = Catagory.fromJson(collection);

    setState(() {
      catList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return catList == null
        ? Container(
            height: MediaQuery.of(context).size.height - 90,
            child: Center(child: CircularProgressIndicator()),
          )
        : Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 0, left: 0),
                    child: Text(
                      "Edit Interests",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.normal),
                    )),
                Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      margin: EdgeInsets.only(top: 10, left: 0),
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
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 12, left: 0, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Update your interests",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          selectedCategory.length == 0
                              ? "No interests"
                              : selectedCategory.length == 1
                                  ? "${selectedCategory.length} Interest"
                                  : "${selectedCategory.length} Interests",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: header,
                              fontSize: 13,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
                ///// <<<<< Selected Interest Title >>>>> //////
                // selectedCategory.length == 0
                //     ? Container()
                //     : Container(
                //         color: Colors.white,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: <Widget>[
                //             Text(
                //               "Selected Interests",
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                   color: Colors.black,
                //                   fontSize: 15,
                //                   fontFamily: 'Oswald',
                //                   fontWeight: FontWeight.w400),
                //             )
                //           ],
                //         ),
                //       ),
                ///// <<<<< Selected Interest start >>>>> //////
                selectedCategory.length != 0
                    ? Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(top: 0, bottom: 15),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedCategory.length,
                          //separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 5, top: 8, bottom: 8),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "${selectedCat[index]}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedCategory.removeAt(index);
                                            selectedCat = selectedCategory;
                                            // print(
                                            //     "selectedCat");
                                            // print(
                                            //     selectedCat);
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Icon(Icons.clear),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          },
                        ),
                      )
                    : Container(),

                ////// <<<<< Selected Interest end >>>>> //////

                ///// <<<<< Select Interest Title >>>>> //////
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Select Interests",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),

                ///// <<<<<  Interest start >>>>> //////
                Container(
                  height: 280,
                  margin: EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    itemCount: catList.interests.length,
                    //separatorBuilder: (context, index) => Divider(),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: selectedCategory.length != 0 &&
                                          selectedCat.contains(
                                              catList.interests[index].name)
                                      ? back
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 5, top: 3),
                              padding: EdgeInsets.only(
                                  bottom: 6, top: 6, left: 10, right: 10),
                              child: Text(
                                "${catList.interests[index].name}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                              )),
                          onTap: () {
                            setState(() {
                              if (selectedCategory.length == 0) {
                                selectedCategory
                                    .add("${catList.interests[index].name}");
                                selectedCat = selectedCategory.toList();
                              } else {
                                if (selectedCat
                                    .contains(catList.interests[index].name)) {
                                  selectedCategory
                                      .remove(catList.interests[index].name);
                                  selectedCat = selectedCategory;
                                } else {
                                  selectedCategory
                                      .add("${catList.interests[index].name}");
                                  selectedCat = selectedCategory.toList();
                                }
                              }
                              //print(selectedCat);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                ///// <<<<<  Interest end >>>>> //////

                ////// <<<<< Sign up button >>>>> //////
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: isSubmit ? null : signUpButton,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: isSubmit ? Colors.grey : header,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Text(
                              isSubmit ? "Please wait..." : "Edit Interest",
                              style: TextStyle(
                                color: isSubmit ? Colors.black : Colors.white,
                                fontSize: 17,
                                fontFamily: 'BebasNeue',
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void signUpButton() async {
    if (selectedCategory.length == 0) {
      return _showMsg("Please select interests");
    }

    setState(() {
      isSubmit = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data = {
      'id': user_id,
      'tags': selectedCategory,
    };

    print(data);

    var res = await CallApi().postData1(data, 'update-user-topic');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setStringList('tags', selectedCategory.toList());

      _showCompleteDialog();
    } else if (body['success'] == false) {
      _showMsg(body['message']);
    }

    setState(() {
      isSubmit = false;
    });
  }

  Future<Null> _showCompleteDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: header, width: 1.5),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white),
                        child: Icon(
                          Icons.done,
                          color: header,
                          size: 50,
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Interests has been edited successfully.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(3)));
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
