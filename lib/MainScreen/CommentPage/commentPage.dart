import 'dart:async';
import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CommentModel/commentModel.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/MainScreen/ReplyPage/replyPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

List<String> isDeleted = [];

class CommentPage extends StatefulWidget {
  final feedId;
  CommentPage(this.feedId);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var comList;
  var userData;
  bool loading = true, isSubmit = false;
  TextEditingController comEditor = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  String com = "", totalLike = "";
  @override
  void initState() {
    _getUserInfo();
    loadComments();
    //print(widget.feedId);
    super.initState();
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }

  Future loadComments() async {
    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      loading = true;
    });
    var comresponse =
        await CallApi().getData('load/prev-com/${widget.feedId}?comid=1');
    var postcontent = comresponse.body;
    final comments = json.decode(postcontent);
    var comdata = AllCommentsModel.fromJson(comments);

    setState(() {
      comList = comdata;
      loading = false;
      totalLike = "1";
    });
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });

    //print("${userData['shop_id']}");
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
                        "Comments",
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
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            loading
                ? Center(
                    child: Container(
                      child: Text(
                        "Please Wait...",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                : comList.comments.length == 0
                    ? Center(
                        child: Container(
                          child: Text(
                            "No Comments",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    : CustomScrollView(
                        slivers: <Widget>[
                          Container(
                              child: CreatePostCard(
                                  comList.comments, widget.feedId, userData)),
                        ],
                      ),

            ///// <<<<< Comment field start >>>>> //////

            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        ////// <<<<< Comment Box Text Field >>>>> //////
                        Flexible(
                          child: Container(
                            //height: 100,
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(
                                top: 5, left: 10, bottom: 5, right: 10),
                            decoration: BoxDecoration(
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(100.0)),
                                borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                                color: Colors.grey[100],
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.black.withOpacity(0.2))),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: new ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 120.0,
                                    ),
                                    child: new SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      reverse: true,
                                      child: new TextField(
                                        maxLines: null,
                                        autofocus: false,
                                        controller: comEditor,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Type a comment here...",
                                          hintStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 20.0, 10.0),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            com = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< Comment Send Icon Button >>>>> //////
                        GestureDetector(
                          onTap: () {
                            commentButton();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: back,
                                borderRadius: BorderRadius.circular(25)),
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.send,
                              color: header,
                              size: 23,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///// <<<<< Comment field end >>>>> //////
          ],
        ),
      ),
      //bottomNavigationBar:
    );
  }

  void commentButton() {
    if (comEditor.text.isEmpty) {
      return _showMsg("Comment field is empty");
    } else {
      commentSend();
    }
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

  Future commentSend() async {
    setState(() {
      isSubmit = true;
    });

    var data = {
      'comment': comEditor.text,
      'status_id': widget.feedId,
      'id': null,
      'isEdit': false,
    };

    var res = await CallApi().postData1(data, 'add/comment');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      comEditor.text = "";
    } else if (body['success'] == false) {
      print(body['errorMessage']);
      _showMsg(body['errorMessage']);
    }

    setState(() {
      isSubmit = false;
    });

    loadComments();
  }
}

class CreatePostCard extends StatefulWidget {
  final comList;
  final statusID;
  final userData;
  CreatePostCard(this.comList, this.statusID, this.userData);

  @override
  CreatePostCardState createState() => CreatePostCardState();
}

class CreatePostCardState extends State<CreatePostCard> {
  String theme = "", comment = "";
  int totalLike, idx = -1;
  bool loading = true;
  bool isEdit = false;
  bool isSubmit = false;
  TextEditingController editingController = new TextEditingController();

  @override
  void initState() {
    //timerCheck();
    //print(widget.comList);
    // for (int i = 0; i < widget.comList.length; i++) {
    //   editingController.text = widget.comList[i].comment;
    //   // comment = widget.comList[i].comment;
    //   // print(widget.comList[i]);
    // }

    super.initState();
  }

