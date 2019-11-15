import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/MyDayCard/myDayCard.dart';
import 'package:chatapp_new/Cards/PostCard/postCard.dart';
import 'package:chatapp_new/JSON_Model/Feed_post_Model/feedPost_model.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:chatapp_new/MainScreen/EditPostPage/editPostPage.dart';
import 'package:chatapp_new/MainScreen/FeedStatusEditPage/feedStatusEditPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import '../../../main.dart';

List<String> isDelete = [];
int cc = 0;

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String theme = "", pic = "";
  bool loading = true;
  var userData;
  //var postList;
  List<String> tagList = [];
  bool _isLoading = true;
  int id = 0;
  String proPic = "", statusPic = "";
  int likeCount;
  SocketIOManager manager;
  bool likePressed = false;
  //bool loading = true;
  List<String> allPic = [];
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _getUserInfo();
    print(pageDirect);
    super.initState();
  }

  void _getUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });

    print(userData);

    var shop = "${userData['shop_id']}";

    if (userData['interests'] != null) {
      for (int i = 0; i < userData['interests'].length; i++) {
        tagList.add(userData['interests'][i]['tag']);
      }
    }

    SharedPreferences localStorage1 = await SharedPreferences.getInstance();
    localStorage1.setString('shop_id', shop);
    localStorage1.setStringList('tags', tagList.toList());
    pic = userData['profilePic'];
    id = userData['id'];

    if (pic.contains("localhost")) {
      pic = pic.replaceAll("localhost:3010/", "https://mobile.tradelounge.co/");
      pic = pic.replaceAll("localhost:8080/", "https://mobile.tradelounge.co/");
    } else {
      //pic = "http://10.0.2.2:3010" + pic;
    }

    print(pic);

    loadPosts();
  }

  Future loadPosts() async {
    //await Future.delayed(Duration(seconds: 3));
    if (page1 == 0) {
      var postresponse =
          await CallApi().getData('feed?sid=1&llid=1&lcid=1&lsid=1');
      var postcontent = postresponse.body;
      final posts = json.decode(postcontent);
      var postdata = FeedPost.fromJson(posts);

      setState(() {
        postList = postdata;
        page1 = 1;
      });

      for (int i = 0; i < postList.feed.length; i++) {
        proPic = postList.feed[i].fuser.profilePic;
        if (proPic.contains("localhost")) {
          setState(() {
            proPic = proPic.replaceAll("localhost", "http://10.0.2.2");
          });
        } else {
          setState(() {
            proPic = "http://10.0.2.2:3010" + proPic;
          });
        }
        // print(widget.feed[i].fuser.profilePic);
        // int proid = widget.feed[i].fuser.id;
        // print(proid);
      }

      for (int i = 0; i < postList.feed.length; i++) {
        for (int j = 0; j < postList.feed[i].images.length; j++) {
          statusPic = postList.feed[i].images[j].thum;
          if (statusPic.contains("localhost")) {
            statusPic = statusPic.replaceAll("localhost", "http://10.0.2.2");
            allPic.add(statusPic);
          }
          // if (!statusPic.contains("localhost")) {
          //   statusPic = "http://10.0.2.2:3010" + statusPic;
          // }

        }
      }
    }

    setState(() {
      _isLoading = false;
    });
    //print(page1);
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
      // print(data);
      // sendMessage(identifier);
      // socket.emit("send-request", [
      //   {"msg": "new message"}
      // ]);
    });

    socket.on("receive_friend_request_user_29", (data) {
      print("response");
      print(data);
    });
    socket.connect();

    //sockets[driverId.toString()] = socket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: postList == null
              ? PostLoaderCard()
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  //header: WaterDropMaterialHeader(),
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      page1 = 0;
                    });
                    //print(page1);
                    loadPosts();
                    _refreshController.refreshCompleted();
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            ////// <<<<< Status/Photo post >>>>> //////
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  ////// <<<<< Profile >>>>> //////
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  //FriendsProfilePage("prabal23")),
                                                  MyProfilePage(userData)));
                                    },
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 0, left: 15),
                                            padding: EdgeInsets.all(1.0),
                                            child: CircleAvatar(
                                              radius: 21.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: pic == "" ||
                                                      pic == null
                                                  ? AssetImage(
                                                      'assets/images/man.png')
                                                  : NetworkImage("$pic"),
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
                                              backgroundColor:
                                                  Colors.greenAccent,
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
                                                builder: (context) =>
                                                    CreatePost(userData)));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(bottom: 10, top: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    border: Border.all(
                                                        color: Colors.grey[200],
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25))),
                                                child: TextField(
                                                  enabled: false,
                                                  //controller: phoneController,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Oswald',
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "What's in your mind?",
                                                    hintStyle: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                    //labelStyle: TextStyle(color: Colors.white70),
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
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
                                            builder: (context) =>
                                                CreatePost(userData)),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: back,
                                          border: Border.all(
                                              color: Colors.grey[100],
                                              width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(25)),
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

                            ////// <<<<< Divider 1 >>>>> //////
                            Container(
                                width: 50,
                                margin: EdgeInsets.only(
                                    top: 10, left: 25, right: 25, bottom: 15),
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

                            //Text(pageDirect),
                            //My Day card
                            //MydayCard(),

                            ////// <<<<< Divider 2 >>>>> //////
                            // Container(
                            //     width: 50,
                            //     margin: EdgeInsets.only(
                            //         top: 5, left: 25, right: 25, bottom: 10),
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
                            //         border:
                            //             Border.all(width: 0.5, color: header))),
                          ],
                        ),
                      ),

                      //Posts card
                      CreatePostCard(postList.feed, userData, id)
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class CreatePostCard extends StatefulWidget {
  final feed;
  final userData;
  final uid;
  CreatePostCard(this.feed, this.userData, this.uid);
  @override
  CreatePostCardState createState() => CreatePostCardState();
}

