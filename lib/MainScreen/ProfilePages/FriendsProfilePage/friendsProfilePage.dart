import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/POST_Model/post_model.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import '../../../main.dart';

class FriendsProfilePage extends StatefulWidget {
  final userName;
  final no;
  FriendsProfilePage(this.userName, this.no);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<FriendsProfilePage> {
  SharedPreferences sharedPreferences;
  String theme = "", statusPic = "", result = "";
  bool loading = true;
  bool _isLoading = false;
  var conList, postList;
  List<String> allPic = [];
  int id = 0;
  var userData;
  SocketIOManager manager;
  TextEditingController reasonController = new TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    loadConnection();
    //print(widget.userName);
    manager = SocketIOManager();
    getSocketIO();
    //print(conList.user.id);
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
      id = userData['id'];
      print(id);
    });
  }

  Future loadConnection() async {
    //await Future.delayed(Duration(seconds: 3));

    var response =
        await CallApi().getData('profile/${widget.userName}?tab=connection');
    var content = response.body;
    final collection = json.decode(content);
    var data = Connection.fromJson(collection);

    setState(() {
      conList = data;
      loading = false;
    });

    if (conList.user.profilePic.contains("localhost")) {
      conList.user.profilePic =
          conList.user.profilePic.replaceAll("localhost", "http://10.0.2.2");
    } else {
      conList.user.profilePic =
          "http://10.0.2.2:3010" + conList.user.profilePic;
    }

    //print(conList.user.interestLists.length);
    loadPosts();
  }

  Future loadPosts() async {
    //await Future.delayed(Duration(seconds: 3));

    var postresponse =
        await CallApi().getData('profile/${widget.userName}?tab=post');
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = Post.fromJson(posts);

    setState(() {
      postList = postdata;
      allPic = [];
      loading = false;
    });

    for (int i = 0; i < postList.res.length; i++) {
      for (int j = 0; j < postList.res[i].images.length; j++) {
        statusPic = postList.res[i].images[j].thum;
        if (statusPic.contains("localhost")) {
          statusPic = statusPic.replaceAll("localhost", "http://10.0.2.2");
          allPic.add(statusPic);
        } else {
          statusPic = "http://10.0.2.2:3010" + statusPic;
        }
        print(statusPic);
      }
    }
  }

  void getSocketIO() async {
    SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
        // 'https://www.dynamyk.biz/',
        'http://10.0.2.2:8080/',
        nameSpace: "/",
        //Query params - can be used for authentication
        // query: {
        //   "auth": "--SOME AUTH STRING---",
        //   "info": "new connection from adhara-socketio",
        //   "timestamp": DateTime.now().toString()
        // },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [
          Transports.WEB_SOCKET /*, Transports.POLLING*/
        ] //Enable required transport
        ));
    socket.onConnect((data) {
      print("connected...");
      print(data);
      // sendMessage(identifier);
      // socket.emit("send-request", [
      //   {"msg": "new message"}
      // ]);
    });

    print("receive_friend_request_user_29");

    socket.on("receive_friend_request_user_29", (data) {
      print("response");
      print(data);
      setState(() {
        pagess = data.toString();
      });
    });
    socket.connect();

    //sockets[driverId.toString()] = socket;
  }

  // void getSocketIO() async {
  //   SocketIO socket = await manager.createInstance(SocketOptions(
  //       //Socket IO server URI
  //       // 'https://www.dynamyk.biz/',
  //       'http://10.0.2.2:8080/',
  //       nameSpace: "/",
  //       //Query params - can be used for authentication
  //       // query: {
  //       //   "auth": "--SOME AUTH STRING---",
  //       //   "info": "new connection from adhara-socketio",
  //       //   "timestamp": DateTime.now().toString()
  //       // },
  //       //Enable or disable platform channel logging
  //       enableLogging: false,
  //       transports: [
  //         Transports.WEB_SOCKET /*, Transports.POLLING*/
  //       ] //Enable required transport
  //       ));
  //   socket.onConnect((data) {
  //     print("connected...");
  //     // print(data);
  //     // sendMessage(identifier);
  //     // socket.emit("send-request", [
  //     //   {"msg": "new message"}
  //     // ]);
  //   });

  //   print("receive_friend_request_user_29");

  //   socket.on("receive_friend_request_user_29", (data) {
  //     print("response");
  //     print(data);
  //   });
  //   socket.connect();

  //   //sockets[driverId.toString()] = socket;
  // }

  Future<Null> _showLogoutDialog() async {
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
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 0, right: 10, top: 0),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey, width: 0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  result = value;
                                },
                                controller: reasonController,
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Oswald',
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "Let the user know why you want to connect",
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
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 5, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                connectUser();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 5, right: 0, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: header,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "Connect",
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

  Future connectUser() async {
    setState(() {
      _isLoading = true;
    });

    if (reasonController.text.isEmpty) {
      return _showMsg("Please enter a reason to connect");
    } else {
      var data = {
        'following_id': conList.user.id,
        'reason': reasonController.text,
        'title': 'World Trade Buddy',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      };
      print(data);

      var res = await CallApi().postData1(data, 'add/friend');
      var body = json.decode(res.body);

      print(body);

      //getSocketIO();
    }

    setState(() {
      _isLoading = false;
    });
  }

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

  // void getSocketIO() async {
  //   SocketIO socket = await manager.createInstance(SocketOptions(
  //       //Socket IO server URI
  //       // 'https://www.dynamyk.biz/',
  //       'http://10.0.2.2:8080/',
  //       nameSpace: "/",
  //       //Query params - can be used for authentication
  //       // query: {
  //       //   "auth": "--SOME AUTH STRING---",
  //       //   "info": "new connection from adhara-socketio",
  //       //   "timestamp": DateTime.now().toString()
  //       // },
  //       //Enable or disable platform channel logging
  //       enableLogging: false,
  //       transports: [
  //         Transports.WEB_SOCKET /*, Transports.POLLING*/
  //       ] //Enable required transport
  //       ));
  //   socket.onConnect((data) {
  //     print("connected...");
  //     // print(data);
  //     // sendMessage(identifier);
  //     // socket.emit("send-request", [
  //     //   {"msg": "new message"}
  //     // ]);
  //   });

  //   socket.on("receive_friend_request_user_$id", (data) {
  //     print("response");
  //     print(data);
  //   });
  //   socket.connect();

  //   //sockets[driverId.toString()] = socket;
  // }

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
                          "Profile Details",
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
        body: conList == null || postList == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: SingleChildScrollView(
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          SafeArea(
                            child: Stack(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                        height: 200,
                                        padding: const EdgeInsets.all(0.0),
                                        margin: EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        decoration: BoxDecoration(
                                            //color: header,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/f7.jpg'),
                                                fit: BoxFit.cover)),
                                        child: null),
                                    Container(
                                        height: 200,
                                        padding: const EdgeInsets.all(0.0),
                                        margin: EdgeInsets.only(
                                            top: 15, left: 15, right: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                        ),
                                        child: null),
                                  ],
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 0, top: 135),
                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                    padding: EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      radius: 65.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          "${conList.user.profilePic}"),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[300], // border color
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: Text(
                                "${conList.user.firstName} ${conList.user.lastName}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Oswald",
                                    color: Colors.black),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "${conList.user.jobTitle}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Oswald"),
                              )),
                          // Container(
                          //   margin: EdgeInsets.only(top: 5),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 15, top: 15, right: 5),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: header.withOpacity(0.8),
                          //               border:
                          //                   Border.all(width: 0.5, color: header),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.label_important,
                          //                 color: Colors.white,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Timeline",
                          //                   style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 5, top: 15),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.info_outline,
                          //                 color: Colors.black,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "About",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 15, top: 15),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.group,
                          //                 color: Colors.black,
                          //                 size: 17,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Friends",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 15, top: 10, right: 5),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.photo,
                          //                 color: Colors.black,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Photos",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 5, top: 10),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.event_available,
                          //                 color: Colors.black,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Events",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 15, top: 10),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.more_horiz,
                          //                 color: Colors.black,
                          //                 size: 17,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "More",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 30, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 0),
                                            height: 50,
                                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.chat,
                                              color: header,
                                            ),
                                            decoration: new BoxDecoration(
                                              color: header, // border color
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 0),
                                            height: 50,
                                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                            padding: EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.chat,
                                              color: header,
                                            ),
                                            decoration: new BoxDecoration(
                                              color: sub_white.withOpacity(
                                                  0.7), // border color
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text("Message",
                                          style: TextStyle(
                                              color: header,
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                widget.no == 1
                                    ? Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                _showLogoutDialog();
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 0),
                                                height: 50,
                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                padding: EdgeInsets.all(10.0),
                                                child: Icon(
                                                  widget.no == 1
                                                      ? Icons.done
                                                      : Icons.send,
                                                  color: Colors.black38,
                                                  size: 15,
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[
                                                      300], // border color
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Text(
                                                widget.no == 1
                                                    ? "Accept request"
                                                    : "Send request",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontFamily: "Oswald",
                                                    fontSize: 13))
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 0),
                                        height: 50,
                                        //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                        padding: EdgeInsets.all(10.0),
                                        child: Icon(
                                          widget.no == 1
                                              ? Icons.close
                                              : Icons.edit,
                                          color: Colors.black38,
                                          size: 15,
                                        ),
                                        decoration: new BoxDecoration(
                                          color:
                                              Colors.grey[300], // border color
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                                widget.no == 1
                                                    ? "Delete request"
                                                    : "Unfriend",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontFamily: "Oswald",
                                                    fontSize: 12)),
                                          ),
                                          widget.no == 1
                                              ? Container()
                                              : Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.black,
                                                  size: 14,
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 0),
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
                                  border:
                                      Border.all(width: 0.5, color: header))),
                          //////// <<<<<< Basic Info start >>>>> ////////
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(top: 15, left: 20),
                                    child: Text(
                                      "Basic Information",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
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
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.email,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Email : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: conList.user.jobTitle !=
                                                          null
                                                      ? ' ${conList.user.email}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.work,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Work Type : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: conList.user.dayJob !=
                                                          null
                                                      ? ' ${conList.user.dayJob}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.account_box,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Gender : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: conList.user.gender !=
                                                          null
                                                      ? ' ${conList.user.gender}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.location_on,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Country Name : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: " ${conList.user.country}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.account_circle,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Member Type : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: conList.user.userType != null
                                                ? ' ${conList.user.userType}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 0),
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
                                  border:
                                      Border.all(width: 0.5, color: header))),
                          // Container(
                          //     alignment: Alignment.center,
                          //     width: MediaQuery.of(context).size.width,
                          //     padding: EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //         color: header.withOpacity(0.8),
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(5))),
                          //     margin: EdgeInsets.all(15),
                          //     child: Text("Edit Public Details",
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontFamily: "Oswald",
                          //             fontWeight: FontWeight.w300,
                          //             fontSize: 16))),

                          // Container(
                          //     width: 50,
                          //     margin: EdgeInsets.only(
                          //         top: 25, left: 25, right: 25, bottom: 0),
                          //     decoration: BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(15.0)),
                          //         color: header,
                          //         boxShadow: [
                          //           BoxShadow(
                          //             blurRadius: 1.0,
                          //             color: header,
                          //             //offset: Offset(6.0, 7.0),
                          //           ),
                          //         ],
                          //         border: Border.all(width: 0.5, color: header))),
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text("Friends",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 20)),
                          //           Text(
                          //             "All Friends",
                          //             style: TextStyle(color: header, fontSize: 17),
                          //           )
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 3),
                          //         child: Text(
                          //           "250 Friends",
                          //           style: TextStyle(color: Colors.black54, fontSize: 15),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // // Container(
                          // //     alignment: Alignment.center,
                          // //     width: MediaQuery.of(context).size.width,
                          // //     padding: EdgeInsets.all(10),
                          // //     decoration: BoxDecoration(
                          // //         color: Colors.grey.withOpacity(0.2),
                          // //         borderRadius: BorderRadius.all(Radius.circular(5))),
                          // //     margin: EdgeInsets.all(10),
                          // //     child: Text("See All Friends",
                          // //         style: TextStyle(
                          // //             color: Colors.black,
                          // //             fontWeight: FontWeight.bold,
                          // //             fontSize: 16))),
                          // Container(
                          //     height: 2,
                          //     margin: EdgeInsets.only(top: 10, bottom: 20),
                          //     child: Divider(
                          //       color: Colors.grey[300],
                          //     )),
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text("Photos",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 20)),
                          //           Text(
                          //             "See Photos",
                          //             style: TextStyle(color: header, fontSize: 17),
                          //           )
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 3),
                          //         child: Text(
                          //           "12 Albums",
                          //           style: TextStyle(color: Colors.black54, fontSize: 15),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //     height: 2,
                          //     margin: EdgeInsets.only(top: 10, bottom: 20),
                          //     child: Divider(
                          //       color: Colors.grey[300],
                          //     )),
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text("Events",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 20)),
                          //           Text(
                          //             "See Events",
                          //             style: TextStyle(color: header, fontSize: 17),
                          //           )
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 3),
                          //         child: Text(
                          //           "3 Events This Week",
                          //           style: TextStyle(color: Colors.black54, fontSize: 15),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //     height: 2,
                          //     margin: EdgeInsets.only(top: 10, bottom: 20),
                          //     child: Divider(
                          //       color: Colors.grey[300],
                          //     )),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            //color: sub_white,
                            child: Container(
                              //color: Colors.white,

                              child: Column(
                                children: <Widget>[
                                  //////// <<<<<< Interest start >>>>> ////////
                                  Container(
                                      child: Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20),
                                          child: Text(
                                            "Interests",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  color: Colors.black,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Colors.black,
                                                      //offset: Offset(6.0, 7.0),
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.black)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  top: 0, left: 20, bottom: 0),
                                              child: Text(
                                                conList.user.interestLists
                                                            .length ==
                                                        0
                                                    ? "No interests"
                                                    : conList.user.interestLists
                                                                .length ==
                                                            1
                                                        ? "${conList.user.interestLists.length} interest"
                                                        : "${conList.user.interestLists.length} interests",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      ),
                                    ],
                                  )),

                                  ///// <<<<< Selected Interest start >>>>> //////
                                  conList.user.interestLists.length != 0
                                      ? Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.only(left: 20),
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 15, left: 0),
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: conList
                                                .user.interestLists.length,
                                            //separatorBuilder: (context, index) => Divider(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  margin: EdgeInsets.only(
                                                      left: 0,
                                                      right: 5,
                                                      top: 8,
                                                      bottom: 8),
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "${conList.user.interestLists[index].tag}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ],
                                                  ));
                                            },
                                          ),
                                        )
                                      : Container(),

                                  ////// <<<<< Selected Interest end >>>>> //////
                                  Container(
                                      width: 50,
                                      margin: EdgeInsets.only(
                                          top: 20,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: header,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1.0,
                                              color: header,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: header))),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20),
                                          child: Text(
                                            "Connections",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            margin: EdgeInsets.only(
                                                top: 10, left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                color: Colors.black,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black,
                                                    //offset: Offset(6.0, 7.0),
                                                  ),
                                                ],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 20, bottom: 0),
                                              child: Text(
                                                conList.res.length == 1
                                                    ? "${conList.res.length} connection"
                                                    : "${conList.res.length} connections",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => GroupAddPage()));
                                            },
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.only(
                                                    top: 12,
                                                    right: 20,
                                                    bottom: 0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "See all",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: header,
                                                          fontSize: 13,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 3),
                                                      child: Icon(
                                                          Icons.chevron_right,
                                                          color: header,
                                                          size: 17),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    )),
                    SliverPadding(
                      padding: EdgeInsets.only(right: 20, left: 5),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120.0,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => HotelSearchPage()),
                              // );
                            },
                            child: new Container(
                              margin: EdgeInsets.only(
                                  left: 15, right: 0, top: 5, bottom: 10),
                              padding: EdgeInsets.only(left: 0),
                              height: 100,
                              width: 90,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(CallApi().picUrl +
                                      "${conList.res[index].profilePic}"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(.5),
                                    //offset: Offset(6.0, 7.0),
                                  ),
                                ],
                                // border: Border.all(width: 0.2, color: Colors.grey)
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 0),
                                      padding: EdgeInsets.only(left: 0),
                                      height: 110,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      )),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "${conList.res[index].firstName} ${conList.res[index].lastName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }, childCount: conList.res.length),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Container(
                    //           width: 50,
                    //           margin: EdgeInsets.only(
                    //               top: 20, left: 25, right: 25, bottom: 20),
                    //           decoration: BoxDecoration(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(15.0)),
                    //               color: header,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 1.0,
                    //                   color: header,
                    //                   //offset: Offset(6.0, 7.0),
                    //                 ),
                    //               ],
                    //               border: Border.all(width: 0.5, color: header))),
                    //     ],
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: EdgeInsets.only(right: 20, left: 5),
                    //   sliver: SliverGrid(
                    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //       maxCrossAxisExtent: 200.0,
                    //       mainAxisSpacing: 0.0,
                    //       crossAxisSpacing: 0.0,
                    //       childAspectRatio: 1.0,
                    //     ),
                    //     delegate: SliverChildBuilderDelegate(
                    //         (BuildContext context, int index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(
                    //           //   context,
                    //           //   MaterialPageRoute(
                    //           //       builder: (context) => HotelSearchPage()),
                    //           // );
                    //         },
                    //         child: new Container(
                    //           margin: EdgeInsets.only(
                    //               left: 15, right: 0, top: 5, bottom: 10),
                    //           padding: EdgeInsets.only(left: 0),
                    //           height: 100,
                    //           width: 100,
                    //           decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //               image: index == 0
                    //                   ? AssetImage("assets/images/f6.jpg")
                    //                   : AssetImage("assets/images/f7.jpg"),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //             color: Colors.white,
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 blurRadius: 3.0,
                    //                 color: Colors.black.withOpacity(.5),
                    //                 //offset: Offset(6.0, 7.0),
                    //               ),
                    //             ],
                    //             // border: Border.all(width: 0.2, color: Colors.grey)
                    //           ),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               Container(
                    //                   margin: EdgeInsets.only(left: 0),
                    //                   padding: EdgeInsets.only(left: 0),
                    //                   height: 160,
                    //                   width: 170,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black.withOpacity(0.3),
                    //                     borderRadius:
                    //                         BorderRadius.all(Radius.circular(5.0)),
                    //                   )),
                    //               Container(
                    //                   alignment: Alignment.bottomLeft,
                    //                   margin: EdgeInsets.only(
                    //                       top: 10, left: 10, bottom: 5),
                    //                   child: Text(
                    //                     index == 0 ? "Photos" : "Events",
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontSize: 20,
                    //                         fontFamily: 'Oswald',
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     }, childCount: 2),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  margin: EdgeInsets.only(
                                      top: 15, left: 25, right: 25, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      color: header,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1.0,
                                          color: header,
                                          //offset: Offset(6.0, 7.0),
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 0.5, color: header))),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 15, left: 20),
                              child: Text(
                                "Timeline",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
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
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return loading == false
                            ? Container(
                                padding: EdgeInsets.only(top: 5, bottom: 10),
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
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 20, right: 20),
                                child: Column(
                                  children: <Widget>[
                                    ////// <<<<< Name, interesst start >>>>> //////
                                    Container(
                                      //color: Colors.yellow,
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 10,
                                          top: 10),
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ////// <<<<< pic start >>>>> //////
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                            padding: EdgeInsets.all(1.0),
                                            child: CircleAvatar(
                                              radius: 20.0,
                                              backgroundColor: Colors.white,
                                              backgroundImage: statusPic == null
                                                  ? AssetImage(
                                                      "assets/images/man2.jpg")
                                                  : NetworkImage(CallApi()
                                                          .picUrl1 +
                                                      "${postList.res[index].fuser.profilePic}"),
                                            ),
                                            decoration: new BoxDecoration(
                                              color: Colors
                                                  .grey[300], // border color
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          ////// <<<<< pic end >>>>> //////

                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ////// <<<<< name Interest start >>>>> //////
                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            postList.res[index]
                                                                        .interest ==
                                                                    null
                                                                ? "${postList.res[index].fuser.firstName} ${postList.res[index].fuser.lastName}"
                                                                : "${postList.res[index].fuser.firstName} ${postList.res[index].fuser.lastName} - ",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                              postList.res[index]
                                                                          .interest ==
                                                                      null
                                                                  ? ""
                                                                  : "${postList.res[index].interest}",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: header,
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  ////// <<<<< name Interest end >>>>> //////

                                                  ////// <<<<< time job start >>>>> //////
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 3),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            index % 2 == 0
                                                                ? "6 hr"
                                                                : "Aug 7 at 5:34 PM",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Icon(
                                                                  Icons.album,
                                                                  size: 10,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "  ${postList.user.jobTitle}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          header,
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                  ////// <<<<< time job end >>>>> //////
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    ////// <<<<< Name, interesst end >>>>> //////
                                    Container(
                                        margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 10,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            ////// <<<<< Status start >>>>> //////
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                postList.res[index].status ==
                                                        null
                                                    ? ""
                                                    : "${postList.res[index].status}",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),

                                            ////// <<<<< Status end >>>>> //////

                                            ////// <<<<< Picture Start >>>>> //////
                                            postList.res[index].images.length ==
                                                    0
                                                ? Container()
                                                : postList.res[index].images
                                                            .length ==
                                                        1
                                                    ? Container(
                                                        //color: Colors.red,
                                                        height: 200,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        margin:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    "${allPic[0]}"),
                                                                fit: BoxFit
                                                                    .cover)),
                                                        child: null)
                                                    : Container(
                                                        height: postList
                                                                    .res[index]
                                                                    .images
                                                                    .length <=
                                                                3
                                                            ? 120
                                                            : 240,
                                                        child: GridView.builder(
                                                          //semanticChildCount: 2,
                                                          gridDelegate:
                                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                                            maxCrossAxisExtent:
                                                                150.0,
                                                            mainAxisSpacing:
                                                                0.0,
                                                            crossAxisSpacing:
                                                                0.0,
                                                            childAspectRatio:
                                                                1.0,
                                                          ),
                                                          //crossAxisCount: 2,
                                                          itemBuilder: (BuildContext
                                                                      context,
                                                                  int indexes) =>
                                                              new Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Container(
                                                              height: 150,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width:
                                                                          0.1,
                                                                      color: Colors
                                                                          .grey),
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          "${allPic[indexes]}"))),
                                                            ),
                                                          ),
                                                          itemCount: postList
                                                              .res[index]
                                                              .images
                                                              .length,
                                                        ),
                                                      ),
                                          ],
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 0,
                                            top: 10),
                                        child: Divider(
                                          color: Colors.grey[400],
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(left: 20, top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  if (postList
                                                          .res[index].like !=
                                                      null) {
                                                    setState(() {
                                                      postList.res[index].like =
                                                          null;
                                                    });
                                                    likeButtonPressed(index, 0);
                                                  } else {
                                                    setState(() {
                                                      postList.res[index].like =
                                                          1;
                                                    });
                                                    likeButtonPressed(index, 1);
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: Icon(
                                                    postList.res[index].like !=
                                                            null
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    size: 20,
                                                    color: postList.res[index]
                                                                .like !=
                                                            null
                                                        ? Colors.redAccent
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 3),
                                                child: Text(
                                                    postList.res[index].meta
                                                                .totalLikesCount ==
                                                            null
                                                        ? ""
                                                        : "${postList.res[index].meta.totalLikesCount}",
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black54,
                                                        fontSize: 12)),
                                              )
                                            ],
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 15),
                                                  padding: EdgeInsets.all(3.0),
                                                  child: Icon(
                                                    Icons.chat_bubble_outline,
                                                    size: 20,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 3),
                                                  child: Text(
                                                      postList.res[index].meta
                                                                  .totalCommentsCount ==
                                                              null
                                                          ? ""
                                                          : "${postList.res[index].meta.totalCommentsCount}",
                                                      style: TextStyle(
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black54,
                                                          fontSize: 12)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                padding: EdgeInsets.all(3.0),
                                                child: Icon(
                                                  Icons.send,
                                                  size: 20,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 3),
                                                child: Text(
                                                    postList.res[index].meta
                                                                .totalSharesCount ==
                                                            null
                                                        ? ""
                                                        : "${postList.res[index].meta.totalSharesCount}",
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black54,
                                                        fontSize: 12)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
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
                                margin: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 20, right: 20),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          //color: Colors.red,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 0),
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                padding: EdgeInsets.all(1.0),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[400],
                                                  highlightColor:
                                                      Colors.grey[200],
                                                  child: CircleAvatar(
                                                    radius: 20.0,
                                                    //backgroundColor: Colors.white,
                                                  ),
                                                ),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Shimmer.fromColors(
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                    child: Container(
                                                      width: 100,
                                                      height: 22,
                                                      child: Container(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 3),
                                                    child: Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[400],
                                                      highlightColor:
                                                          Colors.grey[200],
                                                      child: Container(
                                                        width: 50,
                                                        height: 12,
                                                        child: Container(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 20,
                                                bottom: 0),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[400],
                                              highlightColor: Colors.grey[200],
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 10,
                                                child: Container(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 2,
                                                bottom: 5),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[400],
                                              highlightColor: Colors.grey[200],
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                height: 10,
                                                child: Container(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                      }, childCount: postList.res.length),
                    ),
                  ],
                ),
              ));
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${postList.res[index].id}',
      'type': type,
      'uid': '${postList.res[index].userId}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/like');
    var body = json.decode(res.body);

    print(body);
    //   if(body['success']){
    //   //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   //   localStorage.remove('user');
    //   //   localStorage.setString('user', json.encode(body['user']));
    //   //  _showDialog('Information has been saved successfully!');
    //   print(body);

    //   }else{
    //     print('user is not updated');
    //   }

    setState(() {
      //_isLoading = false;
    });
  }
}