  void _statusModalBottomSheet(context, int index, var userData, var feed) {
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
                    setState(() {
                      isEdit = true;
                    }),
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
                      {Navigator.pop(context), _showDeleteDialog(feed.id)},
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

    var res = await CallApi().postData1(data, 'delete-comment');
    var body = json.decode(res.body);

    print(body);

    if (body == 1) {
      setState(() {
        isDeleted.add("$id");
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDeleted);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  void commentButton(int comID) {
    if (editingController.text.isEmpty) {
      return _showMsg("Comment field is empty");
    } else {
      commentSend(comID);
    }
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

  Future commentSend(int comId) async {
    setState(() {
      isSubmit = true;
    });

    var data = {
      'comment': editingController.text,
      'status_id': widget.statusID,
      'id': comId,
      'isEdit': true,
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/comment');
    var body = json.decode(res.body);
    print(body);

    if (body == "1" || body == 1) {
      setState(() {});
    } else {
      _showMsg("Something went wrong!");
    }
    // if (body['success'] == true) {
    //   editingController.text = "";
    // } else if (body['success'] == false) {
    //   print(body['errorMessage']);
    //   _showMsg(body['errorMessage']);
    // }

    setState(() {
      isSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverPadding(
        padding: EdgeInsets.only(bottom: 40),
        sliver: SliverList(
          delegate:
              (SliverChildBuilderDelegate((BuildContext context, int index) {
            return isDeleted.contains("${widget.comList[index].id}")
                ? Container()
                : Container(
                    padding: EdgeInsets.only(top: 0, bottom: 5),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(15),
                    //   //border: Border.all(width: 0.8, color: Colors.grey[300]),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       blurRadius: 1.0,
                    //       color: Colors.black38,
                    //       //offset: Offset(6.0, 7.0),
                    //     ),
                    //   ],
                    // ),
                    margin:
                        EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              widget.userData['id'] !=
                                      widget.comList[index].user.id
                                  ? Container(
                                    margin: EdgeInsets.only(top: 10),
                                  )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (idx == -1) {
                                            _statusModalBottomSheet(
                                                context,
                                                index,
                                                widget.userData,
                                                widget.comList[index]);
                                            comment =
                                                widget.comList[index].comment;
                                            editingController.text =
                                                widget.comList[index].comment;
                                            idx = index;
                                          }
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 15),
                                          // color: Colors.blue,
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.black54,
                                          )),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                          padding: EdgeInsets.only(right: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ////// <<<<< pic start >>>>> //////
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(1.0),
                                child: CircleAvatar(
                                  radius: 15.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: widget.comList[index].user
                                                  .profilePic ==
                                              "" ||
                                          widget.comList[index].user
                                                  .profilePic ==
                                              null
                                      ? AssetImage("assets/images/man2.jpg")
                                      : NetworkImage(CallApi().picUrl +
                                          "${widget.comList[index].user.profilePic}"),
                                ),
                                decoration: new BoxDecoration(
                                  color: Colors.grey[300],
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
                                      ////// <<<<< Name start >>>>> //////
                                      Container(
                                        child: Text(
                                          "${widget.comList[index].user.firstName} ${widget.comList[index].user.lastName}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: header,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                      ////// <<<<< Name end >>>>> //////
                                      Container(
                                          margin: EdgeInsets.only(
                                            left: 0,
                                            right: 20,
                                            top: 3,
                                          ),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: idx == index &&
                                                    isEdit == true
                                                ? Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Flexible(
                                                          child:
                                                              new ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: 120.0,
                                                            ),
                                                            child:
                                                                new SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              reverse: true,
                                                              child:
                                                                  new TextField(
                                                                maxLines: null,
                                                                autofocus: true,
                                                                controller:
                                                                    editingController,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Type a comment here...",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                  contentPadding:
                                                                      EdgeInsets.fromLTRB(
                                                                          0.0,
                                                                          10.0,
                                                                          20.0,
                                                                          10.0),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    comment =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                onTap: () {
                                                                  commentButton(widget
                                                                      .comList[
                                                                          index]
                                                                      .id);
                                                                  widget
                                                                      .comList[
                                                                          index]
                                                                      .comment = comment;
                                                                  isEdit =
                                                                      false;
                                                                  idx = -1;
                                                                },
                                                                child: Container(
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            10),
                                                                    child: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color:
                                                                            header,
                                                                        size:
                                                                            18)),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isEdit =
                                                                        false;
                                                                    idx = -1;
                                                                  });
                                                                },
                                                                child: Container(
                                                                    child: Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .redAccent,
                                                                        size:
                                                                            18)),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    child: Text(
                                                      "${widget.comList[index].comment}",
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontFamily: "OSwald",
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                          )),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 0, top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 0),
                                              child: Text("6h ago",
                                                  style: TextStyle(
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black54,
                                                      fontSize: 12)),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (widget
                                                                .comList[index]
                                                                .like !=
                                                            null) {
                                                          setState(() {
                                                            widget
                                                                .comList[index]
                                                                .like = null;
                                                            print(widget
                                                                .comList[index]
                                                                .replay
                                                                .totalLikeCount);
                                                            widget
                                                                .comList[index]
                                                                .replay
                                                                .totalLikeCount -= 1;
                                                            print(widget
                                                                .comList[index]
                                                                .replay
                                                                .totalLikeCount);
                                                          });
                                                          likeButtonPressed(
                                                              index, 0);
                                                        } else {
                                                          setState(() {
                                                            widget
                                                                .comList[index]
                                                                .like = 1;
                                                            print(widget
                                                                .comList[index]
                                                                .replay
                                                                .totalLikeCount);
                                                            widget
                                                                .comList[index]
                                                                .replay
                                                                .totalLikeCount += 1;
                                                            print(widget
                                                                .comList[index]
                                                                .replay
                                                                .totalLikeCount);
                                                          });
                                                          likeButtonPressed(
                                                              index, 1);
                                                        }
                                                      },
                                                      child: Icon(
                                                        widget.comList[index]
                                                                    .like ==
                                                                null
                                                            ? Icons
                                                                .favorite_border
                                                            : Icons.favorite,
                                                        size: 20,
                                                        color: widget
                                                                    .comList[
                                                                        index]
                                                                    .like ==
                                                                null
                                                            ? Colors.black54
                                                            : Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    child: Text(
                                                        "${widget.comList[index].replay.totalLikeCount}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReplyPage(
                                                              widget.comList[
                                                                  index],
                                                              widget.statusID)),
                                                );
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      child: Icon(
                                                        Icons
                                                            .chat_bubble_outline,
                                                        size: 20,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 3),
                                                      child: Text(
                                                          "${widget.comList[index].replay.totalReplyCount}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      widget.comList[index].replay
                                                  .totalReplyCount ==
                                              0
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReplyPage(
                                                                widget.comList[
                                                                    index],
                                                                widget
                                                                    .statusID)));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("View replies...",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ),

                                      Divider()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          }, childCount: widget.comList.length)),
        ),
      ),
    );
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${widget.comList[index].id}',
      'type': type,
      'status_id': '${widget.comList[index].statusId}',
      'uid': '${widget.comList[index].userId}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/com/like');
    var body = json.decode(res.body);

    print(body);

    setState(() {
      //_isLoading = false;
    });
  }
}