class CreatePostCardState extends State<CreatePostCard> {
  SharedPreferences sharedPreferences;
  String theme = "", proPic = "", statusPic = "";
  int likeCount = 0;

  bool likePressed = false;
  //bool loading = true;
  List<String> allPic = [];
  List likes = [];

  @override
  void initState() {
    for (int i = 0; i < widget.feed.length; i++) {
      proPic = widget.feed[i].fuser.profilePic;
      // if (proPic.contains("localhost")) {
      //   setState(() {
      //     widget.feed[i].fuser.profilePic = widget.feed[i].fuser.profilePic
      //         .replaceAll("localhost:3010/", "https://mobile.tradelounge.co/");
      //         widget.feed[i].fuser.profilePic = widget.feed[i].fuser.profilePic
      //         .replaceAll("localhost:8080/", "https://mobile.tradelounge.co/");
      //   });
      //   print("widget.feed[i].fuser.profilePic");
      //   print(widget.feed[i].fuser.profilePic);
      // } else {
      //   setState(() {
      //     widget.feed[i].fuser.profilePic =
      //         "https://mobile.tradelounge.co/" + widget.feed[i].fuser.profilePic;
      //   });
      // }
      // print(widget.feed[i].fuser.profilePic);
      // int proid = widget.feed[i].fuser.id;
      // print(proid);
    }

    for (int i = 0; i < widget.feed.length; i++) {
      for (int j = 0; j < widget.feed[i].images.length; j++) {
        statusPic = widget.feed[i].images[j].thum;
        //print(statusPic);
        if (statusPic.contains("localhost")) {
          widget.feed[i].images[j].thum = widget.feed[i].images[j].thum
              .replaceAll("localhost", "http://10.0.2.2");
          statusPic = statusPic.replaceAll("localhost", "http://10.0.2.2");
          allPic.add(statusPic);
        }
        // if (!statusPic.contains("localhost")) {
        //   statusPic = "http://10.0.2.2:3010" + statusPic;
        // }
print(widget.feed[i].images[j].thum);
      }
    }
    super.initState();
  }

