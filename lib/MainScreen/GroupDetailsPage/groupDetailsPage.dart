import 'dart:convert';

import 'package:chatapp_new/Cards/PostCard/postCard.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:chatapp_new/MainScreen/GroupMemberPage/groupMemberPage.dart';
import 'package:chatapp_new/MainScreen/InviteGroupMemberPage/inviteGroupMemberPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class GroupDetailsPage extends StatefulWidget {
  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {

  var userData;
  bool _isLoaded = false;
  @override
  void initState() {
     _getUserInfo();
    super.initState();
  }
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      _isLoaded = true;
    });

    print(userData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      //color: Colors.black.withOpacity(0.5),
                    ),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Group Details",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[
                    ////// <<<<< Cover Photo >>>>> //////
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 0, right: 0),
                      child: Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/f9.jpg"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0))),
                        child: null,
                      ),
                    ),

                    ////// <<<<< Group by >>>>> //////
                    Container(
                      padding: EdgeInsets.only(top: 0, left: 10, right: 0),
                      alignment: Alignment.centerLeft,
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.grey[600]),
                      child: Text(
                        "Group by Bijoya Banik",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      ),
                    ),

                    ////// <<<<< About Button >>>>> //////
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.only(top: 15, bottom: 20),
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              // color: Colors.red
                              ),
                          child: Column(
                            children: <Widget>[
                              ////// <<<<< Group Title >>>>> //////
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Flutter Rajjo",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 23,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                        child: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.black,
                                      size: 27,
                                    ))
                                  ],
                                ),
                              ),

                              ////// <<<<< Group Members >>>>> //////
                              Container(
                                child: Text(
                                  "Secret Group - 25 Memeber",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )),
                    ),
//////

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ////// <<<<< Group Members Photo Button >>>>> //////
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupMemberPage()));
                            },
                            child: Container(
                              width: 160,
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              // color: Colors.blue,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/images/f9.jpg",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 30,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/images/f8.jpg",
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 60,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/images/man2.jpg",
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 90,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/images/f7.jpg",
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 120,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: ClipOval(
                                        child: Stack(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/images/f8.jpg",
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              child: ClipOval(
                                                child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ////// <<<<< Invite Members Button >>>>> //////

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InviteGroupMemberPage()),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 20, top: 10, bottom: 10),
                                //margin: EdgeInsets.only(left: 20, right: 20),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 17),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(
                                        "Invite",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'BebasNeue',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),

                    ////// <<<<< Status/Photo post >>>>> //////
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          ////// <<<<< Profile >>>>> //////
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyProfilePage(userData)),
                              );
                            },
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 0, left: 15),
                                    padding: EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 21.0,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          AssetImage('assets/images/man2.jpg'),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 45),
                                    padding: EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 5.0,
                                      backgroundColor: Colors.greenAccent,
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ////// <<<<< Status/Photo field >>>>> //////
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreatePost(userData)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10, top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, top: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border: Border.all(
                                                color: Colors.grey[300],
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        child: TextField(
                                          enabled: false,
                                          //controller: phoneController,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Oswald',
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "What's in your mind?",
                                            hintStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                            //labelStyle: TextStyle(color: Colors.white70),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10.0, 1, 20.0, 1),
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          ////// <<<<< Photo post >>>>> //////
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePost(userData)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: back,
                                  border: Border.all(
                                      color: Colors.grey[300], width: 0.5),
                                  borderRadius: BorderRadius.circular(25)),
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(11),
                              child: Icon(
                                Icons.photo,
                                color: header,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///////////// <<<<< END >>>>> ////////////

                    ////// <<<<< Divider 1 >>>>> //////
                    Container(
                        width: 50,
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            color: header,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1.0,
                                color: header,
                                //offset: Offset(6.0, 7.0),
                              ),
                            ],
                            border: Border.all(width: 0.5, color: header))),
                  ],
                ),
              ),
            ),
            //Posts card
            //CreatePostCard()
          ],
        ));
  }
}
