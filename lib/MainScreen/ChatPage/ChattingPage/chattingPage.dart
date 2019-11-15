import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/ChatBubbleCard/FriendChatBubbleCard/friendChatBubble.dart';
import 'package:chatapp_new/Cards/ChatBubbleCard/MyChatBubbleCard/myChatBubble.dart';
import 'package:chatapp_new/JSON_Model/ConversationModel/conversationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class ChattingPage extends StatefulWidget {
  final chat;
  final userData;
  ChattingPage(this.chat, this.userData);
  @override
  ChattingPageState createState() => new ChattingPageState();
}

class ChattingPageState extends State<ChattingPage> {
  String result = '', msg = '', date = '', st = '';
  bool loading = false;
  var convLists;
  int receiver = 0;

  TextEditingController msgController = new TextEditingController();
  //ScrollController _scrollController = new ScrollController();

  int selected;
  var now = new DateTime.now();
  DateTime _date = DateTime.now();
  List<String> messages = [];

  SharedPreferences sharedPreferences;
  String theme = "";
  ScrollController _scrollController;
  bool _isOnTop = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    if (widget.userData['id'] == widget.chat.reciever) {
      receiver = widget.chat.sender;
    } else {
      receiver = widget.chat.reciever;
    }
    setState(() {
      date = DateFormat("MMM dd, yyyy").format(now);
      //messages.add(date);
      //st = "1";
    });
    if (widget.chat.profilePic.contains("localhost")) {
      widget.chat.profilePic =
          widget.chat.profilePic.replaceAll("localhost", "http://10.0.2.2");
    } else {
      widget.chat.profilePic = "" + widget.chat.profilePic;
    }
    sharedPrefcheck();
    loadChatList();
    //_scrollToBottom();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

  _scrollToBottom(int index) async {
    _scrollController.animateTo(400.0*index,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    // setState(() => _isOnTop = false);
    // if (_scrollController.hasClients) {
    //   await _scrollController.animateTo(
    //     400.0*index,
    //     curve: Curves.easeIn,
    //     duration: const Duration(milliseconds: 300),
    //   );
    //   //setState(() => _isOnTop = false);
    // }
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  Future loadChatList() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData2('get-chat/${widget.chat.id}');
    var content = response.body;
    final collection = json.decode(content);
    var data = ConversationModel.fromJson(collection);

    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      convLists = data;
      //messages = convLists;
      loading = false;
      // double val = convLists.chats.length.toDouble();
      // print(val);
      //_scrollToBottom(convLists.chats.length-1);
    });
    //print(convLists.chats.length);

    for (int i = 0; i < convLists.chats.length; i++) {
      //messages.add(convLists.chats[i].msg);
      //print(convLists.chats[i].msg);
      //print(convLists.chats[i].msgSender);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: widget.chat.isOnline == 1
                          ? EdgeInsets.only(top: 0)
                          : EdgeInsets.only(top: 10),
                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                      padding: EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        radius: 16.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: widget.chat.profilePic == "" ||
                                widget.chat.profilePic == null
                            ? AssetImage('assets/images/man.png')
                            : NetworkImage("${widget.chat.profilePic}"),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.grey[300], // border color
                        shape: BoxShape.circle,
                      ),
                    ),
                    widget.chat.isOnline == 1
                        ? Container(
                            margin: EdgeInsets.only(left: 25, bottom: 5),
                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 3.0,
                              backgroundColor: Colors.greenAccent,
                              //backgroundImage: AssetImage('assets/user.png'),
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.greenAccent, // border color
                              shape: BoxShape.circle,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.chat.firstName[0].toUpperCase() + widget.chat.firstName.substring(1)} ${widget.chat.lastName[0].toUpperCase() + widget.chat.lastName.substring(1)}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
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
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: new Container(
                  //padding: EdgeInsets.only(top: 10),
                  //color: chat_page_back,
                  //color: chat_back,
                  child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      //padding: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: convLists.chats.length,
                          //reverse: true,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                //padding: EdgeInsets.only(top: 5),
                                child: widget.userData['id'] ==
                                        convLists.chats[index].msgSender
                                    ? MyChatBubble(convLists.chats[index])
                                    : FriendChatBubble(convLists.chats[index],
                                        widget.chat.profilePic),

                                // child: index % 2 == 0
                                //     ? Container(
                                //         child: ListTile(
                                //           title: index == 0
                                //               ////// <<<<< Date >>>>> //////
                                //               ? Container(
                                //                   alignment: Alignment.center,
                                //                   child: Text(
                                //                       "${messages[index]}",
                                //                       style: TextStyle(
                                //                           color: Colors.black54,
                                //                           fontSize: 12,
                                //                           fontFamily: 'Oswald',
                                //                           fontWeight:
                                //                               FontWeight.w400)),
                                //                 )

                                //               ////// <<<<< My Chat Bubble Start >>>>> //////
                                //               : MyChatBubble(index: index),
                                //           ////// <<<<< My Chat Bubble End>>>>> //////
                                //         ),
                                //       )

                                //     ////// <<<<< Friend Chat Bubble Start >>>>> //////
                                //     : FriendChatBubble(index: index)
                                ////// <<<<< Friend Chat Bubble End >>>>> //////
                              )),
                    ),
                  ),
                  Container(
                    height: 2,
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),

                  ////// <<<<< Message Box >>>>> //////
                  Container(
                    color: back,
                    child: Row(
                      children: <Widget>[
                        ////// <<<<< Message Box Attachment Icon >>>>> //////
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.add,
                            color: Colors.black38,
                          ),
                        ),

                        ////// <<<<< Message Box Text Field >>>>> //////
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
                                        controller: msgController,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Type a message here...",
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
                                            msg = value;
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

                        ////// <<<<< Message Send Icon Button >>>>> //////
                        GestureDetector(
                          onTap: () {
                            chatMsg();
                            // if (msg != '') {
                            //   int dex = messages.length;
                            //   double idex = dex.toDouble();
                            //   print(idex);
                            //   setState(() {
                            //     //messages.insert(0, msg);
                            //     messages.add(msg);
                            //     //print("success");
                            //     msgController.text = '';
                            //     st = "2";
                            //     // _scrollController.animateTo(
                            //     //   idex,
                            //     //   curve: Curves.easeOut,
                            //     //   duration: const Duration(milliseconds: 300),
                            //     // );
                            //   });
                            // } else {}
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
              )),
            ),
    );
  }

  void chatMsg() {
    if (msgController.text.isEmpty) {
      //return _showMsg("Comment field is empty");
    } else {
      chatMsgSend();
    }
  }

  Future chatMsgSend() async {
    setState(() {
      loading = true;
    });

    var data = {
      'msg': msgController.text,
      'con_id': widget.chat.id,
      'conType': widget.chat.conType,
      'reciever': receiver,
    };

    print(data);

    var res = await CallApi().postData1(data, 'insert-chat');
    //var body = json.decode(res.body);
    var body1 = res.statusCode;
    print(body1);

    if (body1 == 200) {
      msgController.text = "";
    } else{
      print("Something went wrong");
      //_showMsg(body['errorMessage']);
    }

    setState(() {
      loading = false;
    });

    loadChatList();
  }
}