  void _statusModalBottomSheet(context, int index, var userData, var feeds) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                // Text('React to this post',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedStatusEditPost(
                                feeds, widget.userData, index)))
                  },
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  title: new Text('Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.redAccent,
                          fontFamily: "Oswald")),
                  onTap: () =>
                      {Navigator.pop(context), _showDeleteDialog(feeds.id)},
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showDeleteDialog(int id) async {
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
                    // Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: header, width: 1.5),
                    //         borderRadius: BorderRadius.circular(100),
                    //         color: Colors.white),
                    //     child: Icon(
                    //       Icons.done,
                    //       color: header,
                    //       size: 50,
                    //     )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Want to delete the post?",
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
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 5, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
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
                              setState(() {
                                Navigator.of(context).pop();
                                deleteStatus(id);
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
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

  Future deleteStatus(int id) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-status');
    var body = json.decode(res.body);

    if (body == 1) {
      setState(() {
        isDelete.add("$id");
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDelete);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return isDelete.contains("${widget.feed[index].id}")
              ? Container()
              : Container(
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
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          widget.uid == widget.feed[index].fuser.id
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _statusModalBottomSheet(context, index,
                                          widget.userData, widget.feed[index]);
                                      //print(widget.feed[index].id);
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      // color: Colors.blue,
                                      child: Icon(
                                        Icons.more_horiz,
                                        color: Colors.black54,
                                      )),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 10),
                                ),
                        ],
                      ),
                      Container(
                        //color: Colors.yellow,
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ////// <<<<< pic start >>>>> //////
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(1.0),
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.white,
                                backgroundImage: proPic == null
                                    ? AssetImage("assets/images/man2.jpg")
                                    : NetworkImage(
                                        "${widget.feed[index].fuser.profilePic}"),
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.grey[300], // border color
                                shape: BoxShape.circle,
                              ),
                            ),
                            ////// <<<<< pic end >>>>> //////

                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ////// <<<<< Name & Interest start >>>>> //////
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "${widget.feed[index].fuser.firstName} ${widget.feed[index].fuser.lastName}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                widget.feed[index].interest ==
                                                        null
                                                    ? ""
                                                    : " - ${widget.feed[index].interest}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: header,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    ////// <<<<< Name & Interest end >>>>> //////

                                    ////// <<<<< time job start >>>>> //////
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              index % 2 == 0
                                                  ? "6 hr"
                                                  : "Aug 7 at 5:34 PM",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.album,
                                                    size: 10,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    "  ${widget.feed[index].fuser.jobTitle}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: header,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400),
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
                                margin: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.feed[index].status == null
                                      ? ""
                                      : "${widget.feed[index].status}",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              ////// <<<<< Status end >>>>> //////

                              ////// <<<<< Picture Start >>>>> //////
                              widget.feed[index].images.length == 0
                                  ? Container()
                                  : widget.feed[index].images.length == 1
                                      ? Container(
                                          //color: Colors.red,
                                          height: 200,
                                          padding: const EdgeInsets.all(0.0),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: //AssetImage("assets/images/friend7.jpg"),
                                                      NetworkImage(
                                                          "${widget.feed[index].images[0].thum}"),
                                                  fit: BoxFit.cover)),
                                          child: null)
                                      : Container(
                                          height: widget.feed[index].images
                                                      .length <=
                                                  3
                                              ? 100
                                              : 200,
                                          child: GridView.builder(
                                            //semanticChildCount: 2,
                                            gridDelegate:
                                                SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 100.0,
                                              mainAxisSpacing: 0.0,
                                              crossAxisSpacing: 0.0,
                                              childAspectRatio: 1.0,
                                            ),
                                            //crossAxisCount: 2,
                                            itemBuilder: (BuildContext context,
                                                    int indexes) =>
                                                new Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 100,
                                                //width: 50,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.1,
                                                        color: Colors.grey),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${widget.feed[index].images[indexes].thum}"))),
                                              ),
                                            ),
                                            itemCount: widget
                                                .feed[index].images.length,
                                          ),
                                        ),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, bottom: 0, top: 10),
                          child: Divider(
                            color: Colors.grey[400],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(3.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.feed[index].like != null) {
                                        setState(() {
                                          widget.feed[index].like = null;
                                          // print(widget.feed[index].meta
                                          //     .totalLikesCount);
                                          // likeCount = widget
                                          //     .feed[index].meta.totalLikesCount;
                                          // //likeCount = likeCount - 1;
                                          // print(widget.feed[index].meta
                                          //     .totalLikesCount);
                                          // print("bfg $likeCount");

                                          widget.feed[index].meta
                                              .totalLikesCount = widget
                                                  .feed[index]
                                                  .meta
                                                  .totalLikesCount -
                                              1;
                                          //likes.insert(index, likeCount);
                                        });
                                        likeButtonPressed(index, 0);
                                        //print(likes);
                                      } else {
                                        setState(() {
                                          widget.feed[index].like = 1;
                                          // print(widget.feed[index].meta
                                          //     .totalLikesCount);
                                          // likeCount = widget
                                          //     .feed[index].meta.totalLikesCount;
                                          // likeCount = likeCount + 1;
                                          // print("bfg $likeCount");
                                          widget.feed[index].meta
                                              .totalLikesCount = widget
                                                  .feed[index]
                                                  .meta
                                                  .totalLikesCount +
                                              1;
                                          // likeCount = widget
                                          //     .feed[index].meta.totalLikesCount;
                                          // likeCount = likeCount + 1;
                                          //likes.insert(index, likeCount);
                                        });
                                        likeButtonPressed(index, 1);
                                        //print(likes);
                                      }
                                    },
                                    child: Container(
                                      child: Icon(
                                        widget.feed[index].like != null
                                            //likePressed == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 20,
                                        color: widget.feed[index].like != null
                                            //likePressed == true
                                            ? Colors.redAccent
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                      "${widget.feed[index].meta.totalLikesCount}",
                                      style: TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                          fontSize: 12)),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommentPage(widget.feed[index].id)),
                                );
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.chat_bubble_outline,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text(
                                          widget.feed[index].meta
                                                      .totalCommentsCount ==
                                                  null
                                              ? ""
                                              : "${widget.feed[index].meta.totalCommentsCount}",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.send,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                      widget.feed[index].meta
                                                  .totalSharesCount ==
                                              null
                                          ? ""
                                          : "${widget.feed[index].meta.totalSharesCount}",
                                      style: TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300,
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
                );

          ////// <<<<< Loader >>>>> //////
          //: PostLoaderCard();
        }, childCount: widget.feed.length),
      ),
    );
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });
    print("object");

    var data = {
      'id': '${widget.feed[index].id}',
      'type': type,
      'uid': '${widget.feed[index].userId}'
    };

    print(data);
    print("354353445345345");

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
